import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// The Stream app the sample app connects to.
///
/// Defaults to Stream's public demo app. Point the sample app at another
/// Stream app — a staging environment, or your own — at launch:
/// `--dart-define=STREAM_API_KEY=<key>`.
///
/// [defaultUsers] are signed for the demo app only, so a different key also
/// needs a user supplied through the "Advanced Options" login screen.
const kDefaultStreamApiKey = String.fromEnvironment(
  'STREAM_API_KEY',
  defaultValue: 'kv7mcsxr24p8',
);

/// Default base URL for the Stream API:
/// `--dart-define=STREAM_BASE_URL=https://chat-edge-us-east1-ce1.gcp.stream-io-api.com`.
///
/// Empty — the default — uses the SDK's own endpoint. The WebSocket URL is
/// derived from this, so only the HTTP base URL needs to be supplied.
///
/// This is only the starting value: the "Advanced Options" login screen can
/// set it at runtime, which is what already-built deployments (the web demo)
/// have to use.
const kStreamBaseUrl = String.fromEnvironment('STREAM_BASE_URL');

/// Name of the server-side predefined filter backing the channel list.
///
/// Predefined filters are saved queries that live on the Stream app, so this
/// one exists only on the demo app. It is skipped automatically whenever a
/// custom API key or base URL is in use — see
/// [AuthController.usingCustomBackend] — falling back to a plain "channels I
/// am a member of" filter.
const kChannelListPredefinedFilter = 'stream_chat_flutter_sample_app';

/// The demo accounts, keyed by their (pre-generated) user token.
///
/// Each carries a [User.language] roughly matching its name, so signing in as
/// different users demonstrates message translation: the backend only
/// auto-translates for users that have a language set, and the UI renders the
/// translation for the current user's language.
final defaultUsers = <String, User>{
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoic2FsdmF0b3JlIn0.pgiJz7sIc7iP29BHKFwe3nLm5-OaR_1l2P-SlgiC9a8':
      User(
        id: 'salvatore',
        language: 'it',
        extraData: const {
          'name': 'Salvatore Giordano',
          'image':
              'https://avatars.githubusercontent.com/u/20601437?s=460&u=3f66c22a7483980624804054ae7f357cf102c784&v=4',
        },
      ),
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoic2FoaWwifQ.WnIUoB5gR2kcAsFhiDvkiD6zdHXZ-VSU2aQWWkhsvfo': User(
    id: 'sahil',
    language: 'hi',
    extraData: const {
      'name': 'Sahil Kumar',
      'image': 'https://avatars.githubusercontent.com/u/25670178?s=400&u=30ded3784d8d2310c5748f263fd5e6433c119aa1&v=4',
    },
  ),
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiYmVuIn0.nAz2sNFGQwY7rl2Og2z3TGHUsdpnN53tOsUglJFvLmg': User(
    id: 'ben',
    language: 'en',
    extraData: const {
      'name': 'Ben Golden',
      'image': 'https://avatars.githubusercontent.com/u/1581974?s=400&v=4',
    },
  ),
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoidGhpZXJyeSJ9.lEq6TrZtHzjoNtf7HHRufUPyGo_pa8vg4_XhEBp4ckY': User(
    id: 'thierry',
    language: 'nl',
    extraData: const {
      'name': 'Thierry Schellenbach',
      'image': 'https://avatars.githubusercontent.com/u/265409?s=400&u=2d0e3bb1820db992066196bff7b004f0eee8e28d&v=4',
    },
  ),
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoidG9tbWFzbyJ9.GLSI0ESshERMo2WjUpysD709NEtn1zmGimUN2an7g9o': User(
    id: 'tommaso',
    language: 'it',
    extraData: const {
      'name': 'Tommaso Barbugli',
      'image': 'https://avatars.githubusercontent.com/u/88735?s=400&v=4',
    },
  ),
  // 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiZGV2ZW4ifQ.z3zI4PqJnNhc-1o-VKcmb6BnnQ0oxFNCRHwEulHqcWc': User(
  //   id: 'deven',
  //   extraData: const {
  //     'name': 'Deven Joshi',
  //     'image': 'https://avatars.githubusercontent.com/u/26357843?s=400&u=0c61d890866e67bf69f58878be58915e9bfd39ee&v=4',
  //   },
  // ),
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoibmVldmFzaCJ9.3EdHegTxibrz3A9cTiKmpEyawwcCVB8FXnoFzr4eKvw': User(
    id: 'neevash',
    language: 'en',
    extraData: const {
      'name': 'Neevash Ramdial',
      'image': 'https://avatars.githubusercontent.com/u/25674767?s=400&u=1d7333baf7dd9d143db8bfcdb31a838b89cfff9c&v=4',
    },
  ),
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoicWF0ZXN0MSJ9.fnelU7HcP7QoEEsCGteNlF1fppofzNlrnpDQuIgeKCU': User(
    id: 'qatest1',
    language: 'es',
    extraData: const {
      'name': 'QA test 1',
    },
  ),
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoicWF0ZXN0MiJ9.vSCqAEbs2WVmMWsOsa7065Fsjq-rsTih6qsHPynl7XM': User(
    id: 'qatest2',
    language: 'ja',
    extraData: const {
      'name': 'QA test 2',
    },
  ),
};
