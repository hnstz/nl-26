const std = @import("std");

const ALPHABET = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

fn encode(allocator: std.mem.Allocator, input: []const u8) ![]u8 {
    const out_len = ((input.len + 2) / 3) * 4;
    var out = try allocator.alloc(u8, out_len);

    var i: usize = 0;
    var j: usize = 0;
    while (i < input.len) : ({
        i += 3;
        j += 4;
    }) {
        const b0 = input[i];
        const b1 = if (i + 1 < input.len) input[i + 1] else 0;
        const b2 = if (i + 2 < input.len) input[i + 2] else 0;

        const block = (@as(u32, b0) << 16) | (@as(u32, b1) << 8) | @as(u32, b2);

        out[j] = ALPHABET[(block >> 18) & 0x3F];
        out[j + 1] = ALPHABET[(block >> 12) & 0x3F];
        out[j + 2] = if (i + 1 < input.len) ALPHABET[(block >> 6) & 0x3F] else '=';
        out[j + 3] = if (i + 2 < input.len) ALPHABET[block & 0x3F] else '=';
    }
    return out;
}

fn indexOf(char: u8) u8 {
    for (ALPHABET, 0..) |c, idx| {
        if (c == char) return @as(u8, @intCast(idx));
    }
    return 0;
}

fn decode(allocator: std.mem.Allocator, input: []const u8) ![]u8 {
    var padding: usize = 0;
    if (input.len > 0 and input[input.len - 1] == '=') padding += 1;
    if (input.len > 1 and input[input.len - 2] == '=') padding += 1;

    const out_len = (input.len / 4) * 3 - padding;
    var out = try allocator.alloc(u8, out_len);

    var i: usize = 0;
    var j: usize = 0;
    while (i < input.len) : ({
        i += 4;
        j += 3;
    }) {
        const c0 = indexOf(input[i]);
        const c1 = indexOf(input[i + 1]);
        const c2 = if (input[i + 2] == '=') 0 else indexOf(input[i + 2]);
        const c3 = if (input[i + 3] == '=') 0 else indexOf(input[i + 3]);

        const block = (@as(u32, c0) << 18) | (@as(u32, c1) << 12) | (@as(u32, c2) << 6) | @as(u32, c3);

        if (j < out_len) out[j] = @as(u8, @truncate(block >> 16));
        if (j + 1 < out_len) out[j + 1] = @as(u8, @truncate(block >> 8));
        if (j + 2 < out_len) out[j + 2] = @as(u8, @truncate(block));
    }
    return out;
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const original = "Hello, Zig! Ручная реализация. 123 321";
    std.debug.print("Оригинал: {s}\n", .{original});

    const encoded = try encode(allocator, original);
    defer allocator.free(encoded);
    std.debug.print("Закодировано: {s}\n", .{encoded});

    const decoded = try decode(allocator, encoded);
    defer allocator.free(decoded);
    std.debug.print("Декодировано: {s}\n", .{decoded});
}
