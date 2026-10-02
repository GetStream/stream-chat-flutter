// ignore_for_file: public_member_api_docs

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:stream_core/stream_core.dart' show Result, runApiSafely;

import '../../open_api/models.dart';

part 'cdn_api.g.dart';

@RestApi(callAdapter: _ResultCallAdapter)
abstract interface class CdnApi {
  factory CdnApi(
    Dio dio, {
    String? baseUrl,
  }) = _CdnApi;

  @MultiPart()
  @POST('/api/v2/uploads/file')
  Future<Result<FileUploadResponse>> uploadFile({
    @Part(name: 'file') MultipartFile? file,
    @Part(name: 'user') OnlyUserID? user,
    @SendProgress() ProgressCallback? onUploadProgress,
    @CancelRequest() CancelToken? cancelToken,
  });

  @DELETE('/api/v2/uploads/file')
  Future<Result<DurationResponse>> deleteFile({
    @Query('url') String? url,
    @CancelRequest() CancelToken? cancelToken,
  });

  @MultiPart()
  @POST('/api/v2/uploads/image')
  Future<Result<ImageUploadResponse>> uploadImage({
    @Part(name: 'file') MultipartFile? file,
    @Part(name: 'upload_sizes') List<ImageSize>? uploadSizes,
    @Part(name: 'user') OnlyUserID? user,
    @SendProgress() ProgressCallback? onUploadProgress,
    @CancelRequest() CancelToken? cancelToken,
  });

  @DELETE('/api/v2/uploads/image')
  Future<Result<DurationResponse>> deleteImage({
    @Query('url') String? url,
    @CancelRequest() CancelToken? cancelToken,
  });

  @MultiPart()
  @POST('/api/v2/chat/channels/{type}/{id}/file')
  Future<Result<UploadChannelFileResponse>> uploadChannelFile({
    @Path('type') required String type,
    @Path('id') required String id,
    @Part(name: 'file') MultipartFile? file,
    @Part(name: 'user') OnlyUserID? user,
    @SendProgress() ProgressCallback? onUploadProgress,
    @CancelRequest() CancelToken? cancelToken,
  });

  @DELETE('/api/v2/chat/channels/{type}/{id}/file')
  Future<Result<DurationResponse>> deleteChannelFile({
    @Path('type') required String type,
    @Path('id') required String id,
    @Query('url') String? url,
    @CancelRequest() CancelToken? cancelToken,
  });

  @MultiPart()
  @POST('/api/v2/chat/channels/{type}/{id}/image')
  Future<Result<UploadChannelResponse>> uploadChannelImage({
    @Path('type') required String type,
    @Path('id') required String id,
    @Part(name: 'file') MultipartFile? file,
    @Part(name: 'upload_sizes') List<ImageSize>? uploadSizes,
    @Part(name: 'user') OnlyUserID? user,
    @SendProgress() ProgressCallback? onUploadProgress,
    @CancelRequest() CancelToken? cancelToken,
  });

  @DELETE('/api/v2/chat/channels/{type}/{id}/image')
  Future<Result<DurationResponse>> deleteChannelImage({
    @Path('type') required String type,
    @Path('id') required String id,
    @Query('url') String? url,
    @CancelRequest() CancelToken? cancelToken,
  });
}

class _ResultCallAdapter<T> extends CallAdapter<Future<T>, Future<Result<T>>> {
  @override
  Future<Result<T>> adapt(Future<T> Function() call) => runApiSafely(call);
}
