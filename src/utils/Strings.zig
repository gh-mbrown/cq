const std = @import("std");

const Allocator = std.mem.Allocator;
const toLower = std.ascii.toLower;
const toUpper = std.ascii.toUpper;

pub fn lower(allocator: Allocator, str: []const u8) ![]const u8 {
    return applyCharacterFn(allocator, str, toLower);
}

pub fn upper(allocator: Allocator, str: []const u8) ![]const u8 {
    return applyCharacterFn(allocator, str, toUpper);
}

fn applyCharacterFn(allocator: Allocator, str: []const u8, func: fn (u8) u8) ![]const u8 {
    const new_str = try allocator.alloc(u8, str.len);
    errdefer allocator.free(new_str);
    for (str, 0..) |ch, i| new_str[i] = func(ch);
    return new_str;
}
