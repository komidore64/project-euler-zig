const std = @import("std");

pub fn main() void {
    std.debug.print("{d}\n", .{solve(4_000_000)});
}

fn solve(limit: u32) u32 {
    var sum: u32 = 0;
    var prev1: u32 = 0;
    var prev2: u32 = 1;

    var fib: u32 = prev1 + prev2;
    while (fib < limit) : ({
        prev1 = prev2;
        prev2 = fib;
        fib = prev1 + prev2;
    }) {
        if (fib % 2 == 0)
            sum += fib;
    }

    return sum;
}

test "example 0002" {
    try std.testing.expect(solve(90) == 44);
}

test "solution 0002" {
    try std.testing.expect(solve(4_000_000) == 4_613_732);
}
