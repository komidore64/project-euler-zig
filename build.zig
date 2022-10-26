const std = @import("std");

// https://projecteuler.net/problems
const solved = [_]u8{
    1,
};

pub fn build(b: *std.build.Builder) void {
    const target = b.standardTargetOptions(.{});
    const mode = b.standardReleaseOptions();

    const test_all = b.step("tests", "Run all tests");
    b.default_step = test_all;

    for (solved) |solution| {
        const executable_tests = b.addTest(b.fmt("src/problem_{d:0>4}.zig", .{solution}));
        executable_tests.setTarget(target);
        executable_tests.setBuildMode(mode);

        const test_step = b.step(b.fmt("{d}", .{solution}), b.fmt("Test problem {d}", .{solution}));
        test_step.dependOn(&executable_tests.step);
        test_all.dependOn(&executable_tests.step);
    }
}
