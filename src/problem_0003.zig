const std = @import("std");

pub fn main() void {
    std.debug.print("{d}\n", .{solve(600_851_475_143)});
}

fn solve(num: u64) u64 {
    var dividend = std.math.sqrt(num);

    while (dividend > 1) : (dividend -= 1) {
        if (num % dividend == 0 and isPrime(dividend))
            return dividend;
    }
    unreachable;
}

test "solve" {
    try std.testing.expect(solve(13_195) == 29);
    try std.testing.expect(solve(600_851_475_143) == 6_857);
}

fn isPrime(num: u64) bool {
    var dividend = std.math.sqrt(num);

    while (dividend > 1) : (dividend -= 1) {
        if (num % dividend == 0)
            return false;
    }

    return true;
}

test "isPrime" {
    const primes = [_]u8{ 2, 5, 7, 13 };
    const composites = [_]u8{ 4, 6, 8, 10 };

    for (primes) |p| {
        try std.testing.expect(isPrime(p));
    }

    for (composites) |c| {
        try std.testing.expect(!isPrime(c));
    }
}
