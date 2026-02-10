#!/usr/bin/env bash
set -Eeu

# After these commands have run ~/.nuget/packages contains nunit/ and nunit.console/ dirs
# and the jj dir has a csproj file copied into the docker/ dir

cd /tmp
mkdir jj

dotnet new nunit --output jj
cd jj
dotnet add package NUnit.ConsoleRunner

cd ..
rm -rf *
