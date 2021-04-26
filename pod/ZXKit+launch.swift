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

extension ZXKit {
    static func registPlugin() {
        #if canImport(ZXKitLogger)
        ZXNormalLog("init")
        #endif
    }
}
