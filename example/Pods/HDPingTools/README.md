# HDPingTools

This is an iOS platform for Ping tools, using swift language development. Support the use of cocoapods integration. It can be used in three steps

这是一个ios平台用来ping的工具，使用swift语言开发。支持使用cocoapods集成。三步即可使用

### [Document for English](#english) | [中文文档](#chinese)

| log | iPhone X状态栏 statusBar |  状态栏 statusBar |
|----|----|----|
|![the ScreenShot 日志截图预览](./screenshot.png)|![the ScreenShot 状态栏](./screenshot1.jpg)|![the ScreenShot 状态栏](./screenshot2.jpg)

## introduce

<span id = "english"></span>

Although the `AFNetworking` and `alamofire` provide the function of detecting the mobile network, they only know the user's network connection mode, but do not know the user's real user experience. Maybe the user is connected to WiFi, but the network speed is not as fast as 3G network. 

So it encapsulates this function. You can ping the requested domain name through this project to get the return time and judge whether the user network is in the normal range.

The package is based on Apple's [SimplePing](https://developer.apple.com/library/archive/samplecode/SimplePing/Introduction/Intro.html#//apple_ref/doc/uid/DTS10000716) and optimized again, which makes it easier to use and can be called in three steps

## CocoaPods

```
pod 'HDPingTools'
```
 
### 1. Create a ping object with a hostname

```
let pingTools = HDPingTools(hostName: "www.apple.com")
```

### 2. Start Ping


```
pingTools.start(pingType: .any, interval: .second(10)) { (response, error) in
      print(response?.pingAddressIP ?? "")
 }
```

When  `interval` is greater than 0, Ping requests will be sent repeatedly at fixed intervals. When `interval` is equal to 0, only one ping request will be sent

The `response` of the response contains the following contents

* `pingAddressIP` is the IP address corresponding to the domain name
* `responseTime` ping the response time
* `responseBytes` Response bytes

### 3. Stop request

```
pingTools.stop()
```

### 4、Optional configuration

```
public var timeout: HDPingTimeInterval = .millisecond(1000)  //user defined timeout. The default value is 1000 ms. if it is set to 0, it will wait all the time
public var debugLog = true                                  //enable log output
public var stopWhenError = false                            //stop Ping when an error is encountered
public private(set) var isPing = false				//you can judge whether there is a ping task in progress
public var showNetworkActivityIndicator: NetworkActivityIndicatorStatus = .auto              //Whether to display in the status bar
```

### 5、Support display in ZXKit

**The plug-in has been integrated in [ZXKitSwift](https://github.com/ZXKitCode/ZXKitSwift) by default, if you have already integrated `ZXKitSwift`, there is no need to repeat the integration**

This function supports ZXKit display, if you need to display, you can use

```
pod 'HDPingTools/zxkit'
```

Register the plug-in to `ZXKit` in `AppDelegate`

```
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
	
	ZXKit.regist(plugin: HDPingTools())
	
	return true
}
```


**Note: if the website or connected router is set to prohibit Ping, an error will be reported when pinging. You need to remove the restriction before you can use it normally**

<span id = "chinese"></span>

## 中文介绍

虽然在`AFNetworking`和`Alamofire`中，提供的有检测手机网络的功能，但是只是知道了用户的网络连接方式，并不清楚用户的真实用户体验，可能用户虽然连接的是wifi，但是网速还不如3G网络。所以只要不是断网条件，用户发起请求时的真实网速更重要。

所以就封装了这个功能，可以通过该项目去`ping`一下请求的域名，以便得到返回的时间，去判断用户网络是否在正常范围。

该功能是基于苹果封装的[SimplePing](https://developer.apple.com/library/archive/samplecode/SimplePing/Introduction/Intro.html#//apple_ref/doc/uid/DTS10000716)再次进行封装优化，使用更加简单，三步即可调用

## 通过CocoaPods安装

```
pod 'HDPingTools'
```

### 1、创建ping对象，hostName为自定义的域名

```
let pingTools = HDPingTools(hostName: "www.apple.com")
```

### 2、发起ping

```
pingTools.start(pingType: .any, interval: .second(10)) { (response, error) in
      print(response?.pingAddressIP ?? "")
 }
```
`interval`大于0时，会在固定间隔重复发送ping请求，等于0时只会发起一次ping请求

其中响应的`response`包含了以下内容

* `pingAddressIP` 域名对应的ip地址
* `responseTime` ping响应的时间
* `responseBytes` ping响应的字节数

### 3、关闭请求

```
pingTools.stop()
```

### 4、可选配置

```
public var timeout: HDPingTimeInterval = .millisecond(1000)  //自定义超时时间，默认1000毫秒，设置为0则一直等待
public var debugLog = true                                  //是否开启日志输出
public var stopWhenError = false                            //遇到错误停止ping
public private(set) var isPing = false				//可以判断当前是否有ping任务在进行中
public var showNetworkActivityIndicator: NetworkActivityIndicatorStatus = .auto              //是否在状态栏显示
```

### 5、可支持在ZXKit显示

**该插件已经默认集成在[ZXKitSwift](https://github.com/ZXKitCode/ZXKitSwift)中，如果您已经集成了`ZXKitSwift`，无需重复集成**

该功能支持ZXKit显示，如果需要展示，可以使用

```
pod 'HDPingTools/zxkit'
```

之后可在`AppDelegate`的启动函数中注册到`ZXKit`即可

```
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
	
	ZXKit.regist(plugin: HDPingTools())
	
	return true
}

```



**注意：网站或者连接的路由器如果设置了禁止ping，那么ping的时候会报错，需要解除该限制才可以正常使用**
