const std = @import("std");
const utils = @import("utils");
const p_utils = @import("Utils.zig");

const Type = std.builtin.Type;
const Allocator = std.mem.Allocator;
const argsAlloc = std.process.argsAlloc;
const eql = std.mem.eql;

pub fn ArgParser(
    comptime T: type,
) type {
    const T_fields = comptime p_utils.structFields(T);

    const flag_T = comptime p_utils.findField(T_fields, "flags");
    const flag_fields = comptime p_utils.structFields(flag_T);

    const arg_T = comptime p_utils.findField(T_fields, "arguments");
    const arg_fields = comptime p_utils.structFields(arg_T);

    return struct {
        allocator: Allocator,
        args_type: T,
        comptime f_fields: []Type.StructField = flag_fields,
        comptime a_fields: []Type.StructField = arg_fields,
        args: [][]const u8,

        const Self = @This();

        pub fn init(
            allocator: Allocator,
        ) Self {
            return Self{
                .allocator = allocator,
                .args_type = .{},
            };
        }

        pub fn deinit(
            self: *Self,
        ) void {
            self.allocator.free(self.args);
        }

        pub fn parse(
            self: *Self,
        ) !T {
            self.args = try argsAlloc(self.allocator);

            inline for (self.f_fields) |f| @"continue": {
                const index = p_utils.containsFlag(f.name, self.args) orelse break :@"continue";
            }
        }
    };
}
