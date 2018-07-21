FROM microsoft/dotnet:sdk AS build-env

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - \
    && apt-get install -y nodejs

WORKDIR /app

# Copy csproj and restore as distinct layers
COPY *.csproj ./
COPY ClientApp/*.json ./ClientApp/
RUN dotnet restore && cd ClientApp && npm ci && cd -

# Copy everything else and build
COPY . ./
RUN dotnet publish -c Release -o out

# Build runtime image
FROM microsoft/dotnet:aspnetcore-runtime
WORKDIR /app
COPY --from=build-env /app/out .
ENTRYPOINT ["dotnet", "docker-build.dll"]