//
//  ZXKit+launch.swift
//  ZXKit
//
//  Created by Damon on 2021/4/25.
//

import Foundation
@_exported import ZXKitCore

#if canImport(ZXKitLogger)
import ZXKitLogger
#endif
#if canImport(ZXKitFPS)
import ZXKitFPS
#endif
#if canImport(HDPingTools)
import HDPingTools
#endif
#if canImport(ZXFileBrowser)
import ZXFileBrowser
#endif
#if canImport(ZXUserDefaultManager)
import ZXUserDefaultManager
#endif

#if canImport(netfox_zxkit)
import netfox_zxkit
#endif

public extension ZXKit {
    static func registPlugin() {
        #if canImport(ZXKitLogger)
        ZXKit.regist(plugin: ZXKitLogger.shared)
        #endif
        #if canImport(ZXKitFPS)
        ZXKit.regist(plugin: ZXKitFPS())
        #endif
        #if canImport(HDPingTools)
        ZXKit.regist(plugin: HDPingTools())
        #endif
        #if canImport(ZXFileBrowser)
        ZXKit.regist(plugin: ZXFileBrowser.shared)
        #endif
        #if canImport(ZXUserDefaultManager)
        ZXKit.regist(plugin: ZXUserDefaultManager.shared)
        #endif
        #if canImport(netfox_zxkit)
        ZXKit.regist(plugin: NetFoxZXKit())
        #endif
    }
}
