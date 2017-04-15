## The Rdma components

* **Rdma adapter:** The base for Rdma communications. It may contain multiple channels and buffers.  It is responsible for handling various incoming Rdma messages.
* **Rdma channel:** Responsible for Rdma connection to a particular node. It manages multiple buffers. A channel has a callback table which stores all the callbacks for the requested tensors.
* **Rdma buffer:** Responsible for sending or receiving data. It has a fixed size memory to store the data. It has a queue to store the pending jobs. There are three types of buffers, message buffer, ACK buffer and tensor buffer. A channel has two message buffers, two ack buffers and many tensor buffers.
* **Rdma manager:** Manages the adapter and channels, including channel creation, channel setup via GRPC service, channel lookup, etc.
* **Rdma rendezvous manager:** manages multiple rdma rendezvous. 
* **Rdma rendezvous:** a derived class of BaseRemoteRendezvous. This class is the back end for "send" and "recv" ops. When the sendrecv_op wants to send or receive a tensor, it calls the rendezvous' "send" and "recv" functions respectively. Rendezvous are identified by "step_id", a random number, so that tensors for different iterations don't get mixed up.

## The SEND operation

In tensorflow, when rendezvous sends a tensor, it merely puts a tensor in a local table in the corresponding rendezvous. If the tensor has been requested, a callback exists in the table. "send" will activate the callback, which tries to send the tensor across the node.


##The RECV operation

When a tensor is requested, rendezvous' recv function is called. The function first places a callback in the channel's callback table, which will be activated once the tensor is sent from the source. In the next step, a message is sent to notify the source of the requested tensor. Once the source receives the message, it will check locally for the tensor, if not found, a callback is placed in the table, otherwise, the tensor id will be placed at corresponding Rdma buffer's job queue for future transmission. When a tensor is scheduled to be transmitted, the Rdma buffer needs to have the memory allocated and initialized (registered with the remote buffer info). If the memory is not ready, the transmission is deferred, a message is sent to the destination to establish the memory first. The other case a transimssion can be deferred is when the buffer is still being used by an on-going transmission.

##Three types of Rdma buffers

* **Message buffer:** responsible for sending message only.
* **Ack buffer:** once a message is sent, the recipient needs to send an ack via the ack buffer to free up the message buffer. An ack buffer is exclusively for its coupled message buffer.
* **Tensor buffer:** responsible for sending tensors. The recipient needs to send back a message to free up the sending buffer.

##Rdma packet format

|type|name_size|name|step_id|buffer_size|remote_addr|rkey|is_dead|data_type|tensor_shape|tensor_bytes|tensor_buffer|

## Six types of Rdma messages
* RDMA_MESSAGE_ACK
* RDMA_MESSAGE_BUFFER_IDLE
* RDMA_MESSAGE_BUFFER_REQUEST
* RDMA_MESSAGE_BUFFER_RESPONSE
* RDMA_MESSAGE_TENSOR_REQUEST
* RDMA_MESSAGE_TENSOR_WRITE

## Actions upon completing Rdma messages
* RDMA_MESSAGE_ACK
  * sender: mark local ack buffer idle.
  * receiver: mark remote message buffer idle, send next item.
* RDMA_MESSAGE_BUFFER_IDLE
  * sender: mark local message buffer idle, send next item.
  * receiver: send ack, set remote tensor buffer idle, send next item.
* RDMA_MESSAGE_BUFFER_REQUEST
  * sender: mark local message buffer idle, send next item.
  * receiver: send ack, find or create tensor buffer, send BUFFER_RESPONSE.
* RDMA_MESSAGE_BUFFER_RESPONSE
  * sender: mark local message buffer idle, send next item.
  * receiver: send ack, set remote buffer info, set local and remote buffer idle, send next item.
* RDMA_MESSAGE_TENSOR_REQUEST
  * sender: mark local message buffer idle, send next item.
  * receiver: send ack, find or create tensor buffer, enqueue tensor id, send next item.
* RDMA_MESSAGE_TENSOR_WRITE
  * sender: mark local message buffer idle, send next item.
  * receiver: run callback.


