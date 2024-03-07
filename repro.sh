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
  set +x
  assert_exists bazel-out/darwin_arm64-fastbuild/bin/proto/proto_go_proto_/github.com/blorente/scratch/proto/
  assert_exists bazel-out/darwin_arm64-fastbuild/bin/proto/proto_go_proto_/github.com/blorente/scratch/proto/test.pb.go

  echo "==> Ver $ver OK!"
}
test_version "7.0.2"
test_version "6.4.0"
test_version "7.0.2"
