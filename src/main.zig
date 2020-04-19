const std = @import("std");
const c = @import("c.zig");

const panic = std.debug.panic;

fn errorCallback(err: c_int, description: [*c]const u8) callconv(.C) void {
    panic("Error: {}\n", .{@as([*:0]const u8, description)});
}

var window: *c.GLFWwindow = undefined;

pub fn main() !void {
    _ = c.glfwSetErrorCallback(errorCallback);

    if (c.glfwInit() == c.GL_FALSE) {
        panic("GLFW init falure.\n", .{});
    }
    defer c.glfwTerminate();

    // settings?
    c.glfwWindowHint(c.GLFW_SAMPLES, 4);
    c.glfwWindowHint(c.GLFW_CONTEXT_VERSION_MAJOR, 3);
    c.glfwWindowHint(c.GLFW_CONTEXT_VERSION_MINOR, 3);
    c.glfwWindowHint(c.GLFW_OPENGL_PROFILE, c.GLFW_OPENGL_CORE_PROFILE);

    window = c.glfwCreateWindow(1024, 768, "Tutorial 01", null, null) orelse {
        panic("Failed to create window.\n", .{});
    };

    c.glfwMakeContextCurrent(window); // initialize GLEW
    c.glewExperimental = 1; // needed for core profile

    if (c.glewInit() != c.GLEW_OK) {
        panic("Flaied to initialize GLEW.\n", .{});
    }

    c.glfwSetInputMode(window, c.GLFW_STICKY_KEYS, c.GL_TRUE);

    while (true) {
        c.glClear(c.GL_COLOR_BUFFER_BIT);
        c.glfwSwapBuffers(window);
        c.glfwPollEvents();

        const should_quit = c.glfwGetKey(window, c.GLFW_KEY_ESCAPE) == c.GLFW_PRESS or c.glfwWindowShouldClose(window) != 0;

        if (should_quit) break;
    }

    std.debug.warn("All your codebase are belong to us.\n", .{});
}
