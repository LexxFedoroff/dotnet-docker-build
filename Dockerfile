FROM microsoft/dotnet:sdk as build-stage

# install build dependecies
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - \
    && apt-get install -y nodejs

WORKDIR /app

# restore dependencies as distinct layer
ADD *.csproj ./
RUN dotnet restore

# add source code and build
ADD . /app
RUN dotnet publish -c Release -o out --no-restore

# build runtime image
FROM microsoft/dotnet:aspnetcore-runtime
WORKDIR /app
COPY --from=build-stage /app/out .
ENTRYPOINT ["dotnet", "docker-build.dll"]
