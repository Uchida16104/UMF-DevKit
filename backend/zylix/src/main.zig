const std = @import("std");
const net = std.net;

const PORT: u16 = 8007;

const hello_json =
    \\{"message":"Hello from Zylix (Zig)!","framework":"Zylix","language":"Zig"}
;
const health_json =
    \\{"status":"ok","service":"umf-zylix","version":"1.0.0"}
;
const root_json =
    \\{"message":"UMF-DevKit Zylix service is running.","framework":"Zylix","language":"Zig"}
;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const address = try net.Address.parseIp4("0.0.0.0", PORT);
    var server = try address.listen(.{ .reuse_address = true });
    defer server.deinit();

    std.debug.print("Zylix listening on port {d}\n", .{PORT});

    while (true) {
        const connection = server.accept() catch continue;
        const thread = try std.Thread.spawn(.{}, handleConnection, .{ allocator, connection });
        thread.detach();
    }
}

fn handleConnection(allocator: std.mem.Allocator, connection: net.Server.Connection) void {
    defer connection.stream.close();

    var read_buf: [4096]u8 = undefined;
    const n = connection.stream.read(&read_buf) catch return;
    if (n == 0) return;

    const request = read_buf[0..n];
    const path = extractPath(request) orelse "/";

    const body: []const u8 = if (std.mem.eql(u8, path, "/health"))
        health_json
    else if (std.mem.eql(u8, path, "/hello"))
        hello_json
    else
        root_json;

    const response = std.fmt.allocPrint(allocator,
        "HTTP/1.1 200 OK\r\nContent-Type: application/json\r\nContent-Length: {d}\r\nAccess-Control-Allow-Origin: *\r\nConnection: close\r\n\r\n{s}",
        .{ body.len, body },
    ) catch return;
    defer allocator.free(response);

    _ = connection.stream.writeAll(response) catch {};
}

fn extractPath(request: []const u8) ?[]const u8 {
    const start = std.mem.indexOf(u8, request, " ") orelse return null;
    const rest = request[start + 1 ..];
    const end = std.mem.indexOf(u8, rest, " ") orelse return null;
    return rest[0..end];
}
