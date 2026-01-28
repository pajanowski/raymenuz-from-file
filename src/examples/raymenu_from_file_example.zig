const std = @import("std");
const raymenuz = @import("raymenuz");
const rmf = raymenuz.raymenu_from_file;
const RayMenuFromFile = rmf.RayMenuFromFile;
const rl = @import("raylib");
const rg = @import("raygui");

const Player = struct {
    rec: rl.Rectangle,
    speed: rl.Vector2,
    name: []const u8,

    const Self = @This();

    pub fn init(
        name: []const u8,
        startingPos: rl.Vector2
    ) Self {
        return Self{
            .name = name,
            .rec = rl.Rectangle{
                .height = 10,
                .width = 10,
                .x = startingPos.x,
                .y = startingPos.y
            },
            .speed = rl.Vector2{
                .x = 2,
                .y = 2
            }
        };
    }
};

const State = struct {
   player: *Player
};

pub fn main() !void {
    // Prints to stderr, ignoring potential errors.
    const screen_width = 800;
    const screen_height = 450;

    rl.initWindow(screen_width, screen_height, "raylib [core] example - basic window");
    defer rl.closeWindow(); // Close window and OpenGL context

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second

    var player = Player.init(
        "ray",
        rl.Vector2{.x = screen_width / 2, .y = screen_height / 2}
    );
    var state = State{.player = &player};
    const allocator = std.heap.page_allocator;
    var menu = RayMenuFromFile(State)
        .init("src/examples/menu.yaml", &state, allocator);

    while (!rl.windowShouldClose()) // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------
        if (rl.isKeyDown(rl.KeyboardKey.left)) {
            player.rec.x -= player.speed.x;
        }
        if (rl.isKeyDown(rl.KeyboardKey.right)) {
            player.rec.x += player.speed.x;
        }
        if (rl.isKeyDown(rl.KeyboardKey.up)) {
            player.rec.y -= player.speed.y;
        }
        if (rl.isKeyDown(rl.KeyboardKey.down)) {
            player.rec.y += player.speed.y;
        }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.drawRectanglePro(player.rec, rl.Vector2{.x = player.rec.width / 2, .y = player.rec.height / 2}, 0, rl.Color.red);
        rl.clearBackground(rl.Color.ray_white);
        rl.drawText("Congrats! You created your first window!", 190, 200, 20, rl.Color.light_gray);
        //----------------------------------------------------------------------------------

        menu.draw();
        if (rl.isKeyPressed(rl.KeyboardKey.r)) {
            try menu.reloadMenuItems();
        }
    }
}