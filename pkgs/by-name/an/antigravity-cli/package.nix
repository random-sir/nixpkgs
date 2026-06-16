{
  lib,
  stdenvNoCC,
  fetchurl,
  autoPatchelfHook,
  versionCheckHook,
  nix-update-script,
}:
let
  version = "1.0.8";

  throwSystem = throw "Unsupported system: ${stdenvNoCC.hostPlatform.system}";

  sourceData = {
    x86_64-linux = fetchurl {
      url = "https://github.com/google-antigravity/antigravity-cli/releases/download/${version}/agy_cli_linux_x64.tar.gz";
      hash = "sha256-24yp08jM4GUecrb/+oN04nmcVVTZTfKx+eQrtRV0W/8=";
    };
    aarch64-linux = fetchurl {
      url = "https://github.com/google-antigravity/antigravity-cli/releases/download/${version}/agy_cli_linux_arm64.tar.gz";
      hash = "sha256-zbxR/82KK5SZH9Nshm+whVz67R4u8Ksfzzvntko/n3E=";
    };
    aarch64-darwin = fetchurl {
      url = "https://github.com/google-antigravity/antigravity-cli/releases/download/${version}/agy_cli_mac_arm64.tar.gz";
      hash = "sha256-HCNO6NMWRb+HTbG3HV4CQhxjUGYcig9AjasxBQG8W5Q=";
    };
    x86_64-darwin = fetchurl {
      url = "https://github.com/google-antigravity/antigravity-cli/releases/download/${version}/agy_cli_mac_x64.tar.gz";
      hash = "sha256-VIJsUjWNwBQG2vTdtzvWIK5rkeN2vqWrwQtuCLR/jN8=";
    };
  };
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "antigravity-cli";
  inherit version;

  strictDeps = true;
  __structuredAttrs = true;

  src = sourceData.${stdenvNoCC.hostPlatform.system} or throwSystem;

  sourceRoot = ".";

  nativeBuildInputs = lib.optionals stdenvNoCC.hostPlatform.isElf [ autoPatchelfHook ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 antigravity $out/bin/agy

    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Google's Go-based terminal user interface (TUI) agent client";
    homepage = "https://antigravity.google";
    changelog = "https://antigravity.google/changelog";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      adrielvelazquez
      u3kkasha
    ];
    platforms = lib.attrNames sourceData;
    mainProgram = "agy";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
