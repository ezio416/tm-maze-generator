// c 2024-06-25
// m 2024-06-27

Maze@[]      mazes;
const string savedFile = IO::FromStorageFolder("saved.json");
const float  scale     = UI::GetScale();
const string title     = "\\$FFF" + Icons::ThLarge + "\\$G Maze Generator";

void Main() {
    LoadMazes(savedFile);
    ChangeFont();
}

void OnSettingsChanged() {
    if (S_DimensionX < 1)
        S_DimensionX = 1;

    if (S_DimensionY < 1)
        S_DimensionY = 1;

    if (currentFont != S_Font)
        ChangeFont();
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

    int x = Round(S_X * displayWidth);
    int y = Round(S_Y * displayHeight);
    int w = S_Width;
    int h = S_Height;

    if (S_MoveResize) {
        int flags = UI::WindowFlags::NoCollapse |
                    UI::WindowFlags::NoSavedSettings |
                    UI::WindowFlags::NoScrollbar;

        UI::SetNextWindowPos(Round(x / scale), Round(y / scale));
        UI::SetNextWindowSize(Round(w / scale), Round(h / scale));

        UI::Begin(Icons::ArrowsAlt + " Maze Generator", flags);
            vec2 pos = UI::GetWindowPos();
            vec2 size = UI::GetWindowSize();
        UI::End();

        S_X = pos.x / displayWidth;
        S_Y = pos.y / displayHeight;
        S_Width = Round(size.x);
        S_Height = Round(size.y);
    }

    if (S_Background) {
        nvg::BeginPath();
        nvg::Rect(
            vec2(x, y),
            vec2(w, h)
        );
        nvg::FillColor(S_BackColor);
        nvg::Fill();
    }

    const float blockWidth  = float(w) / S_DimensionX;
    const float blockHeight = float(h) / S_DimensionY;

    // blocks/walls
    if (S_Type == MazeType::Blocked) {
        Maze@ maze = mazes[0];

        nvg::FillColor(S_BlockColor);

        for (uint i = 0; i < maze.data.Length; i++) {
            nvg::BeginPath();
            nvg::Rect(x + blockWidth * maze.data[i][0], y + blockHeight * maze.data[i][1], blockWidth, blockHeight);
            nvg::Fill();
        }
    } else {
        Maze@ maze = mazes[1];

        nvg::StrokeWidth(S_WallThickness);
        nvg::StrokeColor(S_WallColor);
        nvg::BeginPath();

        for (uint i = 1; i < maze.width; i++) {
            for (uint j = 0; j < maze.height; j++) {
                if (maze.data.Find({ i - 1, j, i, j }) > -1)
                    continue;

                const float lineX = x + blockWidth * i;
                nvg::MoveTo(vec2(lineX, y + blockHeight * j));
                nvg::LineTo(vec2(lineX, y + blockHeight * (j + 1)));
            }
        }

        for (uint i = 0; i < maze.width; i++) {
            for (uint j = 1; j < maze.height; j++) {
                if (maze.data.Find({ i, j - 1, i, j }) > -1)
                    continue;

                const float lineY = y + blockHeight * j;
                nvg::MoveTo(vec2(x + blockWidth * i,       lineY));
                nvg::LineTo(vec2(x + blockWidth * (i + 1), lineY));
            }
        }

        nvg::Stroke();
    }

    if (S_Grid) {
        nvg::StrokeWidth(S_GridThickness);
        nvg::StrokeColor(S_GridColor);
        nvg::BeginPath();
        for (uint i = 1; i < S_DimensionX; i++) {
            const float blockX = x + blockWidth * i;
            nvg::MoveTo(vec2(blockX, y));
            nvg::LineTo(vec2(blockX, y + h));
        }
        for (uint i = 1; i < S_DimensionY; i++) {
            const float blockY = y + blockHeight * i;
            nvg::MoveTo(vec2(x,     blockY));
            nvg::LineTo(vec2(x + w, blockY));
        }
        nvg::Stroke();
    }

    if (S_Coords) {
        for (uint i = 0; i < S_DimensionX; i++) {
            for (uint j = 0; j < S_DimensionY; j++) {
                nvg::FillColor(S_FontColor);
                nvg::FontFace(font);
                nvg::FontSize(S_FontSize);
                nvg::TextAlign(nvg::Align::Middle | nvg::Align::Center);
                nvg::Text(vec2(x + blockWidth * (i + 0.5f), y + blockHeight * (j + 0.5f)), tostring(i) + "," + j);
            }
        }
    }

    if (S_Border) {
        nvg::StrokeWidth(S_BorderThickness);
        nvg::StrokeColor(S_BorderColor);
        nvg::BeginPath();
        nvg::Rect(
            vec2(x, y),
            vec2(w, h)
        );
        nvg::Stroke();
    }
}

void RenderMenu() {
    if (UI::MenuItem(title, "", S_Enabled))
        S_Enabled = !S_Enabled;
}
