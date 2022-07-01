FROM mcr.microsoft.com/dotnet/aspnet:6.0-alpine AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:6.0-alpine AS build
WORKDIR /src
COPY ["SampleDotNetProject.csproj", "."]
RUN dotnet restore "SampleDotNetProject.csproj"
COPY . .
RUN dotnet build "SampleDotNetProject.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "SampleDotNetProject.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
EXPOSE 5000
ENTRYPOINT ["dotnet", "SampleDotNetProject.dll"]
