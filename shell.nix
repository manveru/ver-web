with import <nixpkgs> {};
let
  ruby = (ruby_2_4.override { useRailsExpress = false; });
  gems = pkgs.bundlerEnv {
    name = "ver-page-gems";
    inherit ruby;
    gemdir = ./.;
    gemConfig = defaultGemConfig // {
      ethon = attrs: {
        dontBuild = false;
        postPatch = ''
          substituteInPlace lib/ethon/curls/settings.rb \
            --replace "libcurl" "${curl.out}/lib/libcurl.so"
        '';
      };
    };
  };
  bundix = pkgs.bundix.override { inherit bundler; };
in stdenv.mkDerivation {
  name = "ver-page-shell";
  buildInputs = [
    ruby
    bundix
    gems
    curl
  ];
}
