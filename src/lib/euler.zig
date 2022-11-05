const std = @import("std");
const sqrt = std.math.sqrt;
const expect = std.testing.expect;

pub fn isPrime(n: anytype) bool {
    const T = @TypeOf(n);
    switch (@typeInfo(T)) {
        .Int => {
            if (n <= 1)
                return false;

            var dividend = sqrt(n);
            while (dividend > 1) : (dividend -= 1) {
                if (n % dividend == 0)
                    return false;
            }

            return true;
        },
        else => @compileError("isPrime not implemented for " ++ @typeName(T)),
    }
}

test "isPrime" {
    try expect(isPrime(@as(u8, 2)));
    try expect(isPrime(@as(u16, 5)));
    try expect(isPrime(@as(u32, 7)));
    try expect(isPrime(@as(u64, 13)));

    try expect(!isPrime(@as(u8, 0)));
    try expect(!isPrime(@as(u16, 1)));
    try expect(!isPrime(@as(u32, 4)));
    try expect(!isPrime(@as(u64, 6)));
    try expect(!isPrime(@as(u128, 8)));
}

pub fn intToArrayList(comptime T: type, n: T, al: *std.ArrayList(T)) !void {
    try al.insert(0, n % 10); // account for `0`

    var div: T = 10;
    while (div <= n) : (div *= 10) {
        try al.insert(0, n % (div * 10) / div);
    }
}

test "intToArrayList(1234)" {
    var test_arr = std.ArrayList(u16).init(std.testing.allocator);
    defer test_arr.deinit();

    try intToArrayList(u16, @as(u16, 1234), &test_arr);
    try expect(std.mem.eql(u16, test_arr.items, &[_]u16{ 1, 2, 3, 4 }));
}

test "intToArrayList(5678)" {
    var test_arr = std.ArrayList(u64).init(std.testing.allocator);
    defer test_arr.deinit();

    try intToArrayList(u64, @as(u64, 5678), &test_arr);
    try expect(std.mem.eql(u64, test_arr.items, &[_]u64{ 5, 6, 7, 8 }));
}

test "intToArrayList(100)" {
    var test_arr = std.ArrayList(u32).init(std.testing.allocator);
    defer test_arr.deinit();

    try intToArrayList(u32, @as(u32, 100), &test_arr);
    try expect(std.mem.eql(u32, test_arr.items, &[_]u32{ 1, 0, 0 }));
}

test "intToArrayList(50)" {
    var test_arr = std.ArrayList(u8).init(std.testing.allocator);
    defer test_arr.deinit();

    try intToArrayList(u8, @as(u8, 50), &test_arr);
    try expect(std.mem.eql(u8, test_arr.items, &[_]u8{ 5, 0 }));
}

test "intToArrayList(0)" {
    var test_arr = std.ArrayList(u8).init(std.testing.allocator);
    defer test_arr.deinit();

    try intToArrayList(u8, @as(u8, 0), &test_arr);
    try expect(std.mem.eql(u8, test_arr.items, &[_]u8{0}));
}
