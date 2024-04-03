const glfw = @import("glfw.zig").glfw;
const std = @import("std");

pub const drawutils_t = struct {
    pub fn draw_unfilled_circle(self: drawutils_t, cx: f64, cy: f64, r: f64, num_segments: f32) !void {
        _ = self;
        glfw.glBegin(glfw.GL_LINE_LOOP);
        var ii: f64 = 0;
        while (ii<num_segments) {
            const theta: f64 = 2.0 * std.math.pi * ii / num_segments; //get the current angle 
            const x: f64 = r * std.math.cos(theta); //calculate the x component 
            const y = r * std.math.sin(theta); //calculate the y component 
            glfw.glVertex2f(@as(f32, @floatCast(x + cx)), @as(f32, @floatCast(y + cy))); //output vertex 
            ii+=1;
        }
        glfw.glEnd();
    }

    pub fn draw_filled_rect(self: drawutils_t, x: f64, y: f64, w: f64, h: f64) !void {
        _ = self;
        glfw.glRectf(
            @as(f32, @floatCast(x)),
            @as(f32, @floatCast(y)),
            @as(f32, @floatCast(x + w)),
            @as(f32, @floatCast(y + h))
        ); //output vertex 
    }
};

pub const drawutils = drawutils_t {};