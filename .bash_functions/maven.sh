# shellcheck disable=SC2148
_mvn() {
  local VIRT_REGISTRY=${VIRT_REGISTRY:="host.docker.internal:5000"}
  local IMAGE_M2_DIR=/home/builder
  local IMAGE=$VIRT_REGISTRY/jbuilder:0.1-jdk8

  docker run --rm -it -u"$(id -u)":"$(id -g)" \
    -v"$HOME"/.m2:"$IMAGE_M2_DIR"/.m2 \
    -v"$(pwd)":/io/dev \
    -w /io/dev \
    -e MAVEN_OPTS="$MAVEN_OPTS -Duser.home=$IMAGE_M2_DIR" \
    "$IMAGE" mvn "$@"
}
