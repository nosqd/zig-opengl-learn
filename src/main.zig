const std = @import("std");
const glfw = @import("glfw.zig").glfw;
const drawutils = @import("drawutils.zig").drawutils;

const SquarePosition = struct {
    x: f64,
    y: f64,
    velx: f64,
    vely: f64
};

const SQUARE_SIZE:f64 = 50;

pub fn main() !void {
    if (glfw.glfwInit() == glfw.GLFW_FALSE) {
        std.debug.print("glfw fucked you", .{});
        std.process.exit(1);
    }
    const win = glfw.glfwCreateWindow(800, 800, "Hello, world", null, null);
    if (win == null) {
        std.debug.print("glfw fucked you", .{});
        std.process.exit(1);
    }

    glfw.glfwMakeContextCurrent(win);

    var last_dt: f64 = 0;
    var dt: f64 = 0;
    const rand = std.crypto.random;
    var square: SquarePosition = .{
        .x = @floatFromInt(rand.intRangeAtMostBiased(i64, 1, 800-SQUARE_SIZE)),
        .y = @floatFromInt(rand.intRangeAtMostBiased(i64, 1, 800-SQUARE_SIZE)),
        .velx = @floatFromInt(rand.intRangeAtMostBiased(i64, 100, 200)),
        .vely = @floatFromInt(rand.intRangeAtMostBiased(i64, 100, 200))
    };

    while (glfw.glfwWindowShouldClose(win) == 0) {
        var width: c_int = 0;
        var height: c_int = 0;
        glfw.glfwGetWindowSize(win, &width, &height);
        glfw.glViewport(0,0, @intCast(width), @intCast(height));
        glfw.glMatrixMode(glfw.GL_PROJECTION); 
        glfw.glLoadIdentity(); 
        glfw.glOrtho(0, @floatFromInt(width), 0, @floatFromInt(height), -1, 1); 
        glfw.glMatrixMode(glfw.GL_MODELVIEW); 
        glfw.glLoadIdentity();

        glfw.glClearColor(0.096, 0.096, 0.096, 1);
        glfw.glClear(glfw.GL_COLOR_BUFFER_BIT);

        glfw.glColor4f(1,0,0,1);
        try drawutils.draw_filled_rect(square.x, square.y, SQUARE_SIZE,SQUARE_SIZE);

        glfw.glfwSwapBuffers(win);
        glfw.glfwPollEvents();

        // physics
        square.x += square.velx * dt;
        square.y += square.vely * dt;
        if (square.x+SQUARE_SIZE > @as(f64,@floatFromInt(width)) or square.x < 0) {
            square.velx = -square.velx;
        }
        if (square.y+SQUARE_SIZE > @as(f64, @floatFromInt(height)) or square.y < 0) {
            square.vely = -square.vely;
        }

        dt = glfw.glfwGetTime() - last_dt;
        last_dt = glfw.glfwGetTime();
    }   

    glfw.glfwTerminate();
}
