# Dockerfile
FROM mcr.microsoft.com/dotnet/core/sdk:3.1.201 AS build-env
LABEL maintainer="996bkg@gmail.com"
WORKDIR /app
COPY . /app
ENTRYPOINT ["dotnet", "build", "/app"]
