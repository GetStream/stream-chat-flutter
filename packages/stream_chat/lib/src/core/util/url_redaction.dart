final _urlQuery = RegExp(r'''([a-zA-Z][a-zA-Z0-9+.-]*://[^\s'"?#]*)\?[^\s'"#]*''');

/// Returns [text] with the query string of every URL in it replaced by
/// `<redacted>`.
String withoutUrlQueries(String text) {
  return text.replaceAllMapped(_urlQuery, (match) => '${match[1]}?<redacted>');
}
