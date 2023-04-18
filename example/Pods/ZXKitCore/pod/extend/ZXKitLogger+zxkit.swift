//
//  ZXLogger+zxkit.swift
//  ZXKitLogger
//
//  Created by Damon on 2021/4/25.
//  Copyright © 2021 Damon. All rights reserved.
//

import Foundation
import ZXKitLogger

//ZXKitPlugin
extension ZXKitLogger: ZXKitPluginProtocol {
    public var pluginIdentifier: String {
        return "com.zxkit.zxkitLogger"
    }
    
    public var pluginIcon: UIImage? {
        return UIImageHDBoundle(named: "logger_logo")
    }

    public var pluginTitle: String {
        return "Logger".ZXLocaleString
    }

    public var pluginType: ZXKitPluginType {
        return .data
    }
    
    public func didRegist() {
        NotificationCenter.default.addObserver(self, selector: #selector(_loggerDidHidden), name: .ZXKitLoggerDidHidden, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(_logUpdate(notification: )), name: .ZXKitLogDBUpdate, object: nil)
    }

    public func start() {
        ZXKit.hide()
        ZXKitLogger.show()
    }

    public var isRunning: Bool {
        return true
    }

    public func stop() {
        ZXKit.hide()
        ZXKitLogger.show()
    }
}

extension ZXKitLogger {
    @objc func _logUpdate(notification: Notification) {
        DispatchQueue.main.async {
            if let floatWindow = ZXKit.floatWindow {
                let count = ZXKitLogger.getItemCount(type: .error)
                if count == 0 {
                    floatWindow.setBadge(value: nil, index: 3)
                } else {
                    floatWindow.setBadge(value: "\(count)", index: 3)
                }
            }
        }
    }
    
    @objc func _loggerDidHidden() {
        ZXKitLogger.close()
    }
}
