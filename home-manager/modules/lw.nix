{ config, pkgs, ... }:

{
  home.packages = [
    pkgs.hello
    pkgs.mongosh
    pkgs.vi-mongo
    pkgs.nodejs
    pkgs.rclone
    pkgs.k9s
    pkgs.kubectx
    pkgs.kubectl
    pkgs.go

    (pkgs.writeShellScriptBin "error-log-remove-activity-ids" ''
      awk -F';' '{print($1","$2","$NF)}' $1
    '')
  ];

  home.sessionVariables = {
    LWDEV = "True";
    DOCKER_LW_ENV = "$HOME/workspace/lw/devsetup/";
  };

  programs.git = {
    enable = true;

    settings = {
      user = {
        email = "george.papadokostakis@learnworlds.com";
        username = "Giorgos Papadokostakis";
      };

      alias = {
        retag = "!f() { git tag -f -a \"$1\" -m \"$1\" && git push origin \"$1\" -f; }; f";
        deltag = "!f() { git tag -d \"$1\" && git push --delete origin \"$1\"; }; f";
      };

      core.editor = "nvim";
    };
  };

  programs.zsh = {
    shellAliases = {
      # lwdc = ''
      #   docker compose -f ${DOCKER_LW_ENV}docker-compose.yml \
      #     -f ${DOCKER_LW_ENV}extra/marketplace.yml \
      #     -f ${DOCKER_LW_ENV}extra/pubsub-emulator.yml \
      #     -f ${DOCKER_LW_ENV}extra/cloner.yml \
      #     -f ${DOCKER_LW_ENV}extra/account.yml \
      #     -f ${DOCKER_LW_ENV}extra/lwdemomaker.yml \
      #     -f ${DOCKER_LW_ENV}extra/iplocate.yml \
      # '';
      # TODO: Figure out how to put env vars in aliases

      # -f ${DOCKER_LW_ENV}docker-compose.override.yml"
      # -f ${DOCKER_LW_ENV}extra/adminer.yml \
      # -f ${DOCKER_LW_ENV}extra/lwconnector.yml \
      # -f ${DOCKER_LW_ENV}extra/website.yml \
      # -f ${DOCKER_LW_ENV}extra/cameraman.yml

      lwdc = ''
        docker compose -f /home/gpapadok/workspace/lw/devsetup/docker-compose.yml \
          -f /home/gpapadok/workspace/lw/devsetup/extra/marketplace.yml \
          -f /home/gpapadok/workspace/lw/devsetup/extra/pubsub-emulator.yml \
          -f /home/gpapadok/workspace/lw/devsetup/extra/cloner.yml \
          -f /home/gpapadok/workspace/lw/devsetup/extra/account.yml \
          -f /home/gpapadok/workspace/lw/devsetup/extra/lwdemomaker.yml \
          -f /home/gpapadok/workspace/lw/devsetup/extra/iplocate.yml \
      '';

      lwyarn = "docker exec -t codeneurons-builder yarn";
      lwphpunit = ''
        lwdc exec api php vendor/bin/phpunit \
          --bootstrap /app/tests/bootstrap.php \
          --configuration /app/phpunit.xml
      '';
      lwstagingrestart = ''
        kubectl rollout restart deploy/api deploy/neuron deploy/client deploy/assets deploy/queue \
          deploy/analytics deploy/marketplace deploy/apitasks-marketplace
      '';
      neuronpod = "kubectl get pods | grep neuron | awk \"{ print \$1 }\"";
      lwartisan = "lwdc exec marketplace php artisan";
    };
  };
}
