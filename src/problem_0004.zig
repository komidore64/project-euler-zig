const std = @import("std");
const expect = std.testing.expect;

pub fn main() !void {
    std.debug.print("{d}\n", .{try solve(100, 999)});
}

fn solve(start: u32, stop: u32) !u32 {
    var largest_product: u32 = 0;
    var factor1 = start;

    while (factor1 >= start and factor1 <= stop) : (factor1 += 1) {
        var factor2 = start;

        while (factor2 >= start and factor2 <= stop) : (factor2 += 1) {
            const product = factor1 * factor2;

            if (product < largest_product)
                continue;

            var digits_array = std.ArrayList(u32).init(std.heap.page_allocator);
            defer digits_array.deinit();
            try intToArrayList(product, &digits_array);

            var reverse_digits_array = std.ArrayList(u32).init(std.heap.page_allocator);
            defer reverse_digits_array.deinit();
            for (digits_array.items) |digit| {
                try reverse_digits_array.insert(0, digit);
            }

            if (std.mem.eql(u32, digits_array.items, reverse_digits_array.items))
                largest_product = product;
        }
    }

    return largest_product;
}

test "solve" {
    try expect(try solve(10, 99) == 9_009);
    try expect(try solve(100, 999) == 906_609);
}

fn intToArrayList(num: u32, al: *std.ArrayList(u32)) !void {
    try al.insert(0, num % 10); // account for `0`

    var div: u32 = 10;
    while (div <= num) : (div *= 10) {
        try al.insert(0, num % (div * 10) / div);
    }
}

test "intToArrayList(1234)" {
    var test_arr = std.ArrayList(u32).init(std.testing.allocator);
    defer test_arr.deinit();

    try intToArrayList(@as(u32, 1234), &test_arr);
    try expect(std.mem.eql(u32, test_arr.items, &[_]u32{ 1, 2, 3, 4 }));
}

test "intToArrayList(5678)" {
    var test_arr = std.ArrayList(u32).init(std.testing.allocator);
    defer test_arr.deinit();

    try intToArrayList(@as(u32, 5678), &test_arr);
    try expect(std.mem.eql(u32, test_arr.items, &[_]u32{ 5, 6, 7, 8 }));
}

test "intToArrayList(100)" {
    var test_arr = std.ArrayList(u32).init(std.testing.allocator);
    defer test_arr.deinit();

    try intToArrayList(@as(u32, 100), &test_arr);
    try expect(std.mem.eql(u32, test_arr.items, &[_]u32{ 1, 0, 0 }));
}

test "intToArrayList(50)" {
    var test_arr = std.ArrayList(u32).init(std.testing.allocator);
    defer test_arr.deinit();

    try intToArrayList(@as(u32, 50), &test_arr);
    try expect(std.mem.eql(u32, test_arr.items, &[_]u32{ 5, 0 }));
}

test "intToArrayList(0)" {
    var test_arr = std.ArrayList(u32).init(std.testing.allocator);
    defer test_arr.deinit();

    try intToArrayList(@as(u32, 0), &test_arr);
    try expect(std.mem.eql(u32, test_arr.items, &[_]u32{0}));
}

// okay, at least i'm using `std.mem.eql()` correctly
test "arraylist equality" {
    try expect(!std.mem.eql(u32, &[_]u32{ 1, 2, 3, 4 }, &[_]u32{ 5, 6, 7, 8 }));
    try expect(std.mem.eql(u32, &[_]u32{ 1, 2, 3, 4 }, &[_]u32{ 1, 2, 3, 4 }));
}
