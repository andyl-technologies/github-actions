{
  pkgs,
  config,
  lib,
  ...
}: {
  packages = with pkgs; [
    cargo-watch
    git
    lld
  ];

  languages.rust = {
    enable = true;
    channel = "stable";
    components = [
      "cargo"
      "clippy"
      "clippy-preview"
      "rust-analyzer"
      "rustc"
      "rustfmt"
      "llvm-tools-preview"
    ];
  };

  processes = lib.optionalAttrs (!config.devenv.isTesting) {
    cargo-watch.exec = "cargo-watch";
  };

  enterTest = ''
    cargo test --workspace
  '';

  scripts."coverage-testing" = {
    description = "Run coverage testing";
    exec = ''
      cargo llvm-cov clean --workspace
      cargo llvm-cov test --workspace --no-report --release

      cargo llvm-cov report --release --cobertura --output-path coverage.cobertura.xml
      cargo llvm-cov report --release --lcov --output-path coverage.lcov
    '';
  };
}
