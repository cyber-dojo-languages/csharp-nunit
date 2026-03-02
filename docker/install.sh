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

mv obj ~/dotnet_obj

# Install NUnit runner - will save ~1.5 seconds compared with dotnet test
dotnet tool install --global NUnit.ConsoleRunner --version 3.22.0
