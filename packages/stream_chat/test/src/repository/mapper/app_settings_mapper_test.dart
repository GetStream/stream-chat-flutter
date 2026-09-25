import 'package:stream_chat/open_api/api.dart' as api;
import 'package:stream_chat/src/core/models/app_settings.dart';
import 'package:stream_chat/src/core/models/upload_config.dart';
import 'package:stream_chat/src/repository/mapper/app_settings_mapper.dart';
import 'package:test/test.dart';

void main() {
  test('FileUploadConfig.toModel maps every field of the generated config', () {
    expect(_fileUploadConfig.toModel(), _uploadConfig);
  });

  test('AppResponseFields.toModel maps every field of a fully populated response', () {
    expect(_appResponseFields.toModel(), _appSettings);
  });

  test('GetApplicationResponse.toModel keeps the duration', () {
    const response = api.GetApplicationResponse(duration: '0.02ms', app: _appResponseFields);

    expect(response.toModel().duration, '0.02ms');
  });

  test('GetApplicationResponse.toModel maps the app', () {
    const response = api.GetApplicationResponse(duration: '0.01ms', app: _appResponseFields);

    expect(response.toModel().app, _appSettings);
  });
}

const _fileUploadConfig = api.FileUploadConfig(
  sizeLimit: 10485760,
  allowedFileExtensions: ['.csv', '.pdf'],
  blockedFileExtensions: ['.exe'],
  allowedMimeTypes: ['text/csv', 'application/pdf'],
  blockedMimeTypes: ['application/x-msdownload'],
);

const _imageUploadConfig = api.FileUploadConfig(
  sizeLimit: 5242880,
  allowedFileExtensions: ['.png', '.jpg'],
  blockedFileExtensions: ['.gif'],
  allowedMimeTypes: ['image/png', 'image/jpeg'],
  blockedMimeTypes: ['image/gif'],
);

const _appResponseFields = api.AppResponseFields(
  id: 42,
  name: 'test-app',
  placement: 'us-east',
  fileUploadConfig: _fileUploadConfig,
  imageUploadConfig: _imageUploadConfig,
  autoTranslationEnabled: true,
  asyncUrlEnrichEnabled: false,
);

const _uploadConfig = UploadConfig(
  sizeLimit: 10485760,
  allowedFileExtensions: ['.csv', '.pdf'],
  blockedFileExtensions: ['.exe'],
  allowedMimeTypes: ['text/csv', 'application/pdf'],
  blockedMimeTypes: ['application/x-msdownload'],
);

const _appSettings = AppSettings(
  name: 'test-app',
  fileUploadConfig: _uploadConfig,
  imageUploadConfig: UploadConfig(
    sizeLimit: 5242880,
    allowedFileExtensions: ['.png', '.jpg'],
    blockedFileExtensions: ['.gif'],
    allowedMimeTypes: ['image/png', 'image/jpeg'],
    blockedMimeTypes: ['image/gif'],
  ),
  autoTranslationEnabled: true,
);
