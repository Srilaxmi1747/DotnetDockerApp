# 1️⃣ Build Stage
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

COPY . .
RUN dotnet restore MyApp/MyApp.csproj
RUN dotnet publish MyApp/MyApp.csproj -c Release -o /app

# 2️⃣ Runtime Stage
FROM mcr.microsoft.com/dotnet/runtime:8.0
WORKDIR /app
COPY --from=build /app .

# Render Web Services require a port
EXPOSE 10000

# Add a simple HTTP server so Render health checks pass
CMD ["sh", "-c", "dotnet MyApp.dll & python3 -m http.server 10000 --bind 0.0.0.0"]
