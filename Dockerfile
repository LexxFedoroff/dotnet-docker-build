FROM dotnet-base:latest as build-stage

WORKDIR /app

# restore dependencies as distinct layer
COPY *.csproj build.cake ./
COPY ClientApp/package*.json ./ClientApp/

RUN cake -target=Restore

# add source code and build
COPY . /app
RUN dotnet publish -c Release -o out --no-restore

# build runtime image
FROM microsoft/dotnet:aspnetcore-runtime
WORKDIR /app
COPY --from=build-stage /app/out .
ENTRYPOINT ["dotnet", "docker-build.dll"]
