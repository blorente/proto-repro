#!/bin/bash

bazel_6() {
  echo "Bazel 6..."
  (export USE_BAZEL_VERSION="6.4.0"
     bazel build "//proto:proto_go_proto" 2>/dev/null
     outfile=$(bazel aquery 'outputs(".*.go", //proto:proto_go_proto)' 2>/dev/null | grep "Outputs" | sed 's#.*Outputs: \[\(.*\)\]#\1#')
     if [[ -f "${outfile}" ]]; then
       echo "Bazel 6 - Exists"
     else
       echo "Bazel 6 - Doesn't exist!!"
     fi
  )
}

bazel_7() {
  echo "Bazel 7..."
  (export USE_BAZEL_VERSION="7.0.2"
     bazel build "//proto:proto_go_proto" 2>/dev/null
     outfile=$(bazel aquery 'outputs(".*.go", //proto:proto_go_proto)' 2>/dev/null | grep "Outputs" | sed 's#.*Outputs: \[\(.*\)\]#\1#')
     if [[ -f "${outfile}" ]]; then
       echo "Bazel 7 - Exists"
     else
       echo "Bazel 7 - Doesn't exist!!"
     fi
  )
}

for run in {1..10}; do
  echo "== Run ${run} =="
  bazel_7
  bazel_7
  bazel_6
done

