const std = @import("std");

const VisitorEvent = struct {
    route: []const u8,
    referrer: []const u8,
    dwell_seconds: f64,
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const allocator = gpa.allocator();
    var route_counts = std.StringHashMap(usize).init(allocator);
    defer route_counts.deinit();

    const events = [_]VisitorEvent{
        .{ .route = "/", .referrer = "(direct)", .dwell_seconds = 12.0 },
        .{ .route = "/pricing", .referrer = "https://example.com/", .dwell_seconds = 84.0 },
        .{ .route = "/docs", .referrer = "(direct)", .dwell_seconds = 20.0 },
    };

    var total_dwell: f64 = 0;

    for (events) |event| {
        total_dwell += event.dwell_seconds;
        const count = route_counts.get(event.route) orelse 0;
        try route_counts.put(event.route, count + 1);
    }

    const stdout = std.io.getStdOut().writer();
    try stdout.print("total_events={d}\n", .{events.len});
    try stdout.print("average_dwell_seconds={d:.2}\n", .{total_dwell / @as(f64, @floatFromInt(events.len))});

    var it = route_counts.iterator();
    while (it.next()) |entry| {
        try stdout.print("{s} -> {d}\n", .{ entry.key_ptr.*, entry.value_ptr.* });
    }
}
