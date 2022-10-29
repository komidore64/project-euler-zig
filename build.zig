const std = @import("std");

const Lib = struct {
    name: []const u8,
    path: []const u8,
};

const libs = [_]Lib{
    .{
        .name = "euler",
        .path = "src/lib/euler.zig",
    },
};

// https://projecteuler.net/problems
const solved = [_]u8{
    1, 2, 3, 4,
};

pub fn build(b: *std.build.Builder) void {
    const target = b.standardTargetOptions(.{});
    const mode = b.standardReleaseOptions();

    const test_all = b.step("tests", "Run all tests");

    for (solved) |solution| {
        const base_name = b.fmt("problem_{d:0>4}", .{solution});
        const file_path = b.fmt("src/{s}.zig", .{base_name});

        // nice to have for debugging
        const executable = b.addExecutable(base_name, file_path);
        for (libs) |lib| { executable.addPackagePath(lib.name, lib.path); }
        executable.setTarget(target);
        executable.setBuildMode(mode);
        executable.install();

        const tests = b.addTest(file_path);
        for (libs) |lib| { tests.addPackagePath(lib.name, lib.path); }
        tests.setTarget(target);
        tests.setBuildMode(mode);

        const test_step = b.step(b.fmt("{d}", .{solution}), b.fmt("Test problem {d}", .{solution}));
        test_step.dependOn(&tests.step);
        test_all.dependOn(&tests.step);
    }

    for (libs) |lib| {
        const lib_tests = b.addTest(lib.path);
        lib_tests.setTarget(target);
        lib_tests.setBuildMode(mode);
        test_all.dependOn(&lib_tests.step);
    }
}
