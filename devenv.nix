{ pkgs, config, ... }:

{
  name = "devenv_template";

  packages = [
    pkgs.git
    pkgs.vscode-extensions.phoenixframework.phoenix
  ];

  scripts.banner.exec = ''
    echo
    echo " *****************************************"
    echo "   ${config.name} development environment "
    echo "   use 'devenv up' to start services      "
    echo " *****************************************"
    echo
  '';

  enterShell = ''
    banner
  '';

  languages.elixir.enable = true;

  pre-commit.hooks.shellcheck.enable = true;

  services.postgres.enable = true;
  services.postgres.package = pkgs.postgresql_14.withPackages (p: [ p.postgis ]);
  services.postgres.initialDatabases = [
    {
      name = "${config.name}_dev";
    }
    {
      name = "${config.name}_test";
    }
  ];
  services.postgres.initialScript = "CREATE USER ${config.name} SUPERUSER";

  services.minio.enable = true;
  services.minio.region = "local";
  services.minio.accessKey = "${config.name}_access_key";
  services.minio.secretKey = "${config.name}_secret_key";

  services.mailhog.enable = true;

  # See full reference at https://devenv.sh/reference/options/
}
