// c 2024-06-25
// m 2024-06-26

Maze@[]      mazes;
vec4[]       randomColors;
const float  scale = UI::GetScale();
const string title = "\\$FFF" + Icons::ThLarge + "\\$G Maze Generator";

void Main() {
    LoadMazes("test.json");

    for (uint i = 0; i < 64; i++)
        randomColors.InsertLast(RandomColor());
}

void OnSettingsChanged() {
    if (S_DimensionX < 1)
        S_DimensionX = 1;

    if (S_DimensionY < 1)
        S_DimensionY = 1;
}

void Render() {
    if (false
        || !S_Enabled
        || (S_HideWithGame && !UI::IsGameUIVisible())
        || (S_HideWithOP && !UI::IsOverlayShown())
        || mazes.Length < 2
    )
        return;

    int displayWidth = Draw::GetWidth();
    int displayHeight = Draw::GetHeight();

    int x = int(S_X * displayWidth);
    int y = int(S_Y * displayHeight);
    int w = S_Width;
    int h = S_Height;

    if (S_MoveResize) {
        int flags = UI::WindowFlags::NoCollapse |
                    UI::WindowFlags::NoSavedSettings |
                    UI::WindowFlags::NoScrollbar;

        UI::SetNextWindowPos(int(x / scale), int(y / scale));
        UI::SetNextWindowSize(int(w / scale), int(h / scale));

        UI::Begin(Icons::ArrowsAlt + " Maze Generator", flags);
            vec2 pos = UI::GetWindowPos();
            vec2 size = UI::GetWindowSize();
        UI::End();

        S_X = pos.x / displayWidth;
        S_Y = pos.y / displayHeight;
        S_Width = int(size.x);
        S_Height = int(size.y);
    }

    // background
    nvg::BeginPath();
    nvg::Rect(
        vec2(x, y),
        vec2(w, h)
    );
    nvg::FillColor(S_BackColor);
    nvg::Fill();

    const float blockWidth  = float(w) / S_DimensionX;
    const float blockHeight = float(h) / S_DimensionY;

    // square centers
    // for (uint i = 0; i < S_DimensionX; i++) {
    //     for (uint j = 0; j < S_DimensionY; j++) {
    //         nvg::FillColor(randomColors[((i * S_DimensionY) + j) % randomColors.Length]);
    //         nvg::BeginPath();
    //         nvg::Circle(vec2(x + blockWidth * (i + 0.5f), y + blockHeight * (j + 0.5f)), 10.0f);
    //         nvg::Fill();
    //     }
    // }

    // blocks/walls
    if (S_Type == MazeType::Blocked) {
        Maze@ maze = mazes[0];

        for (uint i = 0; i < maze.data.Length; i++) {
            const uint blockX = maze.data[i][0];
            const uint blockY = maze.data[i][1];

            nvg::FillColor(randomColors[i % randomColors.Length]);
            nvg::BeginPath();
            nvg::Rect(x + (blockX * blockWidth), y + (blockY * blockHeight), blockWidth, blockHeight);
            nvg::Fill();
        }
    } else {
        ;
    }

    if (S_Grid) {
        nvg::StrokeWidth(S_GridThickness);
        nvg::StrokeColor(S_GridColor);
        nvg::BeginPath();
        for (uint i = 1; i < S_DimensionX; i++) {
            nvg::MoveTo(vec2(x + (blockWidth * i), y));
            nvg::LineTo(vec2(x + (blockWidth * i), y + h));
        }
        for (uint i = 1; i < S_DimensionY; i++) {
            nvg::MoveTo(vec2(x,     y + (blockHeight * i)));
            nvg::LineTo(vec2(x + w, y + (blockHeight * i)));
        }
        nvg::Stroke();
    }

    // border
    nvg::StrokeWidth(S_BorderThickness);
    nvg::StrokeColor(S_BorderColor);
    nvg::BeginPath();
    nvg::Rect(
        vec2(x, y),
        vec2(w, h)
    );
    nvg::Stroke();
}

void RenderMenu() {
    if (UI::MenuItem(title, "", S_Enabled))
        S_Enabled = !S_Enabled;
}
