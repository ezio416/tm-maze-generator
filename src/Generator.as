// c 2024-06-27
// m 2024-06-27

namespace Generator {
    Maze@ Random(MazeType type, uint width, uint height, float percentChance = 0.5f) {
        Maze@ maze = Maze(type, width, height);

        if (percentChance == 0.0f)
            return maze;

        if (type == MazeType::Blocked) {
            for (uint i = 0; i < width; i++) {
                for (uint j = 0; j < height; j++) {
                    if (Math::Rand(0.0f, 1.0f) < percentChance)
                        maze.data.InsertLast({ i, j });
                }
            }
        } else {
            // vertical
            for (uint i = 1; i < width; i++) {
                for (uint j = 0; j < height; j++) {
                    if (Math::Rand(0.0f, 1.0f) < percentChance)
                        maze.data.InsertLast({ i - 1, j, i, j });
                }
            }

            // horizontal
            for (uint i = 0; i < width; i++) {
                for (uint j = 1; j < height; j++) {
                    if (Math::Rand(0.0f, 1.0f) < percentChance)
                        maze.data.InsertLast({ i, j - 1, i, j });
                }
            }
        }

        return maze;
    }
}
