{ 
  mkPnpmPackage
, prismaVersion
, nodeLibHash
, lib
, buildNpmPackage
, fetchFromGitHub 
, pnpm_8
, gcc
, python310
}:

mkPnpmPackage rec {
  pname = "prisma";
  version = prismaVersion;

  pnpm = pnpm_8;
  installInPlace = true;

  src = fetchFromGitHub {
    owner = "prisma";
    repo = pname;
    rev = version;
    hash = nodeLibHash;
  };

  distDir = "packages/cli/build";

  meta = {
    description = "Next-generation ORM for Node.js & TypeScript";
    homepage = "https://www.prisma.io";
    license = lib.licenses.asl20;
  };

  extraBuildInputs = [ gcc python310 ];
}
