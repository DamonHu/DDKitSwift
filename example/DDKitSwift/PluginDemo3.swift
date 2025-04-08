//
//  PluginDemo3.swift
//  DDKitSwift
//
//  Created by Damon on 2021/4/23.
//

import UIKit

class PluginDemo3: NSObject {

}

extension PluginDemo3: DDKitSwiftPluginProtocol {
    var pluginIdentifier: String {
        return "com.zxkit.pluginDemo3"
    }
    
    var pluginIcon: UIImage? {
        return UIImage(named: "DDUserDefaultManager")
    }

    var pluginTitle: String {
        return "其他"
    }

    var pluginType: DDKitSwiftPluginType {
        return .other
    }

    func start() {
        print("点击开始使用该插件")
    }

    var isRunning: Bool {
        return false
    }

    func stop() {

    }
}
