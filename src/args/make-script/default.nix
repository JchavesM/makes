{ builtinLambdas
, builtinShellCommands
, builtinShellOptions
, inputs
, lib
, makeDerivation
, makeSearchPaths
, makeTemplate
, ...
}:

{ aliases ? [ ]
, arguments ? { }
, entrypoint
, name
, searchPaths ? { }
}:
makeDerivation {
  actions = [{
    type = "exec";
    location = "/bin/${name}";
  }];
  arguments = {
    envAliases = builtinLambdas.asBashArray (aliases ++ [ name ]);
    envEntrypoint = makeTemplate {
      inherit arguments;
      inherit name;
      template = entrypoint;
    };
    envEntrypointSetup = makeTemplate {
      arguments = {
        envBuiltinShellCommands = builtinShellCommands;
        envBuiltinShellOptions = builtinShellOptions;
        envCaCert = inputs.makesPackages.nixpkgs.cacert;
        envName = name;
        envSearchPaths = makeSearchPaths searchPaths;
        envSearchPathsBase = makeSearchPaths {
          # Minimalistic shell environment
          # Let's try to keep it as lightweight as possible because this
          # propagates to all built apps and packages
          envPaths = [
            inputs.makesPackages.nixpkgs.bash
            inputs.makesPackages.nixpkgs.coreutils
          ];
        };
        envShell = "${inputs.makesPackages.nixpkgs.bash}/bin/bash";
      };
      name = "makes-src-args-make-script-for-${name}";
      template = ./template.sh;
    };
  };
  builder = ./builder.sh;
  local = true;
  inherit name;
}
