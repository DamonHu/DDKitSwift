//
//  ZXKit+launch.swift
//  ZXKit
//
//  Created by Damon on 2021/4/25.
//

import Foundation
@_exported import ZXKitCore


#if canImport(fps_zxkit)
import ZXKitFPS
import fps_zxkit
#endif
#if canImport(ping_zxkit)
import HDPingTools
import ping_zxkit
#endif
#if canImport(fileBrowser_zxkit)
import ZXFileBrowser
import fileBrowser_zxkit
#endif
#if canImport(userDefaultManager_zxkit)
import ZXUserDefaultManager
import userDefaultManager_zxkit
#endif

#if canImport(netfox_zxkit)
import netfox
import netfox_zxkit
#endif

public extension ZXKit {
    static func registPlugin() {
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
