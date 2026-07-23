{
  pkgs,
  config,
  ...
}:

let
  inherit (config.lib.test) mkStubPackage;

  fakeTexliveSet = {
    collection-basic = pkgs.writeTextDir "collection-basic" "";
  };
in
{
  programs.texlive = {
    enable = true;
    package = mkStubPackage {
      name = "texlive";
      extraAttrs = {
        withPackages =
          tpkgs:
          pkgs.symlinkJoin {
            name = "dummy-texlive-combine";
            paths = tpkgs fakeTexliveSet;
          };
      };
    };
    extraPackages = ps: with ps; [ collection-basic ];
  };

  nmt.script = ''
    assertFileExists home-path/collection-basic
  '';
}
