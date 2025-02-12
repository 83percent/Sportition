platform :ios, '13.0'

def flutter_install_all_ios_pods(flutter_application_path = nil)
  flutter_application_path ||= File.expand_path('..', __dir__)
  load File.join(flutter_application_path, '.ios', 'podhelper.rb')
end

# Install pods needed to embed Flutter application, Flutter engine, and plugins
def flutter_install_ios_engine_pod(flutter_application_path)
  engine_dir = File.expand_path(File.join(flutter_application_path, 'engine'))
  framework_dir = File.expand_path(File.join(engine_dir, 'Flutter.xcframework'))
  pod 'Flutter', :path => framework_dir
end

def flutter_install_ios_plugin_pods(flutter_application_path)
  flutter_application_path ||= File.expand_path('..', __dir__)
  load File.join(flutter_application_path, '.ios', 'podhelper.rb')
end

target 'Runner' do
  use_frameworks!
  use_modular_headers!

  # Pods for Runner
  pod 'Firebase/Core', '10.29.0'
  pod 'Firebase/Auth', '10.29.0'
  pod 'Firebase/Analytics', '10.29.0'
  # pod 'FirebaseAppDistribution', '2.0'
  pod 'GoogleDataTransport'

  pod 'FirebaseFirestore',
    :git => 'https://github.com/invertase/firestore-ios-sdk-frameworks.git',
    :tag => '10.29.0'

  flutter_install_all_ios_pods File.dirname(File.realpath(__FILE__))
  target 'RunnerTests' do
    inherit! :search_paths
  end
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'arm64'
    end
  end
end
