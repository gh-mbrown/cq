const std = @import("std");

pub fn contains(
    comptime T: type,
    arr: []const T,
    val: T,
) bool {
    const T_info = @typeInfo(T);

    if (T_info == .array)
        (for (arr) |a| if (std.mem.eql(T_info.array.child, a, val)) return true)
    else
        (for (arr) |a| if (val == a) return true);

    return false;
}
