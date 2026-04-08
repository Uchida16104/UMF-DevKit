FROM mcr.microsoft.com/dotnet/sdk:8.0-alpine AS builder

WORKDIR /app

COPY aspnet.csproj ./
RUN dotnet restore

COPY Program.cs ./
RUN dotnet publish -c Release -o /publish

FROM mcr.microsoft.com/dotnet/aspnet:8.0-alpine

WORKDIR /app
COPY --from=builder /publish .

ENV PORT=8003
ENV ASPNETCORE_URLS=http://+:8003
EXPOSE 8003

ENTRYPOINT ["dotnet", "umf-aspnet.dll"]
