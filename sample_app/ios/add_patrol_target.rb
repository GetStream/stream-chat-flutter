require 'xcodeproj'

project_path = 'Runner.xcodeproj'
project = Xcodeproj::Project.open(project_path)

if project.targets.any? { |t| t.name == 'RunnerUITests' }
  puts 'RunnerUITests target already exists; nothing to do.'
  exit 0
end

runner = project.targets.find { |t| t.name == 'Runner' }
raise 'Runner target not found' unless runner

deployment_target = runner.build_configurations.first
  .build_settings['IPHONEOS_DEPLOYMENT_TARGET'] || '15.0'

test_target = project.new_target(
  :ui_test_bundle, 'RunnerUITests', :ios, deployment_target, nil, :objc
)

# Path is relative to the project dir (ios/).
group = project.main_group.find_subpath('RunnerUITests', true)
group.set_source_tree('SOURCE_ROOT')
file_ref = group.new_reference('RunnerUITests/RunnerUITests.m')
test_target.add_file_references([file_ref])

test_target.add_dependency(runner)

test_target.build_configurations.each do |config|
  s = config.build_settings
  s['PRODUCT_BUNDLE_IDENTIFIER'] = 'io.getstream.flutter.RunnerUITests'
  s['TEST_TARGET_NAME'] = 'Runner'
  s['IPHONEOS_DEPLOYMENT_TARGET'] = deployment_target
  s['CODE_SIGN_STYLE'] = 'Automatic'
  s['CLANG_ENABLE_MODULES'] = 'YES'
  s['SWIFT_VERSION'] = '5.0'
  s['ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES'] = 'YES'
  # Auto-synthesize Info.plist (UI test bundles need one; without this the
  # xcodebuild step fails with code 65).
  s['GENERATE_INFOPLIST_FILE'] = 'YES'
  # Without an explicit product name the .xctest bundle is built nameless,
  # which collides as "Multiple commands produce .../PlugIns/.xctest".
  s['PRODUCT_NAME'] = '$(TARGET_NAME)'
end

project.save

# Wire the test target into the shared Runner scheme's Test action so
# `patrol`/xcodebuild discovers it.
scheme_path = File.join(
  Xcodeproj::XCScheme.shared_data_dir(project_path), 'Runner.xcscheme'
)
scheme = Xcodeproj::XCScheme.new(scheme_path)
scheme.add_test_target(test_target)
scheme.save_as(project_path, 'Runner', true)

puts "Added RunnerUITests target (bundle id io.getstream.flutter.RunnerUITests, "\
     "deployment #{deployment_target}) and wired it into the Runner scheme."
