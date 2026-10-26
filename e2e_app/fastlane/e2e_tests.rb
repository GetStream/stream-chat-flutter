# frozen_string_literal: true

# Lists the e2e tests by reading the `streamTest`/`streamTestWithEnv` calls in
# `integration_test/*_test.dart`, so the lanes can select, batch and filter them
# by name without a device.
#
# A test's id is `<test file>/<description>`, the `Class/test` shape the coverage
# map and select_impacted_tests use, with the file standing in for the class.
module E2ETests
  TEST_CALL = /\bstreamTest(?:WithEnv)?\(/
  DESCRIPTION = /^\s*description:\s*'((?:[^'\\]|\\.)*)',\s*$/
  SKIP = /^\s*skip:/
  SKIP_PLATFORMS = /^\s*skipPlatforms:\s*\{([^}]*)\}/
  BODY = /^\s*body:/

  class << self
    # Every test id in `dir`, in file order, minus the tests skipped on `platform`
    # (`android` or `ios`). Without a platform only tests skipped everywhere are
    # left out, as a test skipped on one platform still runs on the other.
    def list(dir, platform: nil)
      Dir["#{dir}/*_test.dart"].sort.flat_map { |file| tests_in(file, platform) }
    end

    # The test file of an id, as `run_e2e_test` targets it.
    def file(id, dir)
      "#{dir}/#{id.split('/', 2).first}.dart"
    end

    # The description of an id, which is what `flutter test --name` matches.
    def name(id)
      id.split('/', 2).last
    end

    private

    def tests_in(file, platform)
      prefix = File.basename(file, '.dart')
      tests = []
      current = nil
      File.foreach(file) do |line|
        if (description = line[DESCRIPTION, 1])
          current = { name: description.gsub(/\\(.)/, '\1'), skip: false, platforms: nil }
        elsif current && line.match?(SKIP)
          current[:skip] = true
        elsif current && (platforms = line[SKIP_PLATFORMS, 1])
          current[:platforms] = platforms.scan(/E2ePlatform\.(\w+)/).flatten
        elsif current && line.match?(BODY)
          tests << current
          current = nil
        end
      end

      # A description this parser cannot read (e.g. split over lines) would drop the
      # test silently, so the count has to match the test calls in the file.
      calls = File.read(file).scan(TEST_CALL).size
      raise "#{file}: found #{tests.size} test descriptions for #{calls} test calls" unless tests.size == calls

      tests.reject { |test| skipped?(test, platform) }.map { |test| "#{prefix}/#{test[:name]}" }
    end

    def skipped?(test, platform)
      return false unless test[:skip]
      return true if test[:platforms].nil?

      !platform.nil? && test[:platforms].include?(platform)
    end
  end
end
