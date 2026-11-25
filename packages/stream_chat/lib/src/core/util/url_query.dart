final _urlQuery = RegExp(r'''([a-zA-Z][a-zA-Z0-9+.-]*://[^\s'"?#]*)\?[^\s'"#]*''');

/// Replaces the query string of every URL in [text] with `<redacted>`.
String withoutUrlQueries(String text) {
  return text.replaceAllMapped(_urlQuery, (match) => '${match[1]}?<redacted>');
}
