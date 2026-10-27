# e2e_app

The Stream Chat Flutter app the e2e suite drives against the Stream Chat mock
server. It keeps to the screens the suite exercises and adds test-only actions
the sample app would not ship.

## Running the suite

From `e2e_app/`:

```sh
bundle install
bundle exec fastlane run_e2e_test device:<device id>
```

`run_e2e_test` starts the mock server, runs `integration_test/` and stops the
server. To run the tests yourself, start the server with
`bundle exec fastlane start_mock_server`, then run `melos run e2e:run`.

The tests live in `integration_test/`, and the harness they share is in
`integration_test/support/`.
