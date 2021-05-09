//
//  ZXKitFPS+zxkit.swift
//  ZXKitFPS
//
//  Created by Damon on 2021/4/27.
//

import Foundation
import ZXKitCore

func UIImageHDBoundle(named: String?) -> UIImage? {
    guard let name = named else { return nil }
    guard let bundlePath = Bundle(for: ZXKitFPS.self).path(forResource: "ZXKitFPS", ofType: "bundle") else { return nil }
    let bundle = Bundle(path: bundlePath)
    return UIImage(named: name, in: bundle, compatibleWith: nil)
}

extension ZXKitFPS {
    public func registZXKitPlugin() {
        ZXKit.regist(plugin: self)
    }
}

//ZXKitPlugin
extension ZXKitFPS: ZXKitPluginProtocol {
    public var pluginIdentifier: String {
        return "com.zxkit.zxkitFPS"
    }
    
    public var pluginIcon: UIImage? {
        return UIImageHDBoundle(named: "logo")
    }
    
    public var pluginTitle: String {
        return NSLocalizedString("FPS", comment: "")
    }
    
    public var pluginType: ZXKitPluginType {
        return .ui
    }
    
    public func start() {
        ZXKit.hide()
        self.start { (fps) in
            ZXKit.floatButton?.setTitle("\(fps)FPS", for: UIControl.State.normal)
            ZXKit.floatButton?.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .bold)
            if fps >= 55 {
                ZXKit.floatButton?.backgroundColor = UIColor.zx.color(hexValue: 0x5dae8b)
            } else if (fps >= 50 && fps < 55) {
                ZXKit.floatButton?.backgroundColor = UIColor.zx.color(hexValue: 0xf0a500)
            } else {
                ZXKit.floatButton?.backgroundColor = UIColor.zx.color(hexValue: 0xaa2b1d)
            }
        }
    }
}
