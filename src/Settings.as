// c 2024-06-25
// m 2024-06-26

[Setting category="General" name="Enabled"]
bool S_Enabled = true;

[Setting category="General" name="Show/hide with game UI"]
bool S_HideWithGame = true;

[Setting category="General" name="Show/hide with Openplanet UI"]
bool S_HideWithOP = false;


[Setting category="Style" name="Grid dimension X" min=1 max=100]
uint S_DimensionX = 4;

[Setting category="Style" name="Grid dimension Y" min=1 max=100]
uint S_DimensionY = 4;

[Setting category="Style" name="Background color" color]
vec4 S_BackColor = vec4(0.0f, 0.0f, 0.0f, 0.7f);

[Setting category="Style" name="Maze type"]
MazeType S_Type = MazeType::Blocked;

[Setting category="Style" name="Block color" color]
vec4 S_BlockColor = vec4(1.0f, 1.0f, 1.0f, 1.0f);

[Setting category="Style" name="Wall thickness" min=0.0f max=10.0f]
float S_WallThickness = 1.0f;

[Setting category="Style" name="Wall color" color]
vec4 S_WallColor = vec4(1.0f, 1.0f, 1.0f, 1.0f);

[Setting category="Style" name="Show grid"]
bool S_Grid = false;

[Setting category="Style" name="Grid thickness" min=0.0f max=10.0f]
float S_GridThickness = 0.2f;

[Setting category="Style" name="Grid color" color]
vec4 S_GridColor = vec4(1.0f, 1.0f, 1.0f, 1.0f);

[Setting category="Style" name="Border thickness" min=0 max=10]
float S_BorderThickness = 3.0f;

[Setting category="Style" name="Border color" color]
vec4 S_BorderColor = vec4(1.0f, 1.0f, 1.0f, 1.0f);


[Setting category="Position" name="Move & resize window easily" description="ignores sliders below"]
bool S_MoveResize = false;

[Setting category="Position" name="Position X" min=0.0f max=1.0f]
float S_X = 0.4f;

[Setting category="Position" name="Position Y" min=0.0f max=1.0f]
float S_Y = 0.3f;

[Setting category="Position" name="Width" min=10 max=1920]
int S_Width = 400;

[Setting category="Position" name="Height" min=10 max=1080]
int S_Height = 400;
