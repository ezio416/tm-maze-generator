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

    Json::Value@ ToJson() {
        Json::Value@ json = Json::Object();

        json["name"] = name;
        json["type"] = int(type);

        Json::Value@ size = Json::Array();
        size.Add(Json::Value(width));
        size.Add(Json::Value(height));
        json["size"] = size;

        Json::Value@ data = Json::Array();
        for (uint i = 0; i < this.data.Length; i++) {
            Json::Value@ datum = Json::Array();
            for (uint j = 0; j < uint(type == MazeType::Blocked ? 2 : 4); j++)
                datum.Add(Json::Value(this.data[i][j]));
                data.Add(datum);
        }
        json["data"] = data;

        return json;
    }

    string ToString() {
        return Json::Write(ToJson());
    }
}

void LoadMazes(const string &in path) {
    if (!IO::FileExists(path)) {
        warn("file not found: " + path);
        return;
    }

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
            Maze@ maze = Maze(loaded[i]);
            trace("loaded maze: " + tostring(maze));
            mazes.InsertLast(maze);
        } catch {
            warn(getExceptionInfo());
        }
    }

    trace("mazes loaded: " + mazes.Length);
}

void SaveMazes(const string &in path) {
    Json::Value@ saved = Json::Array();

    for (uint i = 0; i < mazes.Length; i++) {
        Maze@ maze = mazes[i];
        saved.Add(maze.ToJson());
    }

    Json::ToFile(path, saved);

    trace("mazes saved");
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

                const string key = tostring(x) + "," + y + "," + z + "," + w;
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
