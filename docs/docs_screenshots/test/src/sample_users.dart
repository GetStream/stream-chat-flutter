import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Sample users sourced from Stream's Chat SDK Design System (Figma node
/// `2867:55922`, "User Photo"). Each [User]'s `id` matches the Figma
/// component slug; `image` points at the matching fixture in
/// `test/fixtures/avatars/<slug>.png`.
///
/// Use these constants in test data instead of constructing `User(...)`
/// inline. Adding a new user is two lines:
///   1. Drop `<slug>.png` into `test/fixtures/avatars/`.
///   2. Add the slug to `_avatarSlugs` in `golden_network_image.dart`, then
///      add a new constant + entry to [sampleUsers] here.

User _user(String slug, String name) => User(
  id: slug,
  name: name,
  image: 'https://docs.fixture/avatar/$slug.png',
);

final ameliaMoore = _user('amelia-moore', 'Amelia Moore');
final charlotteAnderson = _user('charlotte-anderson', 'Charlotte Anderson');
final elenaBarros = _user('elena-barros', 'Elena Barros');
final elisaRamirez = _user('elisa-ramirez', 'Elisa Ramírez');
final ethanWilson = _user('ethan-wilson', 'Ethan Wilson');
final jamesGarcia = _user('james-garcia', 'James Garcia');
final jasonThompson = _user('jason-thompson', 'Jason Thompson');
final liamJohnson = _user('liam-johnson', 'Liam Johnson');
final linaPark = _user('lina-park', 'Lina Park');
final mateoAlvarez = _user('mateo-alvarez', 'Mateo Alvarez');
final mayaRoss = _user('maya-ross', 'Maya Ross');
final miaThompson = _user('mia-thompson', 'Mia Thompson');
final noahSmith = _user('noah-smith', 'Noah Smith');
final oliverSchmidt = _user('oliver-schmidt', 'Oliver Schmidt');
final omarJackson = _user('omar-jackson', 'Omar Jackson');
final sophiaLee = _user('sophia-lee', 'Sophia Lee');
final sophieLaurent = _user('sophie-laurent', 'Sophie Laurent');
final wesleyLau = _user('wesley-lau', 'Wesley Lau');

/// The signed-in user across every doc snapshot. Always an [OwnUser] so it
/// drops straight into `currentUser` stubs, and because [OwnUser] is a
/// [User] it also works anywhere a [User] is expected — message authors,
/// `Member.user`, etc. Pinning a single identity keeps "You" labels,
/// my-side message bubbles, and the messenger header consistent across
/// every snapshot.
final ownUser = OwnUser(
  id: ameliaMoore.id,
  name: ameliaMoore.name,
  image: ameliaMoore.image,
);

/// All sample users in the order they appear on the Figma canvas.
final sampleUsers = <User>[
  ameliaMoore,
  charlotteAnderson,
  elenaBarros,
  elisaRamirez,
  ethanWilson,
  jamesGarcia,
  jasonThompson,
  liamJohnson,
  linaPark,
  mateoAlvarez,
  mayaRoss,
  miaThompson,
  noahSmith,
  oliverSchmidt,
  omarJackson,
  sophiaLee,
  sophieLaurent,
  wesleyLau,
];
