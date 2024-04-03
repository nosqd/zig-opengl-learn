const std = @import("std");
fn mkTarget(name: []const u8, file: std.Build.LazyPath, b: *std.Build, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode, lib: *std.Build.Module) !*std.Build.Step.Compile 
{
    const exe = b.addExecutable(.{
        .name = name,
        .root_source_file =file,
        .target = target,
        .optimize = optimize,
    });

    exe.root_module.addImport("nlib", lib);

    const run_exe = b.addRunArtifact(exe);
    const run_step = b.step(try std.fmt.allocPrint(b.allocator, "run-{s}", .{name}), try std.fmt.allocPrint(b.allocator, "run {s}", .{name}));
    run_step.dependOn(&run_exe.step);   

    return exe;
}

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const lib = b.createModule(.{
        .root_source_file = .{.path = "lib/lib.zig"},
        .target = target,
        .optimize = optimize
    });
    
    lib.addIncludePath(.{.path = "ext/glfw/include/"});
    lib.addLibraryPath(.{.path = "ext/glfw/bin"});
    
    lib.linkSystemLibrary("c", .{});
    lib.linkSystemLibrary("opengl32", .{});
    lib.linkSystemLibrary("gdi32", .{});
    lib.linkSystemLibrary("glfw3", .{});

    const bouncingRect = try mkTarget("bouncyrect", .{.path = "apps/bouncing-rect.zig"}, b, target, optimize, lib);
    b.installArtifact(bouncingRect);
}
