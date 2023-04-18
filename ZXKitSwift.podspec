Pod::Spec.new do |s|
s.name = 'ZXKitSwift'
s.swift_version = '5.0'
s.version = '2.0.0'
s.license= { :type => "MIT", :file => "LICENSE" }
s.summary = 'ZXKitSwift'
s.homepage = 'https://zxkit.com'
s.authors = { 'ZXKitCode' => 'dong765@qq.com' }
s.source = { :git => "https://github.com/DamonHu/ZXKitSwift.git", :tag => s.version}
s.requires_arc = true
s.ios.deployment_target = '11.0'
s.source_files = "pod/*.swift"
s.dependency 'ZXKitCore', '~> 2.0'
s.dependency 'fps-zxkit', '~> 2.0'
s.dependency 'ping-zxkit', '~> 2.0'
s.dependency 'fileBrowser-zxkit', '~> 2.0'
s.dependency 'userDefaultManager-zxkit', '~> 2.0'
s.dependency 'netfox-zxkit', '~> 2.0'
s.documentation_url = 'https://zxkit.com'
end
