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
    @objc func _loggerDidHidden() {
        DDLoggerSwift.close()
    }
}
