# ziggl-notes

There are some notes that I made when learning Zig + OpenGL + GLFW

## apps included

- [bouncyrect.zig](./apps/bouncyrect.zig) - just bouncing rect using my [iapp system](#iapp-system)
- [bouncyrect-old.zig](./apps/bouncyrect-old.zig) - just bouncing rect without [iapp system](#iapp-system)

## iapp system
some thing that allows easily init_app

example of iapp app
```zig
const std = @import("std");
const glfw = @import("nlib").glfw;
const drawutils = @import("nlib").drawutils;
const AppState = @import("nlib").AppState;
const AppInitParams = @import("nlib").AppInitParams;
const run_app = @import("nlib").run_app;

fn pre_init() AppInitParams {
    return .{
        .title = "example app",
        .width = 800,
        .height = 600
    };
}

fn post_init(state: AppState) void {
    _ = state;
}
fn update(state: AppState) void {}
fn draw(state: AppState) void {
    glfw.glClearColor(0.096, 0.096, 0.096, 1);
    glfw.glClear(glfw.GL_COLOR_BUFFER_BIT);
}
pub fn main() !void {
    try run_app(pre_init, post_init, update, draw);
}
```