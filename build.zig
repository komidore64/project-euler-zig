const std = @import("std");

// https://projecteuler.net/problems
const solved = [_]u8{
    1,
    2,
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
        executable.setTarget(target);
        executable.setBuildMode(mode);
        executable.install();

        const tests = b.addTest(file_path);
        tests.setTarget(target);
        tests.setBuildMode(mode);

        const test_step = b.step(b.fmt("{d}", .{solution}), b.fmt("Test problem {d}", .{solution}));
        test_step.dependOn(&tests.step);
        test_all.dependOn(&tests.step);
    }
}
