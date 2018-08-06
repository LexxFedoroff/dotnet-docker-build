FROM dotnet-base:latest

WORKDIR /app

# restore dependencies as distinct layer
COPY *.csproj ./
COPY ClientApp/package*.json ./ClientApp/

RUN dotnet restore \
    && cd ClientApp && npm ci && cd -

# add source code and build
COPY . /app
RUN dotnet publish -c Release -o out --no-restore

# build runtime image
FROM microsoft/dotnet:aspnetcore-runtime
WORKDIR /app
COPY --from=build-stage /app/out .
ENTRYPOINT ["dotnet", "docker-build.dll"]
