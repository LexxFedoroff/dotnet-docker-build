const string projectName = "docker-build.csproj";

var configuration = Argument("configuration", "Release");

Task("Build")
  .Does(() =>
{
  DotNetCoreBuild(projectName, new DotNetCoreBuildSettings{
    NoRestore = true,
    Configuration = configuration
  });
});

var target = Argument("target", "Build");
RunTarget(target);