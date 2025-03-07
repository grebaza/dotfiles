install_docker_compose() {
  local VERSION OS ARCH DESTINATION URL
  # Retrieve the latest release version from GitHub.
  VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep -Po '"tag_name": "\K.*\d')

  # Get OS and architecture once.
  OS=$(uname -s)
  ARCH=$(uname -m)

  DESTINATION="/usr/local/bin/docker-compose"
  URL="https://github.com/docker/compose/releases/download/${VERSION}/docker-compose-${OS}-${ARCH}"

  sudo curl -L "$URL" -o "$DESTINATION"
  sudo chmod 755 "$DESTINATION"
}

