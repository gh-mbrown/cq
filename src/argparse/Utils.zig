const std = @import("std");

const Type = std.builtin.Type;
const eql = std.mem.eql;
const comptimePrint = std.fmt.comptimePrint;
const trimStart = std.mem.trimStart;

pub fn structFields(
    comptime T: type,
) []const Type.StructField {
    const T_info = @typeInfo(T);

    if (T_info != .@"struct") @compileError("Type passed is not a struct");

    return T_info.@"struct".fields;
}

pub fn findField(
    comptime fields: []const Type.StructField,
    comptime field: []const u8,
) type {
    inline for (fields) |s| if (eql(u8, s.name, field)) return s.type;

    const msg = comptimePrint("Field name {} not in passed fields", .{field});
    @compileError(msg);
}

pub fn containsFlag(
    comptime flag_name: []const u8,
    args: []const []const u8,
) ?usize {
    for (args, 0..) |a, i| {
        const stripped = trimStart(u8, a, "--");
        if (eql(u8, flag_name, stripped)) return i;
    }

    return null;
}
