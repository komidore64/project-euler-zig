const std = @import("std");
const expect = std.testing.expect;

pub fn main() !void {
    std.debug.print("{d}\n", .{try solve(10, 99)});
}

// FIXME: this _looks_ like it should return the first discovered palindromic
// number, but it returns `990` for some reason. debug to figure out.
//
// I think I'm constructing my reverse digit array incorrectly.
fn solve(start: u32, stop: u32) !u32 {
    var factor1 = start;
    var factor2 = stop;

    while (factor1 >= start and factor1 <= stop) : (factor1 += 1) {
        while (factor2 >= start and factor2 <= stop) : (factor2 += 1) {
            const product = factor1 * factor2;

            var digits_array = std.ArrayList(u32).init(std.heap.page_allocator);
            defer digits_array.deinit();
            try intToArrayList(product, &digits_array);

            var reverse_digits_array = std.ArrayList(u32).init(std.heap.page_allocator);
            defer reverse_digits_array.deinit();
            for (digits_array.items) |digit| {
                try reverse_digits_array.append(digit);
            }

            if (std.mem.eql(u32, digits_array.items, reverse_digits_array.items))
                return product;
        }
    }
    unreachable;
}

// test "solve" {
//     try expect(solve(10, 99) == 9_009);
//     try expect(solve(100, 999) == 906_609);
// }

fn intToArrayList(num: u32, al: *std.ArrayList(u32)) !void {
    var div: u32 = 1;

    while (div < num) : (div *= 10) {
        try al.insert(0, num % (div * 10) / div);
    }
}

test "intToArrayList" {
    var test_arr1 = std.ArrayList(u32).init(std.testing.allocator);
    defer test_arr1.deinit();

    try intToArrayList(@as(u32, 1234), &test_arr1);
    try expect(std.mem.eql(u32, test_arr1.items, &[_]u32{ 1, 2, 3, 4 }));

    var test_arr2 = std.ArrayList(u32).init(std.testing.allocator);
    defer test_arr2.deinit();

    try intToArrayList(@as(u32, 5678), &test_arr2);
    try expect(std.mem.eql(u32, test_arr2.items, &[_]u32{ 5, 6, 7, 8 }));
}

// okay, at least i'm using `std.mem.eql()` correctly
test "arraylist equality" {
    try expect(!std.mem.eql(u32, &[_]u32{ 1, 2, 3, 4 }, &[_]u32{ 5, 6, 7, 8 }));
    try expect(std.mem.eql(u32, &[_]u32{ 1, 2, 3, 4 }, &[_]u32{ 1, 2, 3, 4 }));
}
