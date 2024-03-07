#!/bin/bash

assert_exists() {
  p="$1"
  if [[ ! -e "$p" ]]; then
    echo "FAIL!"
    echo " ===> FAIL!"
    echo "Expected $p to exist, but it didn't"
  fi
}

test_version() {
  ver="$1"
  echo "== Testing $ver =="
  set -x
  USE_BAZEL_VERSION="$ver" bazel clean --expunge 2>/dev/null
  USE_BAZEL_VERSION="$ver" bazel build //proto:proto_go_proto 2>/dev/null
  outfile=$(USE_BAZEL_VERSION="$ver" bazel aquery "outputs(\".*.go\", //proto:proto_go_proto)" 2>/dev/null | grep "Outputs" | sed 's#.*Outputs: \[\(.*\)\]#\1#')
  set +x
  assert_exists $(echo "$outfile" | sed 's:test.pb.go::')
  assert_exists "$outfile"
}
test_version "7.0.2"
test_version "6.4.0"
test_version "7.0.2"
