//
//  ZXLogger+zxkit.swift
//  DDLoggerSwift
//
//  Created by Damon on 2021/4/25.
//  Copyright © 2021 Damon. All rights reserved.
//

import Foundation
import DDLoggerSwift

//DDKitSwiftPlugin
extension DDLoggerSwift: DDKitSwiftPluginProtocol {
    public var pluginIdentifier: String {
        return "com.zxkit.zxkitLogger"
    }
    
    public var pluginIcon: UIImage? {
        return UIImageHDBoundle(named: "logger_logo")
    }

    public var pluginTitle: String {
        return "Logger".ZXLocaleString
    }

    public var pluginType: DDKitSwiftPluginType {
        return .data
    }
    
    public func didRegist() {
        NotificationCenter.default.addObserver(self, selector: #selector(_loggerDidHidden), name: .DDLoggerSwiftDidHidden, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(_logUpdate(notification: )), name: .DDLoggerSwiftDBUpdate, object: nil)
    }

    public func start() {
        DDKitSwift.hide()
        DDLoggerSwift.show()
    }

    public var isRunning: Bool {
        return true
    }

    public func stop() {
        DDKitSwift.hide()
        DDLoggerSwift.show()
    }
}

extension DDLoggerSwift {
    @objc func _logUpdate(notification: Notification) {
        DispatchQueue.main.async {
            if let floatWindow = DDKitSwift.floatWindow {
                let count = DDLoggerSwift.getItemCount(type: .error)
                if count == 0 {
                    floatWindow.setBadge(value: nil, index: 3)
                } else {
                    floatWindow.setBadge(value: "\(count)", index: 3)
                }
            }
        }
    }
    
    @objc func _loggerDidHidden() {
        DDLoggerSwift.close()
    }
}
