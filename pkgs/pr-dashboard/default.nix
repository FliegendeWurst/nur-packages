{
  stdenv,
  lib,
  fetchFromGitHub,
  rustPlatform,
  makeBinaryWrapper,
  sqlite,
}:

rustPlatform.buildRustPackage rec {
  pname = "pr-dashboard";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "FliegendeWurst";
    repo = "pr-dashboard";
    rev = "3ab7512d33cd101a3364e4e9f59a56224afa3103";
    hash = "sha256-mbsPkySItcwWXWsGrPNiM6TkqWA1P2e1WpTziQs6TQw=";
  };

  cargoHash = "sha256-3zePZHKqWf+8THI4OIb9qkE+9BVM+6fzM85KwZY5X8w=";

  nativeBuildInputs = [
    rustPlatform.bindgenHook
    makeBinaryWrapper
  ];
  buildInputs = [ sqlite ];

  postInstall = ''
    wrapProgram $out/bin/pr-dashboard \
      --set LD_LIBRARY_PATH "${lib.makeLibraryPath [ sqlite ]}"
  '';

  doInstallCheck = false;
  doCheck = false;

  meta = with lib; {
    description = "PR dashboard for nixpkgs";
    homepage = "https://github.com/FliegendeWurst/pr-dashboard";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fliegendewurst ];
    mainProgram = "pr-dashboard";
  };
}