const std = @import("std");

const Problem = struct {
    key: u8,
    base_name: []const u8,
    test_name: []const u8,
    filepath: []const u8,

};

const problems = [_]Problem{
    .{
        .key = 1,
        .base_name = "problem_0001",
        .test_name = "test_0001",
        .filepath = "src/problem_0001.zig",
    },
};

pub fn build(b: *std.build.Builder) void {
    const target = b.standardTargetOptions(.{});
    const mode = b.standardReleaseOptions();

    const test_all = b.step("tests", "Run all tests");
    b.default_step = test_all;

    for (problems) |problem| {
        const executable = b.addExecutable(problem.base_name, problem.filepath);
        executable.setTarget(target);
        executable.setBuildMode(mode);

        const run_cmd = executable.run();
        run_cmd.step.dependOn(b.getInstallStep());
        if (b.args) |args| {
            run_cmd.addArgs(args);
        }

        const run_step = b.step(problem.base_name, b.fmt("Run problem {d}", .{ problem.key }));
        run_step.dependOn(&run_cmd.step);

        const executable_tests = b.addTest(problem.filepath);
        executable_tests.setTarget(target);
        executable_tests.setBuildMode(mode);

        const test_step = b.step(problem.test_name, b.fmt("Test problem {d}", .{ problem.key }));
        test_step.dependOn(&executable_tests.step);
        test_all.dependOn(&executable_tests.step);
    }

}
