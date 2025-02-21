import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/icons/stream_svg_icon.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';

void main() {
  for (final brightness in Brightness.values) {
    goldenTest(
      '[${brightness.name}] -> StreamSvgIcon should look fine',
      fileName: 'stream_svg_icon_${brightness.name}',
      constraints: const BoxConstraints.tightFor(width: 800, height: 1200),
      builder: () => _wrapWithMaterialApp(
        brightness: brightness,
        Column(
          children: [
            // Monochrome svg icons
            Expanded(
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                runAlignment: WrapAlignment.center,
                children: [
                  _buildIcon(StreamSvgIcons.checkAll),
                  _buildIcon(StreamSvgIcons.lightning),
                  _buildIcon(StreamSvgIcons.error),
                  _buildIcon(StreamSvgIcons.userAdd),
                  _buildIcon(StreamSvgIcons.penWrite),
                  _buildIcon(StreamSvgIcons.share),
                  _buildIcon(StreamSvgIcons.record),
                  _buildIcon(StreamSvgIcons.message),
                  _buildIcon(StreamSvgIcons.moon),
                  _buildIcon(StreamSvgIcons.left),
                  _buildIcon(StreamSvgIcons.emptyCircleRight),
                  _buildIcon(StreamSvgIcons.save),
                  _buildIcon(StreamSvgIcons.cloudDownload),
                  _buildIcon(StreamSvgIcons.settings),
                  _buildIcon(StreamSvgIcons.mentions),
                  _buildIcon(StreamSvgIcons.circleUp),
                  _buildIcon(StreamSvgIcons.copy),
                  _buildIcon(StreamSvgIcons.download),
                  _buildIcon(StreamSvgIcons.send),
                  _buildIcon(StreamSvgIcons.messageUnread),
                  _buildIcon(StreamSvgIcons.search),
                  _buildIcon(StreamSvgIcons.userSettings),
                  _buildIcon(StreamSvgIcons.shareArrow),
                  _buildIcon(StreamSvgIcons.polls),
                  _buildIcon(StreamSvgIcons.smile),
                  _buildIcon(StreamSvgIcons.right),
                  _buildIcon(StreamSvgIcons.videoCall),
                  _buildIcon(StreamSvgIcons.close),
                  _buildIcon(StreamSvgIcons.closeSmall),
                  _buildIcon(StreamSvgIcons.volumeUp),
                  _buildIcon(StreamSvgIcons.mute),
                  _buildIcon(StreamSvgIcons.threadReply),
                  _buildIcon(StreamSvgIcons.sendMessage),
                  _buildIcon(StreamSvgIcons.edit),
                  _buildIcon(StreamSvgIcons.award),
                  _buildIcon(StreamSvgIcons.userDelete),
                  _buildIcon(StreamSvgIcons.attach),
                  _buildIcon(StreamSvgIcons.notification),
                  _buildIcon(StreamSvgIcons.userRemove),
                  _buildIcon(StreamSvgIcons.arrowRight),
                  _buildIcon(StreamSvgIcons.pin),
                  _buildIcon(StreamSvgIcons.time),
                  _buildIcon(StreamSvgIcons.reply),
                  _buildIcon(StreamSvgIcons.delete),
                  _buildIcon(StreamSvgIcons.check),
                  _buildIcon(StreamSvgIcons.flag),
                  _buildIcon(StreamSvgIcons.menuPoint),
                  _buildIcon(StreamSvgIcons.up),
                  _buildIcon(StreamSvgIcons.eye),
                  _buildIcon(StreamSvgIcons.retry),
                  _buildIcon(StreamSvgIcons.group),
                  _buildIcon(StreamSvgIcons.contacts),
                  _buildIcon(StreamSvgIcons.pictures),
                  _buildIcon(StreamSvgIcons.checkSend),
                  _buildIcon(StreamSvgIcons.camera),
                  _buildIcon(StreamSvgIcons.wutReaction),
                  _buildIcon(StreamSvgIcons.lolReaction),
                  _buildIcon(StreamSvgIcons.loveReaction),
                  _buildIcon(StreamSvgIcons.thumbsUpReaction),
                  _buildIcon(StreamSvgIcons.thumbsDownReaction),
                  _buildIcon(StreamSvgIcons.grid),
                  _buildIcon(StreamSvgIcons.user),
                  _buildIcon(StreamSvgIcons.files),
                  _buildIcon(StreamSvgIcons.reload),
                  _buildIcon(StreamSvgIcons.down),
                  _buildIcon(StreamSvgIcons.lock),
                  _buildIcon(StreamSvgIcons.mic),
                  _buildIcon(StreamSvgIcons.pause),
                  _buildIcon(StreamSvgIcons.play),
                  _buildIcon(StreamSvgIcons.stop),
                  _buildIcon(StreamSvgIcons.link),
                ],
              ),
            ),
            // Colored svg icons which preserves their color.
            Expanded(
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                runAlignment: WrapAlignment.center,
                children: [
                  _buildIcon(StreamSvgIcons.filetypePresentationPps),
                  _buildIcon(StreamSvgIcons.filetypeCompressionRar),
                  _buildIcon(StreamSvgIcons.filetypeSpreadsheetXlsx),
                  _buildIcon(StreamSvgIcons.filetypePresentationStandard),
                  _buildIcon(StreamSvgIcons.filetypePresentationSpecial),
                  _buildIcon(StreamSvgIcons.filetypeSpreadsheetSpecial),
                  _buildIcon(StreamSvgIcons.filetypeAudioSpecial),
                  _buildIcon(StreamSvgIcons.filetypeCodeTar),
                  _buildIcon(StreamSvgIcons.filetypePresentationOdp),
                  _buildIcon(StreamSvgIcons.filetypeAudioMp3),
                  _buildIcon(StreamSvgIcons.filetypeCompressionDeb),
                  _buildIcon(StreamSvgIcons.filetypeSpreadsheetXlsm),
                  _buildIcon(StreamSvgIcons.imgur),
                  _buildIcon(StreamSvgIcons.filetypeTextOdt),
                  _buildIcon(StreamSvgIcons.filetypePresentationPpt),
                  _buildIcon(StreamSvgIcons.filetypeCodeStandard),
                  _buildIcon(StreamSvgIcons.filetypeAudioFlac),
                  _buildIcon(StreamSvgIcons.filetypeTextSpecial),
                  _buildIcon(StreamSvgIcons.filetypeSpreadsheetOds),
                  _buildIcon(StreamSvgIcons.filetypeCodeXml),
                  _buildIcon(StreamSvgIcons.filetypeCompressionPkg),
                  _buildIcon(StreamSvgIcons.filetypeSpreadsheetXls),
                  _buildIcon(StreamSvgIcons.filetypeTextWdp),
                  _buildIcon(StreamSvgIcons.filetypeCompressionZip),
                  _buildIcon(StreamSvgIcons.filetypeSpreadsheetStandard),
                  _buildIcon(StreamSvgIcons.filetypeAudioAac),
                  _buildIcon(StreamSvgIcons.filetypeOtherPdf),
                  _buildIcon(StreamSvgIcons.filetypeCodeSav),
                  _buildIcon(StreamSvgIcons.filetypeCompressionRpm),
                  _buildIcon(StreamSvgIcons.filetypeOtherSpecial),
                  _buildIcon(StreamSvgIcons.filetypeAudioM4a),
                  _buildIcon(StreamSvgIcons.filetypeAudioM4b),
                  _buildIcon(StreamSvgIcons.filetypeCompressionArj),
                  _buildIcon(StreamSvgIcons.filetypeTextStandard),
                  _buildIcon(StreamSvgIcons.filetypeCodeMd),
                  _buildIcon(StreamSvgIcons.giphy),
                  _buildIcon(StreamSvgIcons.filetypeTextTxt),
                  _buildIcon(StreamSvgIcons.filetypeTextRtf),
                  _buildIcon(StreamSvgIcons.filetypeCompression7z),
                  _buildIcon(StreamSvgIcons.filetypeAudioStandard),
                  _buildIcon(StreamSvgIcons.filetypeOtherStandard),
                  _buildIcon(StreamSvgIcons.filetypeCodeCsv),
                  _buildIcon(StreamSvgIcons.filetypeCodeHtml),
                  _buildIcon(StreamSvgIcons.filetypeCodeDat),
                  _buildIcon(StreamSvgIcons.filetypePresentationPptx),
                  _buildIcon(StreamSvgIcons.filetypeOtherWkq),
                  _buildIcon(StreamSvgIcons.filetypeCompressionZ),
                  _buildIcon(StreamSvgIcons.filetypeAudioAiff),
                  _buildIcon(StreamSvgIcons.filetypeCodeSpecial),
                  _buildIcon(StreamSvgIcons.filetypeCompressionStandard),
                  _buildIcon(StreamSvgIcons.filetypeTextDoc),
                  _buildIcon(StreamSvgIcons.filetypeAudioOgg),
                  _buildIcon(StreamSvgIcons.filetypeCompressionSpecial),
                  _buildIcon(StreamSvgIcons.filetypePresentationKey),
                  _buildIcon(StreamSvgIcons.filetypeAudioWav),
                  _buildIcon(StreamSvgIcons.filetypeTextTex),
                  _buildIcon(StreamSvgIcons.filetypeCodeDb),
                  _buildIcon(StreamSvgIcons.filetypeTextDocx),
                  _buildIcon(StreamSvgIcons.filetypeAudioAlac),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _wrapWithMaterialApp(
  Widget widget, {
  Brightness? brightness,
}) {
  return MaterialApp(
    home: Theme(
      data: ThemeData(brightness: brightness),
      child: StreamChatTheme(
        data: StreamChatThemeData(brightness: brightness),
        child: Builder(builder: (context) {
          final theme = StreamChatTheme.of(context);
          return Scaffold(
            backgroundColor: theme.colorTheme.appBg,
            body: Center(child: widget),
          );
        }),
      ),
    ),
  );
}

Widget _buildIcon(StreamSvgIconData icon) {
  return IconButton(
    iconSize: 48,
    onPressed: () {},
    icon: StreamSvgIcon(icon: icon),
  );
}
