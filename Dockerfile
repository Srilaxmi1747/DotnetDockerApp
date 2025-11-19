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

# Install busybox for lightweight HTTP server (no python needed)
RUN apt-get update && apt-get install -y busybox

# Render Web Services require a port
EXPOSE 10000

# Start your .NET app AND keep Render alive with busybox http server
CMD ["sh", "-c", "dotnet MyApp.dll & busybox httpd -f -p 10000"]
