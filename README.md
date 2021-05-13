# ZXKit

![](./readmeResource/zxkit.png)

[中文文档](./README_zh.md)

`ZXKit` is a debugging tool framework integrated on the iOS side, named after my favorite novel "Zhu Xian".

> 天地不仁，以万物为刍狗
> 
> The world is not benevolent, and everything is a dog

Because the debugging frameworks developed before are relatively scattered, it is hoped that a common framework can be used to combine different debugging tools through the structure of the plug-in.

This tool is for efficient positioning and solving of problems, rather than pursuing big and comprehensive. Therefore, iOS-side private functions, disabled interfaces and other functions that affect the launch of the App Store are not provided by default.

Of course, you can also specify a custom plug-in to install. The custom plug-in may call the disable function of the iOS system and cause the review to be rejected. Please confirm before integration~

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

3、registPlugin

```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
	
	//注册所有内置插件
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

## advanced operation

The advanced operation provides a way for personalized plug-in access, and it is still very simple to use, and there are more steps to register yourself than the direct default integration.

For example, the access and registration of the following multiple plug-ins

```
//log plugin
pod 'ZXKitLogger/zxkit'
//regist plugin
ZXKitLogger.registZXKit()

//ping plugin
pod 'HDPingTools/zxkit'
//regist
ZXKit.regist(plugin: pingTools)

//FPS plugin
pod 'ZXKitFPS/zxkit'
//regist
let fps = ZXKitFPS()
fps.registZXKitPlugin()

//file browser plugin
pod 'ZXFileBrowser/zxkit'
//regist
ZXKit.regist(plugin: ZXFileBrowser.shared())
```


## Default function

- [x] log ☞ [ZXKitCode/logger](https://github.com/ZXKitCode/logger)
- [x] network ping test  ☞ [DamonHu/HDPingTools](https://github.com/DamonHu/HDPingTools)
- [x] FPS display ☞ [ZXKitCode/FPS](https://github.com/ZXKitCode/FPS)
- [ ] 沙盒文件浏览


## Custom plugin develop

If you need to develop a custom plug-in, you only need to implement `ZXKitPluginProtocol`. The way to achieve this can be found in the documentation of [ZXKitCode/core](https://github.com/ZXKitCode/core)

## License

![](https://camo.githubusercontent.com/eb9066a6d8e0950066f3757c420e3a607c0929583b48ebda6fd9a6f50ccfc8f1/68747470733a2f2f7777772e6170616368652e6f72672f696d672f41534632307468416e6e69766572736172792e6a7067)

Base on Apache-2.0 License