# ZXKit

`ZXKit`是一个iOS端整合的调试工具框架，名字取自我很喜欢的一本小说《诛仙》。

> 天地不仁，以万物为刍狗

因为之前开发的调试框架比较分散，所以希望可以通过一个通用的框架，通过插件的结构去组合不同的调试工具。该工具是为了高效的定位解决问题，而不是追求大而全，所以iOS端私有函数、禁用的接口等影响App Store上线的功能，默认都不会提供。

当然您也可以指定自定义插件安装，自定义插件可能会调用iOS系统的禁用函数导致审核被拒，集成之前请确认一下哦~

## 集成ZXKit

1、使用cocoapods集成之后即可使用默认功能

```
pod 'ZXKitSwift'
```

## 使用ZXKit

2、导入头文件

```
import ZXKitSwift
```

3、注册工具

```
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        ZXKit.registPlugin()
        return true
    }
```
4、显示工具列表

```
ZXKit.show()
```
5、隐藏工具弹窗

```
ZXKit.hide()
```
6、关闭工具弹窗

```
ZXKit.close()
```

## 默认功能

- [x] log日志 ☞ [ZXKitCode/logger](https://github.com/ZXKitCode/logger)
- [ ] 网络ping检测
- [ ] FPS检测

## 自定义插件接入

`ZXKitSwift`是已经预装默认功能的集合， `ZXKit`还支持使用自定义插件接入，只需要进入对应的库安装`ZXKit`版本即可，例如`ZXKitCode/logger`，可以只安装`ZXKit`版本即可自动在功能列表里面显示。

```
pod'ZXKitCore/zxkit'
```

## 自定义插件开发


如果需要开发自定义插件，只需要实现`ZXKitPluginProtocol`即可。实现的方式可以查看[ZXKitCode/core](https://github.com/ZXKitCode/core)的说明文档

## License

![](https://camo.githubusercontent.com/eb9066a6d8e0950066f3757c420e3a607c0929583b48ebda6fd9a6f50ccfc8f1/68747470733a2f2f7777772e6170616368652e6f72672f696d672f41534632307468416e6e69766572736172792e6a7067)

Base on Apache-2.0 License