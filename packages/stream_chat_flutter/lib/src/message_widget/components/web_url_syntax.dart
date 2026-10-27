// The patterns and top-level domains below are adapted from
// androidx.core.util.PatternsCompat (androidx core 1.18.0), Copyright (C) The
// Android Open Source Project, licensed under the Apache License, Version 2.0.

import 'package:markdown/markdown.dart' as md;

/// Links a web address written without a scheme, such as `youtube.com` or
/// `getstream.io/chat`, and opens it over https.
///
/// The address must end in a known top-level domain, so file names such as
/// `config.json` stay plain text. Addresses with a scheme or starting with
/// `www.` are left to the markdown autolinks.
class WebUrlSyntax extends md.InlineSyntax {
  /// Creates a [WebUrlSyntax].
  WebUrlSyntax() : super(_hostLabels);

  // Where a link may start: at the start of a line, or after whitespace, an
  // opening bracket, a quote or an emphasis delimiter. Never inside a word,
  // a link label or an address, so `a_b.com` and `[label](url)` stay as they
  // are.
  static const _validPrecedingChars = {'\n', ' ', '\t', '(', '"', "'", '*', '~'};

  // Punctuation that ends the sentence around a link rather than the link.
  static const _trailingPunctuation = {'.', ',', ':', ';', '!', '?', "'", '"', '*', '~'};

  @override
  bool tryMatch(md.InlineParser parser, [int? startMatchPos]) {
    final start = startMatchPos ?? parser.pos;
    if (start > 0) {
      final precededBy = String.fromCharCode(parser.charAt(start - 1));
      if (!_validPrecedingChars.contains(precededBy)) return false;
    }

    final url = _matchUrl(parser.source, start);
    if (url == null || url.toLowerCase().startsWith('www.')) return false;

    // The local part of an email address, such as `anna.li@gmail.com`.
    final end = start + url.length;
    if (end < parser.source.length && parser.source[end] == '@') return false;

    if (_isInLinkLabel(parser.source, start)) return false;

    parser.writeText();
    _addLink(parser, url);
    return true;
  }

  // Unused: [tryMatch] matches and adds the link itself.
  @override
  bool onMatch(md.InlineParser parser, Match match) => false;

  void _addLink(md.InlineParser parser, String url) {
    final href = Uri.encodeFull('https://$url');
    final anchor = md.Element.text('a', url)..attributes['href'] = href;
    parser
      ..addNode(anchor)
      ..consume(url.length);
  }

  // Whether [start] is inside the label of a `[label](url)` link, which
  // already links its whole label.
  bool _isInLinkLabel(String source, int start) {
    final open = source.lastIndexOf('[', start);
    if (open == -1 || source.lastIndexOf(']', start) > open) return false;

    final close = source.indexOf(']', start);
    return close != -1 && source.startsWith('(', close + 1);
  }

  // The link starting at [start], or null if there is none.
  //
  // The host is matched as dot-separated labels first, and the top-level
  // domain is then looked up, dropping labels from the end until one is
  // known. Looking it up in a set keeps long, dot-heavy text fast.
  String? _matchUrl(String source, int start) {
    if (pattern.matchAsPrefix(source, start)?[0] case final labels?) {
      final parts = labels.split('.');
      final partStarts = <int>[start];
      for (final part in parts.take(parts.length - 1)) {
        partStarts.add(partStarts.last + part.length + 1);
      }

      for (var count = parts.length; count >= 2; count--) {
        final last = parts[count - 1];
        for (var length = last.length; length >= 2; length--) {
          if (!_isTopLevelDomain(last.substring(0, length))) continue;

          final end = _matchRest(source, partStarts[count - 1] + length);
          if (end != null) return _trimTrailing(source.substring(start, end));
        }
      }
    }

    if (_ipAddress.matchAsPrefix(source, start) case final ip?) {
      final end = _matchRest(source, ip.end);
      if (end != null) return _trimTrailing(source.substring(start, end));
    }

    return null;
  }

  // [url] without the punctuation that ends the sentence around it, as for
  // the markdown autolinks. A closing bracket stays when it closes one in the
  // link.
  String _trimTrailing(String url) {
    var trimmed = url;
    while (trimmed.isNotEmpty) {
      final last = trimmed[trimmed.length - 1];
      final opens = '('.allMatches(trimmed).length;
      final isUnclosedBracket = last == ')' && ')'.allMatches(trimmed).length > opens;
      if (!_trailingPunctuation.contains(last) && !isUnclosedBracket) break;

      trimmed = trimmed.substring(0, trimmed.length - 1);
    }
    return trimmed;
  }

  // Where the port and path after a host at [hostEnd] end, or null if the
  // host does not end at a word boundary.
  int? _matchRest(String source, int hostEnd) => _rest.matchAsPrefix(source, hostEnd)?.end;

  bool _isTopLevelDomain(String label) {
    return _topLevelDomains.contains(label) || _punycodeTld.hasMatch(label);
  }
}

// Non-ASCII characters allowed in a domain label or path, except spaces.
const _ucsChar = r'\u00A1-\u1FFF\u200B-\u2027\u202A-\u202E\u2030-\u2FFF\u3001-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF';

const _labelChar = 'a-zA-Z0-9$_ucsChar';

const _iriLabel = '[$_labelChar](?:[${_labelChar}_\\-]{0,61}[$_labelChar])?';

// Two or more dot-separated labels, the last of which holds the top-level
// domain.
const _hostLabels = '$_iriLabel(?:\\.$_iriLabel)+';

final _punycodeTld = RegExp(r'^xn\-\-[\w\-]{0,58}\w$');

final _ipAddress = RegExp(
  r'(?:25[0-5]|2[0-4][0-9]|[0-1][0-9]{2}|[1-9][0-9]|[1-9])\.(?:25[0-5]|2[0-4][0-9]|[0-1][0-9]{2}|[1-9][0-9]|[1-9]|0)'
  r'\.(?:25[0-5]|2[0-4][0-9]|[0-1][0-9]{2}|[1-9][0-9]|[1-9]|0)\.(?:25[0-5]|2[0-4][0-9]|[0-1][0-9]{2}|[1-9][0-9]|[0-9])',
);

const _portNumber = r'\:\d{1,5}';

const _pathAndQuery = "[/\\?](?:(?:[$_labelChar;/\\?:@&=#~\\-\\.\\+!\\*'\\(\\),_\\\$])|(?:%[a-fA-F0-9]{2}))*";

// An optional port and path, ending at a word boundary.
final _rest = RegExp('(?:$_portNumber)?(?:$_pathAndQuery)?(?:\\b|\$)');

// The IANA top-level domains a link without a scheme must end in.
final _topLevelDomains = _ianaTopLevelDomains.split(' ').toSet();

const _ianaTopLevelDomains =
    'aaa aarp abb abbott abbvie abc able abogado abudhabi ac academy accenture accountant accountants aco '
    'actor ad ads adult ae aeg aero aetna af afl africa ag agakhan agency ai aig airbus airforce airtel akdn '
    'al alibaba alipay allfinanz allstate ally alsace alstom am amazon americanexpress americanfamily amex '
    'amfam amica amsterdam analytics android anquan anz ao aol apartments app apple aq aquarelle ar arab '
    'aramco archi army arpa art arte as asda asia associates at athleta attorney au auction audi audible '
    'audio auspost author auto autos avianca aw aws ax axa az azure ba baby baidu banamex bananarepublic '
    'band bank bar barcelona barclaycard barclays barefoot bargains baseball basketball bauhaus bayern bb '
    'bbc bbt bbva bcg bcn bd be beats beauty beer bentley berlin best bestbuy bet bf bg bh bharti bi bible '
    'bid bike bing bingo bio biz bj black blackfriday blockbuster blog bloomberg blue bm bms bmw bn '
    'bnpparibas bo boats boehringer bofa bom bond boo book booking bosch bostik boston bot boutique box br '
    'bradesco bridgestone broadway broker brother brussels bs bt build builders business buy buzz bv bw by '
    'bz bzh ca cab cafe cal call calvinklein cam camera camp canon capetown capital capitalone car caravan '
    'cards care career careers cars casa case cash casino cat catering catholic cba cbn cbre cbs cc cd '
    'center ceo cern cf cfa cfd cg ch chanel channel charity chase chat cheap chintai christmas chrome '
    'church ci cipriani circle cisco citadel citi citic city cityeats ck cl claims cleaning click clinic '
    'clinique clothing cloud club clubmed cm cn co coach codes coffee college cologne com comcast commbank '
    'community company compare computer comsec condos construction consulting contact contractors cooking '
    'cool coop corsica country coupon coupons courses cpa cr credit creditcard creditunion cricket crown crs '
    'cruise cruises cu cuisinella cv cw cx cy cymru cyou cz dabur dad dance data date dating datsun day dclk '
    'dds de deal dealer deals degree delivery dell deloitte delta democrat dental dentist desi design dev '
    'dhl diamonds diet digital direct directory discount discover dish diy dj dk dm dnp do docs doctor dog '
    'domains dot download drive dtv dubai dunlop dupont durban dvag dvr dz earth eat ec eco edeka edu '
    'education ee eg email emerck energy engineer engineering enterprises epson equipment er ericsson erni '
    'es esq estate et etisalat eu eurovision eus events exchange expert exposed express extraspace fage fail '
    'fairwinds faith family fan fans farm farmers fashion fast fedex feedback ferrari ferrero fi fidelity '
    'fido film final finance financial fire firestone firmdale fish fishing fit fitness fj fk flickr flights '
    'flir florist flowers fly fm fo foo food football ford forex forsale forum foundation fox fr free '
    'fresenius frl frogans frontdoor frontier ftr fujitsu fun fund furniture futbol fyi ga gal gallery gallo '
    'gallup game games gap garden gay gb gbiz gd gdn ge gea gent genting george gf gg ggee gh gi gift gifts '
    'gives giving gl glass gle global globo gm gmail gmbh gmo gmx gn godaddy gold goldpoint golf goo '
    'goodyear goog google gop got gov gp gq gr grainger graphics gratis green gripe grocery group gs gt gu '
    'guardian gucci guge guide guitars guru gw gy hair hamburg hangout haus hbo hdfc hdfcbank health '
    'healthcare help helsinki here hermes hiphop hisamitsu hitachi hiv hk hkt hm hn hockey holdings holiday '
    'homedepot homegoods homes homesense honda horse hospital host hosting hot hotels hotmail house how hr '
    'hsbc ht hu hughes hyatt hyundai ibm icbc ice icu id ie ieee ifm ikano il im imamat imdb immo immobilien '
    'in inc industries infiniti info ing ink institute insurance insure int international intuit investments '
    'io ipiranga iq ir irish is ismaili ist istanbul it itau itv jaguar java jcb je jeep jetzt jewelry jio '
    'jll jm jmp jnj jo jobs joburg jot joy jp jpmorgan jprs juegos juniper kaufen kddi ke kerryhotels '
    'kerrylogistics kerryproperties kfh kg kh ki kia kids kim kinder kindle kitchen kiwi km kn koeln komatsu '
    'kosher kp kpmg kpn kr krd kred kuokgroup kw ky kyoto kz la lacaixa lamborghini lamer lancaster land '
    'landrover lanxess lasalle lat latino latrobe law lawyer lb lc lds lease leclerc lefrak legal lego lexus '
    'lgbt li lidl life lifeinsurance lifestyle lighting like lilly limited limo lincoln link lipsy live '
    'living lk llc llp loan loans locker locus lol london lotte lotto love lpl lplfinancial lr ls lt ltd '
    'ltda lu lundbeck luxe luxury lv ly ma madrid maif maison makeup man management mango map market '
    'marketing markets marriott marshalls mattel mba mc mckinsey md me med media meet melbourne meme '
    'memorial men menu merckmsd mg mh miami microsoft mil mini mint mit mitsubishi mk ml mlb mls mm mma mn '
    'mo mobi mobile moda moe moi mom monash money monster mormon mortgage moscow moto motorcycles mov movie '
    'mp mq mr ms msd mt mtn mtr mu museum music mv mw mx my mz na nab nagoya name natura navy nba nc ne nec '
    'net netbank netflix network neustar new news next nextdirect nexus nf nfl ng ngo nhk ni nico nike nikon '
    'ninja nissan nissay nl no nokia norton now nowruz nowtv np nr nra nrw ntt nu nyc nz obi observer office '
    'okinawa olayan olayangroup oldnavy ollo om omega one ong onl online ooo open oracle orange org organic '
    'origins osaka otsuka ott ovh pa page panasonic paris pars partners parts party pay pccw pe pet pf '
    'pfizer pg ph pharmacy phd philips phone photo photography photos physio pics pictet pictures pid pin '
    'ping pink pioneer pizza pk pl place play playstation plumbing plus pm pn pnc pohl poker politie porn '
    'post pr pramerica praxi press prime pro prod productions prof progressive promo properties property '
    'protection pru prudential ps pt pub pw pwc py qa qpon quebec quest racing radio re read realestate '
    'realtor realty recipes red redstone redumbrella rehab reise reisen reit reliance ren rent rentals '
    'repair report republican rest restaurant review reviews rexroth rich richardli ricoh ril rio rip ro '
    'rocher rocks rodeo rogers room rs rsvp ru rugby ruhr run rw rwe ryukyu sa saarland safe safety sakura '
    'sale salon samsclub samsung sandvik sandvikcoromant sanofi sap sarl sas save saxo sb sbi sbs sc sca scb '
    'schaeffler schmidt scholarships school schule schwarz science scot sd se search seat secure security '
    'seek select sener services seven sew sex sexy sfr sg sh shangrila sharp shaw shell shia shiksha shoes '
    'shop shopping shouji show showtime si silk sina singles site sj sk ski skin sky skype sl sling sm smart '
    'smile sn sncf so soccer social softbank software sohu solar solutions song sony soy spa space sport '
    'spot sr srl ss st stada staples star statebank statefarm stc stcgroup stockholm storage store stream '
    'studio study style su sucks supplies supply support surf surgery suzuki sv swatch swiss sx sy sydney '
    'systems sz tab taipei talk taobao target tatamotors tatar tattoo tax taxi tc tci td tdk team tech '
    'technology tel temasek tennis teva tf tg th thd theater theatre tiaa tickets tienda tips tires tirol tj '
    'tjmaxx tjx tk tkmaxx tl tm tmall tn to today tokyo tools top toray toshiba total tours town toyota toys '
    'tr trade trading training travel travelers travelersinsurance trust trv tt tube tui tunes tushu tv tvs '
    'tw tz ua ubank ubs ug uk unicom university uno uol ups us uy uz va vacations vana vanguard vc ve vegas '
    'ventures verisign versicherung vet vg vi viajes video vig viking villas vin vip virgin visa vision viva '
    'vivo vlaanderen vn vodka volkswagen volvo vote voting voto voyage vu wales walmart walter wang wanggou '
    'watch watches weather weatherchannel webcam weber website wed wedding weibo weir wf whoswho wien wiki '
    'williamhill win windows wine winners wme wolterskluwer woodside work works world wow ws wtc wtf xbox '
    'xerox xfinity xihuan xin xn--11b4c3d xn--1ck2e1b xn--1qqw23a xn--2scrj9c xn--30rr7y xn--3bst00m '
    'xn--3ds443g xn--3e0b707e xn--3hcrj9c xn--3pxu8k xn--42c2d9a xn--45br5cyl xn--45brj9c xn--45q11c '
    'xn--4dbrk0ce xn--4gbrim xn--54b7fta0cc xn--55qw42g xn--55qx5d xn--5su34j936bgsg xn--5tzm5g xn--6frz82g '
    'xn--6qq986b3xl xn--80adxhks xn--80ao21a xn--80aqecdr1a xn--80asehdb xn--80aswg xn--8y0a063a xn--90a3ac '
    'xn--90ae xn--90ais xn--9dbq2a xn--9et52u xn--9krt00a xn--b4w605ferd xn--bck1b9a5dre4c xn--c1avg '
    'xn--c2br7g xn--cck2b3b xn--cckwcxetd xn--cg4bki xn--clchc0ea0b2g2a9gcd xn--czr694b xn--czrs0t '
    'xn--czru2d xn--d1acj3b xn--d1alf xn--e1a4c xn--eckvdtc9d xn--efvy88h xn--fct429k xn--fhbei '
    'xn--fiq228c5hs xn--fiq64b xn--fiqs8s xn--fiqz9s xn--fjq720a xn--flw351e xn--fpcrj9c3d xn--fzc2c9e2c '
    'xn--fzys8d69uvgm xn--g2xx48c xn--gckr3f0f xn--gecrj9c xn--gk3at1e xn--h2breg3eve xn--h2brj9c '
    'xn--h2brj9c8c xn--hxt814e xn--i1b6b1a6a2e xn--imr513n xn--io0a7i xn--j1aef xn--j1amh xn--j6w193g '
    'xn--jlq480n2rg xn--jvr189m xn--kcrx77d1x4a xn--kprw13d xn--kpry57d xn--kput3i xn--l1acc xn--lgbbat1ad8j '
    'xn--mgb9awbf xn--mgba3a3ejt xn--mgba3a4f16a xn--mgba7c0bbn0a xn--mgbaakc7dvf xn--mgbaam7a8h '
    'xn--mgbab2bd xn--mgbah1a3hjkrd xn--mgbai9azgqp6j xn--mgbayh7gpa xn--mgbbh1a xn--mgbbh1a71e '
    'xn--mgbc0a9azcg xn--mgbca7dzdo xn--mgbcpq6gpa1a xn--mgberp4a5d4ar xn--mgbgu82a xn--mgbi4ecexp '
    'xn--mgbpl2fh xn--mgbt3dhd xn--mgbtx2b xn--mgbx4cd0ab xn--mix891f xn--mk1bu44c xn--mxtq1m xn--ngbc5azd '
    'xn--ngbe9e0a xn--ngbrx xn--node xn--nqv7f xn--nqv7fs00ema xn--nyqy26a xn--o3cw4h xn--ogbpf8fl '
    'xn--otu796d xn--p1acf xn--p1ai xn--pgbs0dh xn--pssy2u xn--q7ce6a xn--q9jyb4c xn--qcka1pmc xn--qxa6a '
    'xn--qxam xn--rhqv96g xn--rovu88b xn--rvc1e0am3e xn--s9brj9c xn--ses554g xn--t60b56a xn--tckwe '
    'xn--tiq49xqyj xn--unup4y xn--vermgensberater-ctb xn--vermgensberatung-pwb xn--vhquv xn--vuq861b '
    'xn--w4r85el8fhu5dnra xn--w4rs40l xn--wgbh1c xn--wgbl6a xn--xhq521b xn--xkc2al3hye2a xn--xkc2dl3a5ee0h '
    'xn--y9a3aq xn--yfro4i67o xn--ygbi2ammx xn--zfr164b xxx xyz yachts yahoo yamaxun yandex ye yodobashi '
    'yoga yokohama you youtube yt yun za zappos zara zero zip zm zone zuerich zw \u03B5\u03BB \u03B5\u03C5 '
    '\u0431\u0433 \u0431\u0435\u043B \u0434\u0435\u0442\u0438 \u0435\u044E '
    '\u043A\u0430\u0442\u043E\u043B\u0438\u043A \u043A\u043E\u043C \u043C\u043A\u0434 \u043C\u043E\u043D '
    '\u043C\u043E\u0441\u043A\u0432\u0430 \u043E\u043D\u043B\u0430\u0439\u043D \u043E\u0440\u0433 '
    '\u0440\u0443\u0441 \u0440\u0444 \u0441\u0430\u0439\u0442 \u0441\u0440\u0431 \u0443\u043A\u0440 '
    '\u049B\u0430\u0437 \u0570\u0561\u0575 \u05D9\u05E9\u05E8\u05D0\u05DC \u05E7\u05D5\u05DD '
    '\u0627\u0628\u0648\u0638\u0628\u064A \u0627\u062A\u0635\u0627\u0644\u0627\u062A '
    '\u0627\u0631\u0627\u0645\u0643\u0648 \u0627\u0644\u0627\u0631\u062F\u0646 '
    '\u0627\u0644\u0628\u062D\u0631\u064A\u0646 \u0627\u0644\u062C\u0632\u0627\u0626\u0631 '
    '\u0627\u0644\u0633\u0639\u0648\u062F\u064A\u0629 \u0627\u0644\u0639\u0644\u064A\u0627\u0646 '
    '\u0627\u0644\u0645\u063A\u0631\u0628 \u0627\u0645\u0627\u0631\u0627\u062A '
    '\u0627\u06CC\u0631\u0627\u0646 \u0628\u0627\u0631\u062A \u0628\u0627\u0632\u0627\u0631 '
    '\u0628\u064A\u062A\u0643 \u0628\u06BE\u0627\u0631\u062A \u062A\u0648\u0646\u0633 '
    '\u0633\u0648\u062F\u0627\u0646 \u0633\u0648\u0631\u064A\u0629 \u0634\u0628\u0643\u0629 '
    '\u0639\u0631\u0627\u0642 \u0639\u0631\u0628 \u0639\u0645\u0627\u0646 '
    '\u0641\u0644\u0633\u0637\u064A\u0646 \u0642\u0637\u0631 \u0643\u0627\u062B\u0648\u0644\u064A\u0643 '
    '\u0643\u0648\u0645 \u0645\u0635\u0631 \u0645\u0644\u064A\u0633\u064A\u0627 '
    '\u0645\u0648\u0631\u064A\u062A\u0627\u0646\u064A\u0627 \u0645\u0648\u0642\u0639 '
    '\u0647\u0645\u0631\u0627\u0647 \u067E\u0627\u06A9\u0633\u062A\u0627\u0646 \u0680\u0627\u0631\u062A '
    '\u0915\u0949\u092E \u0928\u0947\u091F \u092D\u093E\u0930\u0924 \u092D\u093E\u0930\u0924\u092E\u094D '
    '\u092D\u093E\u0930\u094B\u0924 \u0938\u0902\u0917\u0920\u0928 \u09AC\u09BE\u0982\u09B2\u09BE '
    '\u09AD\u09BE\u09B0\u09A4 \u09AD\u09BE\u09F0\u09A4 \u0A2D\u0A3E\u0A30\u0A24 \u0AAD\u0ABE\u0AB0\u0AA4 '
    '\u0B2D\u0B3E\u0B30\u0B24 \u0B87\u0BA8\u0BCD\u0BA4\u0BBF\u0BAF\u0BBE '
    '\u0B87\u0BB2\u0B99\u0BCD\u0B95\u0BC8 \u0B9A\u0BBF\u0B99\u0BCD\u0B95\u0BAA\u0BCD\u0BAA\u0BC2\u0BB0\u0BCD '
    '\u0C2D\u0C3E\u0C30\u0C24\u0C4D \u0CAD\u0CBE\u0CB0\u0CA4 \u0D2D\u0D3E\u0D30\u0D24\u0D02 '
    '\u0DBD\u0D82\u0D9A\u0DCF \u0E04\u0E2D\u0E21 \u0E44\u0E17\u0E22 \u0EA5\u0EB2\u0EA7 \u10D2\u10D4 '
    '\u307F\u3093\u306A \u30A2\u30DE\u30BE\u30F3 \u30AF\u30E9\u30A6\u30C9 \u30B0\u30FC\u30B0\u30EB '
    '\u30B3\u30E0 \u30B9\u30C8\u30A2 \u30BB\u30FC\u30EB \u30D5\u30A1\u30C3\u30B7\u30E7\u30F3 '
    '\u30DD\u30A4\u30F3\u30C8 \u4E16\u754C \u4E2D\u4FE1 \u4E2D\u56FD \u4E2D\u570B \u4E2D\u6587\u7F51 '
    '\u4E9A\u9A6C\u900A \u4F01\u4E1A \u4F5B\u5C71 \u4FE1\u606F \u5065\u5EB7 \u516B\u5366 \u516C\u53F8 '
    '\u516C\u76CA \u53F0\u6E7E \u53F0\u7063 \u5546\u57CE \u5546\u5E97 \u5546\u6807 \u5609\u91CC '
    '\u5609\u91CC\u5927\u9152\u5E97 \u5728\u7EBF \u5927\u62FF \u5929\u4E3B\u6559 \u5A31\u4E50 \u5BB6\u96FB '
    '\u5E7F\u4E1C \u5FAE\u535A \u6148\u5584 \u6211\u7231\u4F60 \u624B\u673A \u62DB\u8058 \u653F\u52A1 '
    '\u653F\u5E9C \u65B0\u52A0\u5761 \u65B0\u95FB \u65F6\u5C1A \u66F8\u7C4D \u673A\u6784 \u6DE1\u9A6C\u9521 '
    '\u6E38\u620F \u6FB3\u9580 \u70B9\u770B \u79FB\u52A8 \u7EC4\u7EC7\u673A\u6784 \u7F51\u5740 \u7F51\u5E97 '
    '\u7F51\u7AD9 \u7F51\u7EDC \u8054\u901A \u8C37\u6B4C \u8D2D\u7269 \u901A\u8CA9 \u96C6\u56E2 '
    '\u96FB\u8A0A\u76C8\u79D1 \u98DE\u5229\u6D66 \u98DF\u54C1 \u9910\u5385 \u9999\u683C\u91CC\u62C9 '
    '\u9999\u6E2F \uB2F7\uB137 \uB2F7\uCEF4 \uC0BC\uC131 \uD55C\uAD6D';
