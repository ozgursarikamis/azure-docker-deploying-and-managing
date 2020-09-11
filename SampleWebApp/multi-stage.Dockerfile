# AS: name this step as `build-env` for later use:

FROM microsoft/dotnet:sdk AS build-env
WORKDIR /app

# Copy csproj and restore as distinct layers
COPY *.csproj ./
RUN dotnet restore

# Copy everything else and build
COPY . ./
RUN dotnet publish -c Release -o out

# Build runtime image
FROM microsoft/dotnet:aspnetcore-runtime
WORKDIR /app

# `build-env used here:

COPY --from=build-env /app/out .
ENTRYPOINT ["dotnet", "samplewebapp.dll"]
