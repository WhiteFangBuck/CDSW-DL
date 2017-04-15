// Copyright 2017 Yahoo Inc.
// Licensed under the terms of the Apache 2.0 license.
// Please see LICENSE file in the project root for terms.

#ifndef THIRD_PARTY_TENSORFLOW_CORE_DISTRIBUTED_RUNTIME_RDMA_RDMA_MGR_H_
#define THIRD_PARTY_TENSORFLOW_CORE_DISTRIBUTED_RUNTIME_RDMA_RDMA_MGR_H_

#include <string>
#include <unordered_map>

#include "tensorflow/core/distributed_runtime/rdma/rdma.h"
#include "tensorflow/core/distributed_runtime/worker_env.h"

namespace tensorflow {

class RdmaMgr {

 public:
  explicit RdmaMgr(const WorkerEnv* worker_env);
  ~RdmaMgr();
  RdmaChannel* FindChannel(string& key);
  void SetupChannels();
  const string& local_worker() { return local_worker_; }
  
 private:
  string local_worker_;
  size_t num_remote_workers_;
  const WorkerEnv* worker_env_;
  RdmaAdapter* rdma_adapter_;
  typedef std::unordered_map<string, RdmaChannel*> ChannelTable;
  ChannelTable channel_table_;
};

} // namespace tensorflow

#endif  // THIRD_PARTY_TENSORFLOW_CORE_DISTRIBUTED_RUNTIME_RDMA_RDMA_MGR_H_