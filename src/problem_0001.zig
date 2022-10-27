const std = @import("std");
const expect = std.testing.expect;

pub fn main() void {
    std.debug.print("{d}\n", .{solve(1000)});
}

fn solve(limit: u32) u32 {
    var sum: u32 = 0;

    var counter: u32 = 1;
    while (counter < limit) : (counter += 1) {
        if (counter % 3 == 0 or counter % 5 == 0) {
            sum += counter;
        }
    }

    return sum;
}

test "solve" {
    try expect(solve(10) == 23);
    try expect(solve(1000) == 233_168);
}
