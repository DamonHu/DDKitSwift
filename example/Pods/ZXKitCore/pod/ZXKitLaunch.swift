//
//  ZXKitLaunch.swift
//  ZXKit
//
//  Created by Damon on 2021/4/25.
//

import Foundation

#if canImport(ZXKitLogger)
import ZXKitLogger
#endif

extension ZXKit {
    static func defaultPluginLaunch() {
        #if canImport(ZXKitLogger)
        ZXNormalLog("init")
        #endif
    }
}
