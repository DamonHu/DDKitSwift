# netfox-zxkit

a quick look on all executed network requests performed by [NetFox](https://github.com/kasketis/netfox).

The library has been integrated into [ZXKitSwift](https://github.com/ZXKitCode/ZXKitSwift) to record network requests


一个查看app中所有网络请求的库，依赖[NetFox](https://github.com/kasketis/netfox)功能

该库已经集成到[ZXKitSwift](https://github.com/ZXKitCode/ZXKitSwift)中，用于记录网络请求

![](https://raw.githubusercontent.com/kasketis/netfox/master/assets/overview1_5_3.gif)

## 安装 install

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