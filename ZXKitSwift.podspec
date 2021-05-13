Pod::Spec.new do |s|
s.name = 'ZXKitSwift'
s.swift_version = '5.0'
s.version = '0.0.6'
s.license= { :type => "Apache-2.0 License", :file => "LICENSE" }
s.summary = 'ZXKitSwift'
s.homepage = 'https://github.com/ZXKitCode/ZXKitSwift'
s.authors = { 'ZXKitCode' => 'dong765@qq.com' }
s.source = { :git => "https://github.com/ZXKitCode/ZXKitSwift.git", :tag => s.version}
s.requires_arc = true
s.ios.deployment_target = '11.0'
s.source_files = "pod/*.swift"
s.dependency 'ZXKitCore'
s.dependency 'ZXKitLogger/zxkit'
s.dependency 'ZXKitFPS/zxkit'
s.dependency 'HDPingTools/zxkit'
s.dependency 'ZXFileBrowser/zxkit'
s.documentation_url = 'http://blog.hudongdong.com/swift/1079.html'
end
