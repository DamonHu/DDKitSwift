# netfox-zxkit

![](https://img.shields.io/badge/CocoaPods-supported-brightgreen) ![](https://img.shields.io/badge/Swift-5.0-brightgreen) ![](https://img.shields.io/badge/License-MIT-brightgreen) ![](https://img.shields.io/badge/version-iOS11.0-brightgreen)

If you need to quickly integrate multiple debugging functions, such as log viewing, network speed testing, file viewing and so on, please use [DamonHu/ZXKitSwift](https://github.com/DamonHu/ZXKitSwift).

如果您需要的是快速集成多个调试功能，例如日志查看、网速测试、文件查看等功能，请使用 [DamonHu/ZXKitSwift](https://github.com/DamonHu/ZXKitSwift)。

## intro

a quick look on all executed network requests performed by [NetFox](https://github.com/kasketis/netfox).The library has been integrated into [ZXKitSwift](https://github.com/DamonHu/ZXKitSwift) to record network requests, if you have already integrated `ZXKitSwift`, there is no need to repeat the integration.


一个查看app中所有网络请求的库，依赖[NetFox](https://github.com/kasketis/netfox)功能，该插件已经默认集成在[ZXKitSwift](https://github.com/DamonHu/ZXKitSwift)中，如果您已经集成了`ZXKitSwift`，无需重复集成该插件

## preview

![](https://raw.githubusercontent.com/kasketis/netfox/master/assets/overview1_5_3.gif)

## install

### cocoapods

```
pod 'netfox-zxkit'
```

```
import netfox_zxkit
//注册 regist
ZXKit.regist(plugin: NetFoxZXKit())

```

Display the list of tools

```
ZXKit.show()
```

hide the list of tools

```
ZXKit.hide()
```

close ZXKit

```
ZXKit.close()
```

## License

该项目基于MIT协议，您可以自由修改使用