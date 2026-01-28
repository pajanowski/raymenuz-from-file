# raymenuz-from-file
## A raymenuz wrapper for quick menus written in zig
- - -
### Main Features:
- Easy API for creating raygui menus fast
- Yaml File defined menus
- Hot reloading

 - - -
### Installation
These directions assume that you already have a working raylib project.

raymenuz requires 2 libraries
- raylib-zig https://github.com/raylib-zig/raylib-zig
- raygui (included in raylib-zig)
- raymenuz 
- ymlz https://github.com/pwbh/ymlz (only if using YAML defined menus)

Install with
`zig fetch --save git+https://github.com/pajanowski/raymenuz-from-file.git#HEAD`

In your `build.zig`
```zig
    const raylib_dep = b.dependency("raylib-zig", .{
    .target = target,
    .optimize = optimize,
});
const raylib_mod = raylib_dep.module("raylib");
const raygui_mod = raylib_dep.module("raygui");

const raymenuz = b.dependency("raymenuz", .{});
const ymlz = b.dependency("ymlz", .{});

const mod = b.addModule("your_module", .{
    .root_source_file = b.path("src/root.zig"),
    .target = target,
    .optimize = optimize,
});

const raymenuz_mod = raymenuz.module("raymenuz");
raymenuz_mod.addImport("raylib", raylib_mod);
raymenuz_mod.addImport("raygui", raygui_mod);
raymenuz_mod.addImport("ymlz", ymlz.module("root"));

mod.addImport("raymenuz", raymenuz_mod);
```

- - - 
### Usage (File defined)

`RayMenuFromFile` allows you to define your menu in a YAML file and hot-reload it during development.

[Example](../raymenuz-from-file/src/examples/raymenu_from_file_example.zig)
```zig
var rayMenu = RayMenuFromFile(GameState).init(
    "src/menu.yaml",
    &state,
    allocator
);

while (!rl.windowShouldClose()) { 
    rl.beginDrawing();
    defer rl.endDrawing();
    rl.clearBackground(rl.Color.ray_white);
    
    rayMenu.draw();

    if (rl.isKeyPressed(rl.KeyboardKey.r)) {
        rayMenu.reloadMenuItems() catch |err| {
            std.log.err("Failed to reload menu items {any}", .{err});
        };
    }
}
```

[Example YAML](../raymenuz-from-file/src/examples/menu.yaml)
```yaml
drawSettings:
  paddingY: 5
  startX: 5
  width: 75
  height: 10
  nameHeight: 10
  namePadding: 0
  buttonHeight: 20
  checkboxSize: 10
  toggleGroupButtonWidth: 45
itemDefs:
  - elementType: SLIDER
    statePath: player.gravity
    displayValuePrefix: Gravity
    menuItemType: float
    range:
      upper: 0
      lower: -400
  - elementType: VALUE_BOX
    statePath: player.xSpeed
    displayValuePrefix: X Speed
    menuItemType: int
    range:
      upper: 1000
      lower: 0
  - elementType: LABEL
    statePath: player.vel.y
    displayValuePrefix: Vel Y
    menuItemType: float
    range:
      upper: -1
      lower: -1
```

There is also a working example in [src/examples/raymenu_from_file_example.zig](../raymenuz-from-file/src/examples/raymenu_from_file_example.zig).

- - - 
### Menu Definition

#### drawSettings &rarr; DrawSettings defined in [menu_utils.zig](src/menu_utils.zig)
| Field                  | Description                                                                                                        | Allowed Values |
|:-----------------------|:-------------------------------------------------------------------------------------------------------------------|:---------------|
| paddingY               | Vertical space between elements                                                                                    | Any integer    |
| startX                 | Horizontal space between left side of screen and elements this does not account for text in the displayValuePrefix | Any integer    | 
| width                  | Width of elements                                                                                                  | Any integer    | 
| height                 | Height of elements                                                                                                 | Any integer    | 
| buttonHeight           | Height of buttons                                                                                                  | Any integer    |
| checkboxSize           | Size of checkboxes                                                                                                 | Any integer    |
| toggleGroupButtonWidth | Width of buttons in a toggle group                                                                                 | Any integer    |

#### itemDefs, list of YamlItemDef defined in [menu_utils.zig](src/menu_utils.zig)
| Field              | Description                                                                     | Allowed Values                                     |
|:-------------------|:--------------------------------------------------------------------------------|:---------------------------------------------------|
| elementType        | Element type                                                                    | SLIDER, VALUE_BOX, LABEL                           |
| statePath          | Path in provided state value                                                    | Any string that maps to a value in the struct type | 
| displayValuePrefix | The label displayed to the left of the element                                  | Any String                                         | 
| menuItemType       | Type of value at statePath, currently float, int, and string are only supported | float, int, string                                 | 
| range              | Range for number based elements                                                 | Valid struct definition                            | 


#### range, Range defined in [menu_utils.zig](src/menu_utils.zig)
While only used for number-based elements, it is still required for all elements for the sake of parsing and memory alignment.

| Field | Description | Allowed Values               |
|:------|:------------|:-----------------------------|
| lower | Lower bound | Any float less than upper    |
| upper | Upper bound | Any float greater than upper |

### raygui elements

| Element          | File Defined Status | File Defined elementType value | File Defined Supported menuItemType |
|:-----------------|:--------------------|--------------------------------|:------------------------------------|
| **Slider**       | Supported           | `SLIDER`                       | `float`                             |
| **ValueBox**     | Supported           | `VALUE_BOX`                    | `int`                               |
| **Label**        | Supported           | `LABEL`                        | `int`, `float`, `string`            |
| **Button**       | Unsupported         |                                | -                                   |
| **LabelButton**  | Unsupported         |                                | -                                   |
| **CheckBox**     | Unsupported         |                                | -                                   |
| **Toggle**       | Unsupported         |                                | -                                   |
| **ToggleGroup**  | Unsupported         |                                | -                                   |
| **ToggleSlider** | Unsupported         |                                | -                                   |
| **ComboBox**     | Unsupported         |                                | -                                   |
| **DropdownBox**  | Unsupported         |                                | -                                   |
| **TextBox**      | Unsupported         |                                | -                                   |
| **Spinner**      | Unsupported         |                                | -                                   |
| **SliderBar**    | Unsupported         |                                | -                                   |
| **ProgressBar**  | Unsupported         |                                | -                                   |
| **StatusBar**    | Unsupported         |                                | -                                   |
| **DummyRec**     | Unsupported         |                                | -                                   |
| **Grid**         | Unsupported         |                                | -                                   |
| **Line**         | Unsupported         |                                | -                                   |
| **GroupBox**     | Unsupported         |                                | -                                   |
| **Window**       | Unsupported         | -                              | -                                   |
