export 'stream_attachment_handler_base.dart'
    if (dart.library.js_interop) 'stream_attachment_handler_html.dart'
    if (dart.library.io) 'stream_attachment_handler_io.dart'
    show StreamAttachmentHandler;
