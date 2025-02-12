# Install pods needed to embed Flutter application, Flutter engine, and plugins
def flutter_install_all_ios_pods(flutter_application_path = nil)
  flutter_application_path ||= File.expand_path('..', __dir__)
  load File.join(flutter_application_path, 'ios', 'Flutter', 'podhelper.rb')
end

# Install pods needed to embed Flutter application, Flutter engine, and plugins
def flutter_install_ios_engine_pod(flutter_application_path)
  engine_dir = File.expand_path(File.join(flutter_application_path, 'engine'))
  framework_dir = File.expand_path(File.join(engine_dir, 'Flutter.xcframework'))
  pod 'Flutter', :path => framework_dir
end

def flutter_install_ios_plugin_pods(flutter_application_path)
  flutter_application_path ||= File.expand_path('..', __dir__)
  load File.join(flutter_application_path, 'ios', 'Flutter', 'podhelper.rb')
end

def flutter_install_all_ios_pods(flutter_application_path = nil)
  flutter_application_path ||= File.expand_path('..', __dir__)
  load File.join(flutter_application_path, 'ios', 'Flutter', 'podhelper.rb')
end
