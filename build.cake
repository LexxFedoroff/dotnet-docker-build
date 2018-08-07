#addin "Cake.Docker"

const string projectName = "docker-build.csproj";

var configuration = Argument("configuration", "Release");

var useDocker = HasArgument("docker");

// Common Tasks
Task("Restore")
  .Does(()=>{
    DotNetCoreRestore(projectName);
  });

Task("Build")
  .Does(() =>{
    DotNetCoreBuild(projectName, new DotNetCoreBuildSettings{
      NoRestore = true,
      Configuration = configuration
    });
  });

// Host Tasks
Task("Build-In-Docker")
  .Does(()=> {
    DockerBuild(".");
  });

var target = Argument("target", useDocker ? "Build-In-Docker" : "Build");
RunTarget(target);