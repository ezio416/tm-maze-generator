namespace Generator {
    class Cell {
        Cell@ parent;

        Cell@ get_root() {
            return parent !is null ? parent.root : this;
        }

        void Connect(Cell@ cell) {
            @cell.root.parent = this;
        }

        bool Connected(Cell@ cell) {
            return root is cell.root;
        }
    }

    Maze@ Random(MazeType type, uint width, uint height, float percentChance = 0.5f) {
        Maze@ maze = Maze(type, width, height);

        if (percentChance == 0.0f) {
            return maze;
        }

        if (type == MazeType::Blocked) {
            for (uint i = 0; i < width; i++) {
                for (uint j = 0; j < height; j++) {
                    if (Math::Rand(0.0f, 1.0f) < percentChance) {
                        maze.data.InsertLast({ i, j });
                    }
                }
            }
        } else {
            // vertical
            for (uint i = 1; i < width; i++) {
                for (uint j = 0; j < height; j++) {
                    if (Math::Rand(0.0f, 1.0f) < percentChance) {
                        maze.data.InsertLast({ i - 1, j, i, j });
                    }
                }
            }

            // horizontal
            for (uint i = 0; i < width; i++) {
                for (uint j = 1; j < height; j++) {
                    if (Math::Rand(0.0f, 1.0f) < percentChance) {
                        maze.data.InsertLast({ i, j - 1, i, j });
                    }
                }
            }
        }

        return maze;
    }

    Maze@ WalledKruskal(uint width, uint height) {
        Maze@ maze = Maze(MazeType::Walled, width, height);

        dictionary@ cells = dictionary();
        for (uint i = 0; i < width; i++) {
            for (uint j = 0; j < height; j++) {
                cells[tostring(i) + "," + j] = Cell();
            }
        }

        uint[][] edges;

        // vertical
        for (uint i = 1; i < width; i++) {
            for (uint j = 0; j < height; j++) {
                edges.InsertLast({ i - 1, j, i, j });
            }
        }

        // horizontal
        for (uint i = 0; i < width; i++) {
            for (uint j = 1; j < height; j++) {
                edges.InsertLast({ i, j - 1, i, j });
            }
        }

        while (edges.Length > 0) {
            const uint index = Math::Rand(0, edges.Length);
            const uint[] edge = edges[index];

            Cell@ cellA = cast<Cell@>(cells[tostring(edge[0]) + "," + edge[1]]);
            Cell@ cellB = cast<Cell@>(cells[tostring(edge[2]) + "," + edge[3]]);

            if (!cellA.Connected(cellB)) {
                cellA.Connect(cellB);
            } else {
                maze.data.InsertLast(edge);
            }

            edges.RemoveAt(index);
        }

        return maze;
    }
}
