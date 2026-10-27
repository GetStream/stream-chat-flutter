import 'package:flutter_test/flutter_test.dart';

import 'support/step.dart';
import 'support/stream_test_case.dart';
import 'support/stream_test_env.dart';

// Each scenario connects with a token the mock server hands out (valid for 5 s),
// so the SDK has to refresh it as the backend robot breaks it.
void main() {
  Future<void> login(StreamTestEnv env) async {
    await env.userRobot.login();
    await env.assertConnected();
  }

  streamTestWithEnv(
    allureId: '12666',
    description: 'token invalidates before the user logs in',
    skip: 'https://linear.app/stream/issue/FLU-1084',
    jwt: true,
    body: (env) async {
      step('GIVEN the token is invalid');
      await env.backendRobot.invalidateToken();

      step('WHEN the user tries to log in');
      await env.userRobot.login();

      step('THEN the app requests a token refresh');
      await env.assertConnected();
    },
  );

  streamTestWithEnv(
    allureId: '12667',
    description: 'token invalidates after the user logs in',
    skip: 'https://linear.app/stream/issue/FLU-1084',
    jwt: true,
    body: (env) async {
      step('GIVEN the user logs in');
      await login(env);

      step('WHEN the token invalidates');
      await env.backendRobot.invalidateToken();

      step('THEN the app requests a token refresh');
      await env.assertTokenHasExpired();
      await env.assertConnected();
    },
  );

  streamTestWithEnv(
    allureId: '12668',
    description: 'token date invalidates before the user logs in',
    jwt: true,
    body: (env) async {
      step('GIVEN the token date is invalid');
      await env.backendRobot.invalidateTokenDate();

      step('WHEN the user tries to log in');
      await env.userRobot.login();

      step('THEN the login fails without requesting another token');
      await env.userRobot.assertLoginFailed(code: 42);
      expect(env.tokenRequests, 1);
    },
  );

  streamTestWithEnv(
    allureId: '12669',
    description: 'token date invalidates after the user logs in',
    skip: 'https://github.com/GetStream/stream-chat-test-mock-server/pull/95',
    jwt: true,
    body: (env) async {
      step('GIVEN the user logs in');
      await login(env);

      step('WHEN the token date invalidates');
      // Long enough for the next refresh to fall inside it.
      await env.backendRobot.invalidateTokenDate(duration: 10);

      step('THEN the app reconnects with the same token once its date is valid');
      await env.assertTokenHasExpired();
      await env.assertConnected();
      expect(env.tokenRequests, 2);
    },
  );

  streamTestWithEnv(
    allureId: '12670',
    description: 'token signature invalidates before the user logs in',
    jwt: true,
    body: (env) async {
      step('GIVEN the token signature is invalid');
      await env.backendRobot.invalidateTokenSignature();

      step('WHEN the user tries to log in');
      await env.userRobot.login();

      step('THEN the login fails without requesting another token');
      await env.userRobot.assertLoginFailed(code: 43);
      expect(env.tokenRequests, 1);
    },
  );

  streamTestWithEnv(
    allureId: '12671',
    description: 'token signature invalidates after the user logs in',
    jwt: true,
    body: (env) async {
      step('GIVEN the user logs in');
      await login(env);

      step('WHEN the token signature invalidates');
      // Long enough for the next refresh to fall inside it.
      await env.backendRobot.invalidateTokenSignature(duration: 10);

      step('THEN the app gives up without requesting another token');
      await env.assertTokenHasExpired();
      // The reconnect attempts back off for up to about 45 seconds.
      await env.assertDisconnected(timeout: const Duration(seconds: 90));
      expect(env.tokenRequests, 2);
    },
  );

  streamTestWithEnv(
    allureId: '12672',
    description: 'token expires before the user logs in',
    jwt: true,
    body: (env) async {
      step('GIVEN the token expires');
      await env.backendRobot.revokeToken();

      step('WHEN the user tries to log in');
      await env.userRobot.login();

      step('THEN the app requests a token refresh');
      await env.assertConnected();
    },
  );

  streamTestWithEnv(
    allureId: '12673',
    description: 'token expires after the user logs in',
    jwt: true,
    body: (env) async {
      step('GIVEN the user logs in');
      await login(env);

      step('WHEN the token expires');
      // Nothing to do: the mock server's token is only valid for 5 seconds.

      step('THEN the app requests a token refresh');
      await env.assertTokenHasExpired();
      await env.assertConnected();
    },
  );

  streamTestWithEnv(
    allureId: '12674',
    description: 'token expires while the user is in the background',
    jwt: true,
    body: (env) async {
      step('GIVEN the user logs in');
      await login(env);

      step('AND the user goes to the background');
      await env.moveToBackground();

      step('AND the token expires');
      // Not pumped: frames are disabled while backgrounded.
      await Future<void>.delayed(const Duration(seconds: 6));

      step('WHEN the user comes back to the foreground');
      await env.moveToForeground();

      step('THEN the app requests a token refresh');
      await env.assertTokenHasExpired();
      await env.assertConnected();
    },
  );

  streamTestWithEnv(
    allureId: '12675',
    description: 'token expires while the user is offline',
    jwt: true,
    body: (env) async {
      step('GIVEN the user logs in');
      await login(env);

      step('AND the user goes offline');
      await env.goOffline();

      step('WHEN the token expires');
      await env.waitForTokenToExpire();

      step('AND the user comes back online');
      await env.goOnline();

      step('THEN the app requests a token refresh');
      await env.assertTokenHasExpired();
      await env.assertConnected();
    },
  );

  streamTestWithEnv(
    allureId: '12676',
    description: 'token generation fails',
    jwt: true,
    body: (env) async {
      step('GIVEN the user logs in');
      await login(env);

      step('AND JWT generation breaks on the server side');
      await env.backendRobot.breakTokenGeneration();

      step('WHEN the app tries to refresh the token');
      await env.assertTokenHasExpired();

      step('THEN the app refreshes the token once JWT generation recovers');
      await env.assertConnected();
    },
  );
}
