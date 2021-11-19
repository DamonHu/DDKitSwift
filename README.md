# ZXKitSwift

![](./readmeResource/zxkit.png)

[中文文档](./README_zh.md)

`ZXKitSwift` is a collection of debugging tools for iOS platform. If you want to continue integrating other [ZXKitCore](https://github.com/ZXKitCode/core) Plugins, please check the development documentation of `ZXKitCore`.

## Integrate ZXKit

1、 cocoapods

```ruby
pod 'ZXKitSwift'
```

## Use ZXKit

2、 Import the header file

```swift
import ZXKitSwift
```

3、Register all built-in plug-ins

```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
	
	//Register all built-in plug-ins
	ZXKit.registPlugin()
	
	return true
}
```

4、Display the list of tools

```swift
ZXKit.show()
```

5、hide the list of tools

```swift
ZXKit.hide()
```

6、close ZXKit

```swift
ZXKit.close()
```

## Zxkitswift built-in plug-in function

![](./readmeResource/zxkitSwift_en.jpg)

- [x] log ☞ [ZXKitCode/logger](https://github.com/ZXKitCode/logger)
- [x] network ping test  ☞ [DamonHu/HDPingTools](https://github.com/DamonHu/HDPingTools)
- [x] FPS display ☞ [ZXKitCode/FPS](https://github.com/ZXKitCode/FPS)
- [x] Sandbox FileBrowser ☞ [ZXKitCode/ZXFileBrowser](https://github.com/ZXKitCode/ZXFileBrowser)
- [x] UserDefault data manager ☞ [ZXKitCode/ZXUserDefaultManager](https://github.com/ZXKitCode/ZXUserDefaultManager)
- [x] network record ☞ [ZXKitCode/netfox-zxkit](https://github.com/ZXKitCode/netfox-zxkit)


## preview

![](./readmeResource/preview.gif)


## License

![](https://camo.githubusercontent.com/eb9066a6d8e0950066f3757c420e3a607c0929583b48ebda6fd9a6f50ccfc8f1/68747470733a2f2f7777772e6170616368652e6f72672f696d672f41534632307468416e6e69766572736172792e6a7067)

Base on Apache-2.0 License