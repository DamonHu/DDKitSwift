//
//  ZXUserDefaultManager+zxkit.swift
//  ZXUserDefaultManager
//
//  Created by Damon on 2021/7/15.
//

import Foundation
import ZXKitCore

extension ZXUserDefaultManager: ZXKitPluginProtocol {
    public var pluginIdentifier: String {
        return "com.zxkit.userDefaultManager"
    }

    public var pluginIcon: UIImage? {
        return UIImageHDBoundle(named: "ZXUserDefaultManager")
    }

    public var pluginTitle: String {
        return "ZXUserDefaultManager".ZXLocaleString
    }

    public var pluginType: ZXKitPluginType {
        return .other
    }

    public var isRunning: Bool {
        return false
    }

    public func stop() {

    }


}

