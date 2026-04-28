using System.Collections.Concurrent;
using System.Security.Cryptography;
using System.Text;
using System.Linq;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Hosting;

var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

var events = new ConcurrentQueue<VisitorEvent>();

app.MapGet("/health", () => Results.Ok(new { status = "ok" }));

app.MapPost("/events", async (HttpRequest request) =>
{
    var payload = await request.ReadFromJsonAsync<VisitorEventIn>();
    if (payload is null)
    {
        return Results.BadRequest(new { error = "Missing body." });
    }

    var record = new VisitorEvent(
        Guid.NewGuid().ToString("N"),
        DateTimeOffset.UtcNow.ToString("O"),
        payload.SessionId,
        payload.Route,
        payload.Referrer,
        payload.UserAgent,
        HashIp(payload.IpAddress ?? request.HttpContext.Connection.RemoteIpAddress?.ToString()),
        payload.Consent,
        payload.DwellSeconds,
        payload.ScrollDepthPct,
        payload.EventType,
        payload.ConversionName,
        AnomalyScore(payload)
    );

    events.Enqueue(record);
    return Results.Ok(new { stored = true, eventRecord = record, summary = Rollup(events) });
});

app.MapGet("/summary", () => Results.Ok(Rollup(events)));

app.MapGet("/trends", (int window) =>
{
    var sample = events.Reverse().Take(Math.Max(window, 1)).ToList();
    return Results.Ok(new
    {
        window,
        eventCount = sample.Count,
        topRoutes = sample.GroupBy(x => x.Route).Select(g => new { route = g.Key, count = g.Count() }).OrderByDescending(x => x.count),
        topReferrers = sample.GroupBy(x => x.Referrer ?? "(direct)").Select(g => new { referrer = g.Key, count = g.Count() }).OrderByDescending(x => x.count),
        avgDwellSeconds = sample.Any() ? Math.Round(sample.Average(x => x.DwellSeconds), 2) : 0.0
    });
});

app.Run();

record VisitorEventIn(
    string SessionId,
    string Route,
    string? Referrer,
    string? UserAgent,
    string? IpAddress,
    bool Consent,
    double DwellSeconds,
    double ScrollDepthPct,
    string EventType,
    string? ConversionName
);

record VisitorEvent(
    string EventId,
    string TimestampUtc,
    string SessionId,
    string Route,
    string? Referrer,
    string? UserAgent,
    string? IpHash,
    bool Consent,
    double DwellSeconds,
    double ScrollDepthPct,
    string EventType,
    string? ConversionName,
    double AnomalyScore
);

static string? HashIp(string? value)
{
    if (string.IsNullOrWhiteSpace(value))
        return null;

    var bytes = SHA256.HashData(Encoding.UTF8.GetBytes(value));
    return Convert.ToHexString(bytes).ToLowerInvariant();
}

static double AnomalyScore(VisitorEventIn payload)
{
    var score = 0.0;
    if (payload.DwellSeconds <= 1) score += 0.4;
    if (payload.ScrollDepthPct >= 90) score += 0.2;
    if (payload.EventType == "conversion") score += 0.1;
    if (!payload.Consent) score += 0.05;
    return Math.Min(Math.Round(score, 3), 1.0);
}

static object Rollup(IEnumerable<VisitorEvent> events)
{
    var list = events.ToList();
    return new
    {
        totalEvents = list.Count,
        uniqueSessions = list.Select(x => x.SessionId).Distinct().Count(),
        topRoutes = list.GroupBy(x => x.Route).Select(g => new { route = g.Key, count = g.Count() }).OrderByDescending(x => x.count).Take(5),
        topReferrers = list.GroupBy(x => x.Referrer ?? "(direct)").Select(g => new { referrer = g.Key, count = g.Count() }).OrderByDescending(x => x.count).Take(5),
        averageDwellSeconds = list.Any() ? Math.Round(list.Average(x => x.DwellSeconds), 2) : 0.0
    };
}
