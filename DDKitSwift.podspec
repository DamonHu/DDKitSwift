Pod::Spec.new do |s|
s.name = 'DDKitSwift'
s.swift_version = '5.0'
s.version = '3.0.3'
s.license= { :type => "MIT", :file => "LICENSE" }
s.summary = 'DDKitSwift is the supporting framework of ZXKitSwift, for ZXKitSwift plugin developers'
s.homepage = 'https://github.com/DamonHu/DDKitSwift'
s.authors = { 'DDKitSwift' => 'dong765@qq.com' }
s.source = { :git => "https://github.com/DamonHu/DDKitSwift.git", :tag => s.version}
s.requires_arc = true
s.ios.deployment_target = '12.0'
s.subspec 'core' do |cs|
    cs.resource_bundles = {
        'DDKitSwift' => ['pod/assets/**/*']
    }
    cs.source_files = "pod/*.swift", "pod/**/*.swift"
    cs.dependency 'DDUtils/ui', '~> 5.0.0'
    cs.dependency 'DDUtils/utils', '~> 5.0.0'
    cs.dependency 'DDLoggerSwift', '~> 5.0.0'
end
s.default_subspec = "core"
s.documentation_url = 'https://ddceo.com/blog/1306.html'
end
