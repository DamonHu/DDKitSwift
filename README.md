# ZXKit

[中文文档](./README_zh.md)

`ZXKitSwift` is a development and debugging tool integrated with iOS platform, named after my favorite novel "Zhu Xian". `ZXKitCore` is the supporting framework of `ZXKitSwift`, which is mainly used by developers of `ZXKitSwift`.

> 天地不仁，以万物为刍狗
> 
> The world is not benevolent, and everything is a dog

Because the debugging frameworks developed before are relatively scattered, it is hoped that a common framework can be used to combine different debugging tools through the structure of the plug-in.

This tool is for efficient positioning and solving of problems, rather than pursuing big and comprehensive. Therefore, iOS-side private functions, disabled interfaces and other functions that affect the launch of the App Store are not provided by default.

Of course, you can also specify a custom plug-in to install. The custom plug-in may call the disable function of the iOS system and cause the review to be rejected. Please confirm before integration~

## Integrate ZXKit

1、 You can use the default functions after using cocoapods integration

```
pod 'ZXKitSwift'
```

## Use ZXKit

2、 Import the header file

```
import ZXKitSwift
```

3、registPlugin

```
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        ZXKit.registPlugin()
        return true
    }
```

4、Display the list of tools

```
ZXKit.show()
```

5、hide the list of tools

```
ZXKit.hide()
```

6、close ZXKit

```
ZXKit.close()
```

## Default function

- [x] log
- [ ] network ping test
- [ ] FPS display

## Custom plugin

To use a custom plug-in, you only need to integrate the corresponding library to use

If you need to develop a custom plug-in, you only need to implement `ZXKitPluginProtocol`. The way to achieve this can be found in the documentation of [ZXKitCode/core](https://github.com/ZXKitCode/core)

## License

![](https://camo.githubusercontent.com/eb9066a6d8e0950066f3757c420e3a607c0929583b48ebda6fd9a6f50ccfc8f1/68747470733a2f2f7777772e6170616368652e6f72672f696d672f41534632307468416e6e69766572736172792e6a7067)

Base on Apache-2.0 License