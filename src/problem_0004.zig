const std = @import("std");
const euler = @import("euler");
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
            try euler.intToArrayList(product, &digits_array);

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

// okay, at least i'm using `std.mem.eql()` correctly
test "arraylist equality" {
    try expect(!std.mem.eql(u32, &[_]u32{ 1, 2, 3, 4 }, &[_]u32{ 5, 6, 7, 8 }));
    try expect(std.mem.eql(u32, &[_]u32{ 1, 2, 3, 4 }, &[_]u32{ 1, 2, 3, 4 }));
}
