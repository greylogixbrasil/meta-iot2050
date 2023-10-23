# Generated by the gRPC Python protocol compiler plugin. DO NOT EDIT!
"""Client and server classes corresponding to protobuf-defined services."""
import grpc

from gRPC.EventInterface import iot2050_event_pb2 as gRPC_dot_EventInterface_dot_iot2050__event__pb2


class EventRecordStub(object):
    """Missing associated documentation comment in .proto file."""

    def __init__(self, channel):
        """Constructor.

        Args:
            channel: A grpc.Channel.
        """
        self.Write = channel.unary_unary(
                '/eventrecord.EventRecord/Write',
                request_serializer=gRPC_dot_EventInterface_dot_iot2050__event__pb2.WriteRequest.SerializeToString,
                response_deserializer=gRPC_dot_EventInterface_dot_iot2050__event__pb2.WriteReply.FromString,
                )
        self.Read = channel.unary_unary(
                '/eventrecord.EventRecord/Read',
                request_serializer=gRPC_dot_EventInterface_dot_iot2050__event__pb2.ReadRequest.SerializeToString,
                response_deserializer=gRPC_dot_EventInterface_dot_iot2050__event__pb2.ReadReply.FromString,
                )


class EventRecordServicer(object):
    """Missing associated documentation comment in .proto file."""

    def Write(self, request, context):
        """Missing associated documentation comment in .proto file."""
        context.set_code(grpc.StatusCode.UNIMPLEMENTED)
        context.set_details('Method not implemented!')
        raise NotImplementedError('Method not implemented!')

    def Read(self, request, context):
        """Missing associated documentation comment in .proto file."""
        context.set_code(grpc.StatusCode.UNIMPLEMENTED)
        context.set_details('Method not implemented!')
        raise NotImplementedError('Method not implemented!')


def add_EventRecordServicer_to_server(servicer, server):
    rpc_method_handlers = {
            'Write': grpc.unary_unary_rpc_method_handler(
                    servicer.Write,
                    request_deserializer=gRPC_dot_EventInterface_dot_iot2050__event__pb2.WriteRequest.FromString,
                    response_serializer=gRPC_dot_EventInterface_dot_iot2050__event__pb2.WriteReply.SerializeToString,
            ),
            'Read': grpc.unary_unary_rpc_method_handler(
                    servicer.Read,
                    request_deserializer=gRPC_dot_EventInterface_dot_iot2050__event__pb2.ReadRequest.FromString,
                    response_serializer=gRPC_dot_EventInterface_dot_iot2050__event__pb2.ReadReply.SerializeToString,
            ),
    }
    generic_handler = grpc.method_handlers_generic_handler(
            'eventrecord.EventRecord', rpc_method_handlers)
    server.add_generic_rpc_handlers((generic_handler,))


 # This class is part of an EXPERIMENTAL API.
class EventRecord(object):
    """Missing associated documentation comment in .proto file."""

    @staticmethod
    def Write(request,
            target,
            options=(),
            channel_credentials=None,
            call_credentials=None,
            insecure=False,
            compression=None,
            wait_for_ready=None,
            timeout=None,
            metadata=None):
        return grpc.experimental.unary_unary(request, target, '/eventrecord.EventRecord/Write',
            gRPC_dot_EventInterface_dot_iot2050__event__pb2.WriteRequest.SerializeToString,
            gRPC_dot_EventInterface_dot_iot2050__event__pb2.WriteReply.FromString,
            options, channel_credentials,
            insecure, call_credentials, compression, wait_for_ready, timeout, metadata)

    @staticmethod
    def Read(request,
            target,
            options=(),
            channel_credentials=None,
            call_credentials=None,
            insecure=False,
            compression=None,
            wait_for_ready=None,
            timeout=None,
            metadata=None):
        return grpc.experimental.unary_unary(request, target, '/eventrecord.EventRecord/Read',
            gRPC_dot_EventInterface_dot_iot2050__event__pb2.ReadRequest.SerializeToString,
            gRPC_dot_EventInterface_dot_iot2050__event__pb2.ReadReply.FromString,
            options, channel_credentials,
            insecure, call_credentials, compression, wait_for_ready, timeout, metadata)
