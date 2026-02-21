const std = @import("std");
const p_utils = @import("Utils.zig");

const Type = std.builtin.Type;
const Allocator = std.mem.Allocator;
const argsAlloc = std.process.argsAlloc;

pub fn ArgParser(comptime T: type) type {
    return struct {
        allocator: Allocator,
        args: T,
        f_fields: []Type.StructField,
        a_fields: []Type.StructField,

        const Self = @This();

        pub fn init(allocator: Allocator) Self {
            const T_fields = p_utils.structFields(T);

            const flag_T = p_utils.findField(T_fields, "flags");
            const flag_fields = p_utils.structFields(flag_T);

            const arg_T = p_utils.findField(T_fields, "arguments");
            const arg_fields = p_utils.structFields(arg_T);

            return Self{
                .allocator = allocator,
                .args = .{},
                .f_fields = flag_fields,
                .a_fields = arg_fields,
            };
        }

        pub fn parse(self: *Self) T {
            const args = try argsAlloc(self.allocator);
            defer self.allocator.free(args);

            inline for (self.a_fields) |a| {}
        }
    };
}
