using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddCors(options =>
{
    options.AddDefaultPolicy(policy =>
    {
        policy.AllowAnyOrigin()
              .AllowAnyMethod()
              .AllowAnyHeader();
    });
});

builder.Services.AddEndpointsApiExplorer();
builder.Logging.AddConsole();

var app = builder.Build();

app.UseCors();

app.MapGet("/", () => Results.Ok(new
{
    message = "UMF-DevKit ASP.NET Core service is running.",
    framework = "ASP.NET Core",
    language = "C#"
}));

app.MapGet("/health", () => Results.Ok(new
{
    status = "ok",
    service = "umf-aspnet",
    version = "1.0.0"
}));

app.MapGet("/hello", () => Results.Ok(new
{
    message = "Hello from ASP.NET Core!",
    framework = "ASP.NET Core",
    language = "C#"
}));

app.MapPost("/greet", async (HttpContext ctx) =>
{
    var body = await ctx.Request.ReadFromJsonAsync<GreetRequest>();
    if (body is null || string.IsNullOrWhiteSpace(body.Name))
    {
        return Results.BadRequest(new { error = "name is required" });
    }
    return Results.Ok(new { greeting = $"Hello, {body.Name}! — from ASP.NET Core (C#)" });
});

var port = Environment.GetEnvironmentVariable("PORT") ?? "8003";
app.Run($"http://0.0.0.0:{port}");

record GreetRequest(string Name);
