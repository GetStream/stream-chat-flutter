// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cdn_api.dart';

// dart format off

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers,unused_element,unnecessary_string_interpolations,unused_element_parameter,avoid_unused_constructor_parameters,unreachable_from_main,avoid_redundant_argument_values

class _CdnApi implements CdnApi {
  _CdnApi(this._dio, {this.baseUrl, this.errorLogger});

  final Dio _dio;

  String? baseUrl;

  final ParseErrorLogger? errorLogger;

  Future<FileUploadResponse> _uploadFile({
    MultipartFile? file,
    void Function(int, int)? onUploadProgress,
    CancelToken? cancelToken,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    if (file != null) {
      _data.files.add(MapEntry('file', file));
    }
    final _options = _setStreamType<Result<FileUploadResponse>>(
      Options(
            method: 'POST',
            headers: _headers,
            extra: _extra,
            contentType: 'multipart/form-data',
          )
          .compose(
            _dio.options,
            '/api/v2/uploads/file',
            queryParameters: queryParameters,
            data: _data,
            cancelToken: cancelToken,
            onSendProgress: onUploadProgress,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late FileUploadResponse _value;
    try {
      _value = FileUploadResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<FileUploadResponse>> uploadFile({
    MultipartFile? file,
    void Function(int, int)? onUploadProgress,
    CancelToken? cancelToken,
  }) {
    return _ResultCallAdapter<FileUploadResponse>().adapt(
      () => _uploadFile(
        file: file,
        onUploadProgress: onUploadProgress,
        cancelToken: cancelToken,
      ),
    );
  }

  Future<DurationResponse> _deleteFile({
    String? url,
    CancelToken? cancelToken,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'url': url};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<DurationResponse>>(
      Options(method: 'DELETE', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/uploads/file',
            queryParameters: queryParameters,
            data: _data,
            cancelToken: cancelToken,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late DurationResponse _value;
    try {
      _value = DurationResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<DurationResponse>> deleteFile({
    String? url,
    CancelToken? cancelToken,
  }) {
    return _ResultCallAdapter<DurationResponse>().adapt(
      () => _deleteFile(url: url, cancelToken: cancelToken),
    );
  }

  Future<ImageUploadResponse> _uploadImage({
    MultipartFile? file,
    List<ImageSize>? uploadSizes,
    void Function(int, int)? onUploadProgress,
    CancelToken? cancelToken,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    if (file != null) {
      _data.files.add(MapEntry('file', file));
    }
    _data.fields.add(MapEntry('upload_sizes', jsonEncode(uploadSizes)));
    final _options = _setStreamType<Result<ImageUploadResponse>>(
      Options(
            method: 'POST',
            headers: _headers,
            extra: _extra,
            contentType: 'multipart/form-data',
          )
          .compose(
            _dio.options,
            '/api/v2/uploads/image',
            queryParameters: queryParameters,
            data: _data,
            cancelToken: cancelToken,
            onSendProgress: onUploadProgress,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ImageUploadResponse _value;
    try {
      _value = ImageUploadResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<ImageUploadResponse>> uploadImage({
    MultipartFile? file,
    List<ImageSize>? uploadSizes,
    void Function(int, int)? onUploadProgress,
    CancelToken? cancelToken,
  }) {
    return _ResultCallAdapter<ImageUploadResponse>().adapt(
      () => _uploadImage(
        file: file,
        uploadSizes: uploadSizes,
        onUploadProgress: onUploadProgress,
        cancelToken: cancelToken,
      ),
    );
  }

  Future<DurationResponse> _deleteImage({
    String? url,
    CancelToken? cancelToken,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'url': url};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<DurationResponse>>(
      Options(method: 'DELETE', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/uploads/image',
            queryParameters: queryParameters,
            data: _data,
            cancelToken: cancelToken,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late DurationResponse _value;
    try {
      _value = DurationResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<DurationResponse>> deleteImage({
    String? url,
    CancelToken? cancelToken,
  }) {
    return _ResultCallAdapter<DurationResponse>().adapt(
      () => _deleteImage(url: url, cancelToken: cancelToken),
    );
  }

  Future<UploadChannelFileResponse> _uploadChannelFile({
    required String type,
    required String id,
    MultipartFile? file,
    void Function(int, int)? onUploadProgress,
    CancelToken? cancelToken,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    if (file != null) {
      _data.files.add(MapEntry('file', file));
    }
    final _options = _setStreamType<Result<UploadChannelFileResponse>>(
      Options(
            method: 'POST',
            headers: _headers,
            extra: _extra,
            contentType: 'multipart/form-data',
          )
          .compose(
            _dio.options,
            '/api/v2/chat/channels/${type}/${id}/file',
            queryParameters: queryParameters,
            data: _data,
            cancelToken: cancelToken,
            onSendProgress: onUploadProgress,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late UploadChannelFileResponse _value;
    try {
      _value = UploadChannelFileResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<UploadChannelFileResponse>> uploadChannelFile({
    required String type,
    required String id,
    MultipartFile? file,
    void Function(int, int)? onUploadProgress,
    CancelToken? cancelToken,
  }) {
    return _ResultCallAdapter<UploadChannelFileResponse>().adapt(
      () => _uploadChannelFile(
        type: type,
        id: id,
        file: file,
        onUploadProgress: onUploadProgress,
        cancelToken: cancelToken,
      ),
    );
  }

  Future<DurationResponse> _deleteChannelFile({
    required String type,
    required String id,
    String? url,
    CancelToken? cancelToken,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'url': url};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<DurationResponse>>(
      Options(method: 'DELETE', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/chat/channels/${type}/${id}/file',
            queryParameters: queryParameters,
            data: _data,
            cancelToken: cancelToken,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late DurationResponse _value;
    try {
      _value = DurationResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<DurationResponse>> deleteChannelFile({
    required String type,
    required String id,
    String? url,
    CancelToken? cancelToken,
  }) {
    return _ResultCallAdapter<DurationResponse>().adapt(
      () => _deleteChannelFile(
        type: type,
        id: id,
        url: url,
        cancelToken: cancelToken,
      ),
    );
  }

  Future<UploadChannelResponse> _uploadChannelImage({
    required String type,
    required String id,
    MultipartFile? file,
    List<ImageSize>? uploadSizes,
    void Function(int, int)? onUploadProgress,
    CancelToken? cancelToken,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    if (file != null) {
      _data.files.add(MapEntry('file', file));
    }
    _data.fields.add(MapEntry('upload_sizes', jsonEncode(uploadSizes)));
    final _options = _setStreamType<Result<UploadChannelResponse>>(
      Options(
            method: 'POST',
            headers: _headers,
            extra: _extra,
            contentType: 'multipart/form-data',
          )
          .compose(
            _dio.options,
            '/api/v2/chat/channels/${type}/${id}/image',
            queryParameters: queryParameters,
            data: _data,
            cancelToken: cancelToken,
            onSendProgress: onUploadProgress,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late UploadChannelResponse _value;
    try {
      _value = UploadChannelResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<UploadChannelResponse>> uploadChannelImage({
    required String type,
    required String id,
    MultipartFile? file,
    List<ImageSize>? uploadSizes,
    void Function(int, int)? onUploadProgress,
    CancelToken? cancelToken,
  }) {
    return _ResultCallAdapter<UploadChannelResponse>().adapt(
      () => _uploadChannelImage(
        type: type,
        id: id,
        file: file,
        uploadSizes: uploadSizes,
        onUploadProgress: onUploadProgress,
        cancelToken: cancelToken,
      ),
    );
  }

  Future<DurationResponse> _deleteChannelImage({
    required String type,
    required String id,
    String? url,
    CancelToken? cancelToken,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'url': url};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Result<DurationResponse>>(
      Options(method: 'DELETE', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v2/chat/channels/${type}/${id}/image',
            queryParameters: queryParameters,
            data: _data,
            cancelToken: cancelToken,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late DurationResponse _value;
    try {
      _value = DurationResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Result<DurationResponse>> deleteChannelImage({
    required String type,
    required String id,
    String? url,
    CancelToken? cancelToken,
  }) {
    return _ResultCallAdapter<DurationResponse>().adapt(
      () => _deleteChannelImage(
        type: type,
        id: id,
        url: url,
        cancelToken: cancelToken,
      ),
    );
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }

  String _combineBaseUrls(String dioBaseUrl, String? baseUrl) {
    if (baseUrl == null || baseUrl.trim().isEmpty) {
      return dioBaseUrl;
    }

    final url = Uri.parse(baseUrl);

    if (url.isAbsolute) {
      return url.toString();
    }

    return Uri.parse(dioBaseUrl).resolveUri(url).toString();
  }
}

// dart format on
