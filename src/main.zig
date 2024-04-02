const std = @import("std");

const glfw = @cImport({
    @cInclude("GL/gl.h");
    @cInclude("GLFW/glfw3.h");
});

const BallPosition = struct {
    x: f64,
    y: f64,
    velx: f64,
    vely: f64
};

fn draw_circle(cx: f64, cy: f64, r: f64, num_segments: f32) !void {
    glfw.glBegin(glfw.GL_LINE_LOOP);
    var ii: f64 = 0;
    while (ii<num_segments) {
        const theta: f64 = 2.0 * std.math.pi * ii / num_segments;//get the current angle 
        const x: f64 = r * std.math.cos(theta);//calculate the x component 
        const y = r * std.math.sin(theta);//calculate the y component 
        glfw.glVertex2f(@as(f32, @floatCast(x + cx)), @as(f32, @floatCast(y + cy)));//output vertex 
        ii+=1;
    }
    glfw.glEnd();
}

const BALL_RADIUS:f64 = 0.09;

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
    var ball: BallPosition = .{
        .x = 0,
        .y = 0,
        .velx = 0.7,
        .vely = 0.9
    };

    while (glfw.glfwWindowShouldClose(win) == 0) {
        var width: c_int = 0;
        var height: c_int = 0;
        glfw.glfwGetWindowSize(win, &width, &height);
        glfw.glViewport(0,0, width, height);

        glfw.glClearColor(0.096, 0.096, 0.096, 1);
        glfw.glClear(glfw.GL_COLOR_BUFFER_BIT);

        glfw.glColor4f(1,0,0,1);
        try draw_circle(ball.x, ball.y, BALL_RADIUS, 100);

        glfw.glfwSwapBuffers(win);
        glfw.glfwPollEvents();
        ball.x += ball.velx * dt;
        ball.y += ball.vely * dt;
        if (ball.x+BALL_RADIUS/2 >= 1 or ball.x-BALL_RADIUS/2 <= -1) {
            ball.velx = -ball.velx;
        }
        if (ball.y+BALL_RADIUS/2 >= 1 or ball.y-BALL_RADIUS/2 <= -1) {
            ball.vely = -ball.vely;
        }

        dt = glfw.glfwGetTime() - last_dt;
        last_dt = glfw.glfwGetTime();
    }   

    glfw.glfwTerminate();
}
