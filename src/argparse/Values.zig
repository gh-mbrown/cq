const std = @import("std");

const Type = std.builtin.Type;
const startsWith = std.mem.startsWith;

const TypeError = error{
    NoFlagValue,
};

pub fn getValue(
    comptime flag: Type.StructField,
    val: []const u8,
) anyerror!flag.type {
    const type_info = comptime @typeInfo(flag.type);

    const value = switch (type_info) {
        .pointer => |p| try getString(p, val),
        .int => |i| try getInt(comptime std.meta.Int(i.signedness, i.bits), val),
        .bool => true,
    };
}

pub fn getString(
    comptime P: Type.Pointer,
    val: []const u8,
) ![]const u8 {
    if (P.size != .slice) @compileError("Not a slice");

    const child_info = comptime @typeInfo(P.child);

    if (child_info != .int and child_info.int.signedness != .unsigned) @compileError("Not a unsigned integer");

    if (startsWith(u8, val, "--")) return TypeError.NoFlagValue;

    return val;
}

pub fn getInt(
    comptime I: type,
    val: []const u8,
) !I {
    if (startsWith(u8, val, "--")) return TypeError.NoFlagValue;

    return try std.fmt.parseInt(I, val, 10);
}
