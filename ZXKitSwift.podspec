Pod::Spec.new do |s|
s.name = 'ZXKitSwift'
s.swift_version = '5.0'
s.version = '1.0.0'
s.license= { :type => "MIT", :file => "LICENSE" }
s.summary = 'ZXKitSwift'
s.homepage = 'https://github.com/DamonHu/ZXKitSwift'
s.authors = { 'ZXKitCode' => 'dong765@qq.com' }
s.source = { :git => "https://github.com/DamonHu/ZXKitSwift.git", :tag => s.version}
s.requires_arc = true
s.ios.deployment_target = '11.0'
s.source_files = "pod/*.swift"
s.dependency 'ZXKitCore'
s.dependency 'ZXKitLogger/zxkit'
s.dependency 'ZXKitFPS/zxkit'
s.dependency 'HDPingTools/zxkit'
s.dependency 'ZXFileBrowser/zxkit'
s.dependency 'ZXUserDefaultManager/zxkit'
s.dependency 'netfox-zxkit'
s.documentation_url = 'https://blog.hudongdong.com/ios/1164.html'
end
