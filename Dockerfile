FROM mcr.microsoft.com/dotnet/core/aspnet:2.2-stretch-slim AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

MAINTAINER cemkocabas <scemkocabas@gmail.com>

FROM mcr.microsoft.com/dotnet/core/sdk:2.2-stretch AS build
WORKDIR /src
COPY ["HelloDocker/HelloDocker.csproj", "HelloDocker/"]
RUN dotnet restore "HelloDocker/HelloDocker.csproj"
COPY . .
WORKDIR "/src/HelloDocker"
RUN dotnet build "HelloDocker.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "HelloDocker.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "HelloDocker.dll"]