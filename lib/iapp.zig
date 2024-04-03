const std = @import("std");
const glfw = @import("./glfw.zig").glfw;

pub const AppState = struct {
    delta: f64,
    win: ?*glfw.GLFWwindow
};

pub const AppInitParams = struct {
    title: [*c]const u8,
    width: c_int,
    height: c_int
};

pub const PreInitFn = fn() AppInitParams;
pub const PostInitFn = fn(AppState) void;
pub const UpdateFn = fn(AppState) void;
pub const DrawFn = fn(AppState) void;

pub fn run_app(
    pre_init: PreInitFn,
    post_init: PostInitFn,
    update: UpdateFn,
    draw: DrawFn
) !void {
    const init_data = pre_init();
    if (glfw.glfwInit() == glfw.GLFW_FALSE) {
        std.debug.print("glfw fucked you", .{});
        std.process.exit(1);
    }
    const win = glfw.glfwCreateWindow(init_data.width, init_data.height, init_data.title, null, null);
    if (win == null) {
        std.debug.print("glfw fucked you", .{});
        std.process.exit(1);
    }

    glfw.glfwMakeContextCurrent(win);
    var state = AppState {
        .delta = 0,
        .win = win
    };
    var last_dt: f64 = 0;
    post_init(state);
    
    while (glfw.glfwWindowShouldClose(win) == 0) {
        draw(state);
        
        glfw.glfwSwapBuffers(win);
        glfw.glfwPollEvents();

        update(state);

        state.delta = glfw.glfwGetTime() - last_dt;
        last_dt = glfw.glfwGetTime();
    }
}