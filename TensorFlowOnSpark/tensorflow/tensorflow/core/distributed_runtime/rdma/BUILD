# Description:
#   RDMA communication interfaces and implementations for TensorFlow.

licenses(["notice"])  # Apache 2.0

exports_files(["LICENSE"])

filegroup(
    name = "all_files",
    srcs = glob(
        ["**/*"],
        exclude = [
            "**/METADATA",
            "**/OWNERS",
        ],
    ),
    visibility = ["//tensorflow:__subpackages__"],
)

filegroup(
    name = "c_srcs",
    data = glob([
        "**/*.cc",
        "**/*.h",
    ]),
)

load(
    "//tensorflow:tensorflow.bzl",
    "tf_cuda_library",
)
load("//tensorflow:tensorflow.bzl", "tf_cuda_cc_tests")

# For platform specific build config
load(
    "//tensorflow/core:platform/default/build_config.bzl",
    "tf_kernel_tests_linkstatic",
)
load(
    "//tensorflow/core:platform/default/build_config_root.bzl",
    "tf_cuda_tests_tags",
)

package(default_visibility = [
    "//tensorflow:internal",
])

cc_library(
    name = "rdma_rendezvous_mgr",
    srcs = ["rdma_rendezvous_mgr.cc"],
    hdrs = ["rdma_rendezvous_mgr.h"],
    deps = [
        "//tensorflow/core:core_cpu_internal",
        "//tensorflow/core:framework",
        "//tensorflow/core:lib",
        "//tensorflow/core/distributed_runtime:base_rendezvous_mgr",
        "//tensorflow/core/distributed_runtime:worker_env",
        ":rdma_mgr",
    ],
    copts = ["-DUSE_RDMA"],
)

cc_library(
    name = "rdma_mgr",
    srcs = ["rdma_mgr.cc"],
    hdrs = ["rdma_mgr.h"],
    deps = [
        "//tensorflow/core:core_cpu_internal",
        "//tensorflow/core:framework",
        "//tensorflow/core:lib",
        "//tensorflow/core:lib_internal",
        "//tensorflow/core:worker_proto_cc",
        "//tensorflow/core/distributed_runtime:worker_env",
        "//tensorflow/core/distributed_runtime:worker_cache",
        "//tensorflow/core/distributed_runtime:worker_interface",
        ":rdma",
    ],
    copts = ["-DUSE_RDMA"],
)

cc_library(
    name = "rdma",
    srcs = ["rdma.cc"],
    hdrs = ["rdma.h"],
    deps = [
        "//tensorflow/core:core_cpu_internal",
        "//tensorflow/core:framework",
        "//tensorflow/core:gpu_runtime",
        "//tensorflow/core:lib",
        "//tensorflow/core:lib_internal",
        "//tensorflow/core/distributed_runtime:rendezvous_mgr_interface",
        "//tensorflow/core/distributed_runtime:worker_env",
    ],
    copts = ["-DUSE_RDMA"],
    linkopts = [ 
	"-libverbs",
    ],
)
