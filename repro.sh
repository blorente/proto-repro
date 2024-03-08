#!/bin/bash

assert_exists() {
  p="$1"
  if [[ ! -e "$p" ]]; then
    echo " ===> FAIL!"
    echo "Expected $p to exist, but it didn't"
  fi
}

test_version() {
  ver="$1"
  echo "== Testing $ver =="
  USE_BAZEL_VERSION="$ver" bazel "${bazel_startup_flags[@]}" clean "${bazel_flags[@]}" --expunge 2>/dev/null
  set -x
  USE_BAZEL_VERSION="$ver" bazel "${bazel_startup_flags[@]}" build "${bazel_flags[@]}" //proto:proto_go_proto 2>/dev/null
  if [[ "$?" != 0 ]]; then 
    echo "Bazel build failed!"
  fi
  set +x
  outfile=$(USE_BAZEL_VERSION="$ver" bazel "${bazel_startup_flags[@]}" aquery "outputs(\".*.go\", //proto:proto_go_proto)" 2>/dev/null | grep "Outputs" | sed 's#.*Outputs: \[\(.*\)\]#\1#')
  assert_exists $(echo "$outfile" | sed 's:test.pb.go::')
  assert_exists "$outfile"
}

# ---> Setting up the disk cache, not setting up the disk cache
echo "++++++ Setting a disk cache ++++++"
bazel_startup_flags=( "--nohome_rc" "--bazelrc=/dev/null" "--noworkspace_rc" "--nosystem_rc" )
bazel_flags=( "--disk_cache=/tmp/mycache" )

test_version "7.0.2"
test_version "6.4.0"
test_version "7.0.2"
test_version "7.0.2"

echo "++++++ Not Setting a disk cache ++++++"
bazel_startup_flags=( "--nohome_rc" "--bazelrc=/dev/null" "--noworkspace_rc" "--nosystem_rc" )
bazel_flags=( )

test_version "7.0.2"
test_version "6.4.0"
test_version "7.0.2"
test_version "7.0.2"

echo "++++++ Setting a disk cache to nothing ++++++"
bazel_startup_flags=( "--nohome_rc" "--bazelrc=/dev/null" "--noworkspace_rc" "--nosystem_rc" )
bazel_flags=( "--disk_cache=" )

test_version "7.0.2"
test_version "6.4.0"
test_version "7.0.2"
test_version "7.0.2"

# Previous tests. Please ignore these.
#
# === This works
# bazel_startup_flags=( "--bazelrc=/dev/null" "--nohome_rc" "--nosystem_rc" "--noworkspace_rc" )
# bazel_flags=( "--remote_download_all" )
# === Disabling the home rc
# bazel_startup_flags=( "--nohome_rc" )
# bazel_flags=( "--enable_bzlmod=False" )
# -> Removing disk cache
# bazel_startup_flags=( "--nohome_rc" )
# bazel_flags=( "--enable_bzlmod=False" "--repository_cache=~/.cache/bazel-repositories" )
#
# ---> Setting the disk cache to nothing
# This work, motherfuckers
# bazel_startup_flags=( "--nohome_rc" )
# bazel_flags=( "--enable_bzlmod=False" "--disk_cache=/tmp/muchachos" "--repository_cache=~/.cache/bazel-repositories" )

# === This doesn't work
# ===== Removing --nohome_rc
# 
# bazel_startup_flags=( "--bazelrc=/dev/null"  "--nosystem_rc" "--noworkspace_rc" )
# bazel_flags=( "--enable_bzlmod=False" )
#
# ===== Replicating home_rc
# bazel_startup_flags=( "--nohome_rc" )
# bazel_flags=( "--enable_bzlmod=False" "--disk_cache=~/.cache/bazel" "--repository_cache=~/.cache/bazel-repositories" )

# === This, I'm testing now
