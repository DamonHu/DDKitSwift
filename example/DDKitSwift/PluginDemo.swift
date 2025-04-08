//
//  PluginDemo.swift
//  DDKitSwift
//
//  Created by Damon on 2021/4/23.
//

import UIKit

class PluginDemo: NSObject {
    var isPluginRunning = true
}

extension PluginDemo: DDKitSwiftPluginProtocol {

    var pluginIdentifier: String {
        return "com.zxkit.pluginDemo"
    }
    
    var pluginIcon: UIImage? {
        return UIImage(named: "DDFileBrowser")
    }

    var pluginTitle: String {
        return "插件测试"
    }

    var pluginType: DDKitSwiftPluginType {
        return .ui
    }

    func start() {
        print("点击开始使用该插件")
        isPluginRunning = true
    }

    var isRunning: Bool {
        return isPluginRunning
    }

    func stop() {
        print("插件停止运行")
        isPluginRunning = false
    }
}
