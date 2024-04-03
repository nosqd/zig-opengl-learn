const std = @import("std");
const glfw = @import("nlib").glfw;
const drawutils = @import("nlib").drawutils;
const AppState = @import("nlib").AppState;
const AppInitParams = @import("nlib").AppInitParams;
const run_app = @import("nlib").run_app;

const SquarePosition = struct {
    x: f64,
    y: f64,
    velx: f64,
    vely: f64
};
const SQUARE_SIZE:f64 = 50;
const rand = std.crypto.random;
var win_width: c_int = 0;
var win_height: c_int = 0;
var square: SquarePosition = .{
    .x = 0,
    .y = 0,
    .velx = 0,
    .vely = 0
};

fn pre_init() AppInitParams {
    square.x = @floatFromInt(rand.intRangeAtMostBiased(i64, 1, 800-SQUARE_SIZE));
    square.y = @floatFromInt(rand.intRangeAtMostBiased(i64, 1, 800-SQUARE_SIZE));
    square.velx = @floatFromInt(rand.intRangeAtMostBiased(i64, 100, 200));
    square.vely = @floatFromInt(rand.intRangeAtMostBiased(i64, 100, 200));
    return .{
        .title = "bouncy rect",
        .width = 800,
        .height = 800
    };
}
fn post_init(state: AppState) void {
    _ = state;
}
fn update(state: AppState) void {
    square.x += square.velx * state.delta;
    square.y += square.vely * state.delta;
    if (square.x+SQUARE_SIZE > @as(f64,@floatFromInt(win_width)) or square.x < 0) {
        square.velx = -square.velx;
    }
    if (square.y+SQUARE_SIZE > @as(f64, @floatFromInt(win_height)) or square.y < 0) {
        square.vely = -square.vely;
    }
}
fn draw(state: AppState) void {
    glfw.glfwGetWindowSize(state.win, &win_width, &win_height);
    drawutils.swap_to_pixel_coords(state.win);

    glfw.glClearColor(0.096, 0.096, 0.096, 1);
    glfw.glClear(glfw.GL_COLOR_BUFFER_BIT);

    glfw.glColor4f(1,0,0,1);
    drawutils.draw_filled_rect(square.x, square.y, SQUARE_SIZE,SQUARE_SIZE) catch |err| {
        _ = err;
    };
}


pub fn main() !void {
    try run_app(pre_init, post_init, update, draw);
}
