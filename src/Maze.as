// c 2024-06-26
// m 2024-06-26

enum MazeType {
    Blocked,
    Walled
}

class Maze {
    uint[][] data;
    uint     height;
    string   name;
    MazeType type;
    uint     width;

    Maze() { }
    Maze(Json::Value@ maze) {
        if (!VerifyMaze(maze))
            throw("invalid maze");

        name   = string(maze["name"]);
        width  = uint(maze["size"][0]);
        height = uint(maze["size"][1]);
        type   = MazeType(int(maze["type"]));

        for (uint i = 0; i < maze["data"].Length; i++) {
            uint[] datum;

            for (uint j = 0; j < uint(type == MazeType::Blocked ? 2 : 4); j++)
                datum.InsertLast(uint(maze["data"][i][j]));

            data.InsertLast(datum);
        }
    }
}

void LoadMazes(const string &in path) {
    Json::Value@ loaded = Json::FromFile(path);

    if (loaded.GetType() != Json::Type::Array) {
        warn("loaded not an array: " + tostring(loaded.GetType()));
        return;
    }

    if (loaded.Length == 0) {
        warn("loaded empty");
        return;
    }

    mazes = {};

    for (uint i = 0; i < loaded.Length; i++) {
        try {
            mazes.InsertLast(Maze(loaded[i]));
        } catch {
            warn(getExceptionInfo());
        }
    }

    print("mazes loaded: " + mazes.Length);
}

bool VerifyMaze(Json::Value@ maze) {
    try {
        string(maze["name"]);

        const int width = int(maze["size"][0]);
        if (width < 1)
            return false;
        const int height = int(maze["size"][1]);
        if (height < 1)
            return false;

        const MazeType type = MazeType(int(maze["type"]));
        if (type < MazeType::Blocked || type > MazeType::Walled)
            return false;

        Json::Value@ data = maze["data"];

        if (type == MazeType::Blocked) {
            if (data.Length > uint(width * height))
                return false;

            int x, y;
            dictionary@ seen = dictionary();

            for (uint i = 0; i < data.Length; i++) {
                if (data[i].Length != 2)
                    return false;

                x = int(data[i][0]);
                if (x < 0 || x >= width)
                    return false;

                y = int(data[i][1]);
                if (y < 0 || y >= height)
                    return false;

                const string key = tostring(x) + y;
                if (seen.Exists(key))
                    return false;

                seen[key] = true;
            }
        } else {
            if (data.Length > WallCount(width, height))
                return false;

            int x, y, z, w;
            dictionary@ seen = dictionary();

            for (uint i = 0; i < data.Length; i++) {
                if (data[i].Length != 4)
                    return false;

                x = int(data[i][0]);
                if (x < 0 || x >= width)
                    return false;

                y = int(data[i][1]);
                if (y < 0 || y >= height)
                    return false;

                z = int(data[i][2]);
                if (z < 0 || z >= width || z < x || z > x + 1)
                    return false;

                w = int(data[i][3]);
                if (w < 0 || w >= height || w < y || w > y + 1)
                    return false;

                if ((z == x && w == y) || (z > x && w > y))
                    return false;

                const string key = tostring(x) + y + z + w;
                if (seen.Exists(key))
                    return false;

                seen[key] = true;
            }
        }

        return true;
    } catch { }

    return false;
}

uint WallCount(int x, int y) {
    if (x < 1 || y < 1)
        return 0;

    return (2 * x * y) - x - y;
}
