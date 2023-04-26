{ pkgs, ... }:

let APP_NAME = "devenv_template"; in
{
  # # https://devenv.sh/basics/
  env.APP_NAME = APP_NAME;

  # https://devenv.sh/packages/
  packages = [
    pkgs.git
    pkgs.vscode-extensions.phoenixframework.phoenix
  ];

  # https://devenv.sh/scripts/
  scripts.banner.exec = ''
    echo
    echo " **************************************"
    echo "   $APP_NAME development environment "
    echo "   use 'devenv up' to start services "
    echo " **************************************"
    echo
  '';

  enterShell = ''
    banner
  '';

  # https://devenv.sh/languages/
  languages.elixir.enable = true;

  # https://devenv.sh/pre-commit-hooks/
  pre-commit.hooks.shellcheck.enable = true;

  # https://devenv.sh/processes/
  # processes.ping.exec = "ping example.com";

  services.postgres.enable = true;
  services.postgres.package = pkgs.postgresql_14.withPackages (p: [ p.postgis ]);
  services.postgres.initialDatabases = [
    {
      name = APP_NAME+"_dev";
    }
    {
      name = APP_NAME+"_test";
    }
  ];
  services.postgres.initialScript = "CREATE USER $APP_NAME SUPERUSER";

  services.minio.enable = true;
  services.minio.region = "local";
  services.minio.accessKey = APP_NAME+"_access_key";
  services.minio.secretKey = APP_NAME+"_secret_key";

  services.mailhog.enable = true;

  # See full reference at https://devenv.sh/reference/options/
}
