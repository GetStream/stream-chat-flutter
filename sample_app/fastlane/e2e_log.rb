# frozen_string_literal: true

require 'base64'

# Reads what actually happened out of a `flutter test` log, and turns the test
# names it finds back into a `--name` filter for re-running them.
#
# Pure functions over the log text, with no fastlane API in reach, so they can be
# exercised with plain `ruby` against a captured log instead of a full e2e run.
module E2ELog
  # Emitted once per test by the Dart reporter's `stopTest`, so its presence is
  # the proof that a test actually ran.
  RESULT_MARKER = %r{E2E-TEST::(passed|failed|broken|skipped)::([A-Za-z0-9+/=]+)}

  # One line per test the runner accounted for, printed by the `github` reporter
  # (grouped when the test produced output, bare when it did not). `❎ (skipped)`
  # is deliberately not matched — a skipped body never runs, so it owes no result.
  REPORTED_TEST = /^(?:::group::)?[✅❌] (.+)$/

  # package:test's own wording when a test leaks async work that throws after the
  # body has already finished. Comes from the framework rather than the reporter,
  # so it shows up under both `github` (CI) and `expanded` (local).
  POST_COMPLETION = 'This test failed after it had already completed'

  # What the runner appends to the name of the test it pinned such an error on.
  POST_COMPLETION_SUFFIX = ' (failed after test completion)'

  class << self
    # The tests that reported a failure — what a retry should narrow to.
    def failed_test_names(log)
      results(log).select { |status, _| %w[failed broken].include?(status) }.map(&:last).uniq
    end

    # Tests the runner reported but which never emitted a result, i.e. never
    # actually ran: the shape of a run whose device dies midway and turns the
    # remaining tests into instant passes with no output.
    #
    # `github` reporter only — `expanded` prints no per-test glyph, so there is
    # nothing to compare against and this returns [] rather than crying wolf.
    def phantom_test_names(log)
      accounted = read(log).scan(REPORTED_TEST).flatten
                           .map { |name| name.delete_suffix(POST_COMPLETION_SUFFIX).strip }.uniq
      return [] if accounted.empty?

      # Sets, not counts: a post-completion failure prints the same name twice and
      # a cumulative log holds every attempt's names.
      accounted - results(log).map(&:last).uniq
    end

    # A leaked async error fails the run but is NOT attributable to a test.
    def post_completion_failure?(log)
      read(log).include?(POST_COMPLETION)
    end

    # The test the runner pinned the leaked error on. Triage only — the
    # attribution is unreliable, since the error escaped from whichever test
    # leaked the work, not necessarily this one.
    def post_completion_blamed_tests(log)
      read(log).scan(/❌ (.+?)#{Regexp.escape(POST_COMPLETION_SUFFIX)}/).flatten.uniq
    end

    # A single Dart-regex alternation matching any of `names`, for one
    # `flutter test --name`. Multiple `--name` flags are ANDed together, so an
    # alternation is the only way to OR them; each name is escaped so the test
    # descriptions match literally.
    def name_alternation(names)
      escaped = names.map { |name| name.gsub(%r{[.*+?^${}()|\[\]\\/]}) { |char| "\\#{char}" } }
      "(#{escaped.join('|')})"
    end

    private

    # [[status, name], ...] for every test that reported a result.
    def results(log)
      read(log).scan(RESULT_MARKER).map do |status, name_b64|
        [status, Base64.decode64(name_b64).force_encoding('UTF-8')]
      end
    end

    # Missing log => no results rather than an exception; the caller is usually
    # already handling a failure and should not trip over a second one.
    def read(log)
      return '' unless File.exist?(log)

      File.read(log).gsub(/\e\[[0-9;]*m/, '')
    end
  end
end
