const std = @import("std");
const euler = @import("euler");
const expect = std.testing.expect;

pub fn main() void {
    std.debug.print("{d}\n", .{solve(600_851_475_143)});
}

fn solve(num: u64) u64 {
    var dividend = std.math.sqrt(num);

    while (dividend > 1) : (dividend -= 1) {
        if (num % dividend == 0 and euler.isPrime(dividend))
            return dividend;
    }
    unreachable;
}

test "solve" {
    try expect(solve(13_195) == 29);
    try expect(solve(600_851_475_143) == 6_857);
}
