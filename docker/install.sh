#!/usr/bin/env bash
set -Eeu

# After the [dotnet new nunit] command has run:
# 1. ~/.nuget/packages contains nunit/  
#    so it is important the current user is sandbox.
# 2. The /tmp/dojo dir has a csproj file called dojo.csproj 
#    It is important it has this name, since that is the name of the
#    .csproj file used in the start-point
# 3. The /tmp/dojo/ dir has a sub-dir called obj
#    Instead of running [dotnet restore --source /home/sandbox/.nuget/packages/]
#    in the start-point's cyber-dojo.sh file (which takes ~1.5 seconds) we instead
#    move it to ~/dotnet_obj so that we can replace this [dotnet restore...] command
#    with the command [ln -s /home/sandbox/dotnet_obj obj] thus saving ~1.5 seconds.

[ "$(whoami)" == sandbox ] || (>&2 echo 'User must be sandbox' ; kill -INT $$)
mkdir /tmp/dojo
cd /tmp/dojo
dotnet new nunit

# The template names the NUnit its SDK shipped with, so the package is added
# again here to move it to the newest release.
dotnet add package NUnit

# Two mocking libraries, so a kata can show either one, each at its newest
# release. The start-point's cyber-dojo.sh finds their assemblies through a
# wildcard in place of the version, so a newer release does not move them.
dotnet add package Moq
dotnet add package NSubstitute

# The NuGet cache can hold versions the project does not use: the one a
# package added again replaced, and ones restore fetched on its way to the
# version it settled on. The start-point finds each assembly through a
# wildcard in place of the version, which needs exactly one version of each
# there, so every version project.assets.json does not name is removed.
for dir in ~/.nuget/packages/*/*/; do
  name=$(basename "$(dirname "${dir}")")
  version=$(basename "${dir}")
  if ! grep -q -i "\"${name}/${version}\"" obj/project.assets.json; then
    rm -rf "${dir}"
  fi
done

mv obj ~/dotnet_obj

# Install NUnit runner - will save ~1.5 seconds compared with dotnet test
dotnet tool install --global NUnit.ConsoleRunner.NetCore
