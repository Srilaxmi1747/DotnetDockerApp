# 1️⃣ Build Stage
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy everything
COPY . .
RUN dotnet restore MyApp/MyApp.csproj

# Publish app
RUN dotnet publish MyApp/MyApp.csproj -c Release -o /app

# 2️⃣ Runtime Stage
FROM mcr.microsoft.com/dotnet/runtime:8.0
WORKDIR /app
COPY --from=build /app .

ENTRYPOINT ["dotnet", "MyApp.dll"]

