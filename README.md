# DDKitSwift

![](https://img.shields.io/badge/CocoaPods-supported-brightgreen) ![](https://img.shields.io/badge/Swift-5.0-brightgreen) ![](https://img.shields.io/badge/License-MIT-brightgreen) ![](https://img.shields.io/badge/version-iOS11.0-brightgreen)

### [中文文档](https://ddceo.com/blog/1306.html)

`DDKitSwift` is the supporting framework of `DDKitSwift` plug-ins, the object-oriented is the development of `DDKitSwift` plug-in. It provides plug-in display, management and other functions. You can quickly develop and display DDKitSwift plug-ins by implementing the `DDKitSwiftPluginProtocol`. This document provides plug-in development tutorials and use tutorials, which developers can view as needed.


## Develop a DDKitSwift plugin

## 1. Import the core file

Project import `DDKitSwift`, you can use cocoapods to quickly import core files

```
pod 'DDKitSwift'
```

## 2. Implement the protocol

Declare an object and follow the `DDKitSwiftPluginProtocol` protocol.

```
class PluginDemo: NSObject {
    var isPluginRunning = true
}

extension PluginDemo: DDKitSwiftPluginProtocol {
	 //Unique identification
    var pluginIdentifier: String {
        return "com.DDKitSwift.pluginDemo"
    }
    
    var pluginIcon: UIImage? {
        return UIImage(named: "DDKitSwift")
    }

    var pluginTitle: String {
        return "title"
    }

    var pluginType: DDKitSwiftPluginType {
        return .ui
    }

    func start() {
        print("start plugin")
        isPluginRunning = true
    }
    
    var isRunning: Bool {
        return isPluginRunning
    }

    func stop() {
        print("plugin stop running")
        isPluginRunning = false
    }
}
```

#### Optional Protocol

```
func willStart()
func willStop()
```

### 3. Register the plug-in

After that, you can register the plug-in, you only need to register once globally


```
DDKitSwift.regist(plugin: PluginDemo())
```

### 4. Done

After cocoapods is released and online, when the user opens `DDKitSwift`, your plug-in will appear on the debug collection page


## 5. Custom Configuration

#### 5.1、The window color and other display can be modified by modifying 'UIConfig'

```
DDKitSwift.UIConfig
```

#### 5.2、Debug folder, which will be packaged and shared during floating menu sharing

```
DDKitSwift.DebugFolderPath
```

#### 5.3、Display textField

```
DDKitSwift.show(.input(placeholder: "placeholder", text: nil, endEdit: { text in
      print(text)
}))
```

#### 5.4、Update floating icon

```
let config = DDKitSwiftButtonConfig(title: "test\(i)")
DDKitSwift.updateFloatButton(config: config, plugin: PluginDemo())
```

#### 5.5、 Output debugging data to floating window

```
printError("error")
```

### NSNotification

`DDKitSwift` provides the following message notifications, you can get the frame display, hide, close, and register new plug-in timing by binding the following notifications

```
//new plug-in regist
NSNotification.Name.DDKitSwiftPluginRegist
//show
NSNotification.Name.DDKitSwiftShow
//hide
NSNotification.Name.DDKitSwiftHide
//close
NSNotification.Name.DDKitSwiftClose
```

## Install and use a DDKitSwift plugin

The DDKitSwift plug-in is easy to use. For example, install the log plugin `DDKitSwiftLogger`.

### install it

```
pod 'DDKitSwiftLogger/DDKitSwift'
```
### regist it

```
DDKitSwift.regist(plugin: DDKitSwiftLogger.shared)
```

### open the plugin list

```
DDKitSwift.show()
```

### hide the plugin list

```
DDKitSwift.hide()
```

### close the plugin list

```
DDKitSwift.close()
```

## DDKitSwift

We have released a cocoaPods library named [DDKitSwift](https://github.com/DamonHu/DDKitSwift), which is a tool library that integrates multiple DDKitSwift-plugins。It can help you quickly use multiple debugging functions

## License

DDKitSwift is released under the MIT license. 
