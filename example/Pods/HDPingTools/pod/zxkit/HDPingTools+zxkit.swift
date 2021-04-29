//
//  HDPingTools+zxkit.swift
//  HDPingTools
//
//  Created by Damon on 2021/4/29.
//

import Foundation
import ZXKitCore
import ZXKitLogger

func UIImageHDBoundle(named: String?) -> UIImage? {
    guard let name = named else { return nil }
    guard let bundlePath = Bundle(for: HDPingTools.self).path(forResource: "HDPingTools", ofType: "bundle") else { return nil }
    let bundle = Bundle(path: bundlePath)
    return UIImage(named: name, in: bundle, compatibleWith: nil)
}

extension HDPingTools {
    public func registZXKitPlugin() {
        ZXKit.regist(plugin: self)
    }
}

//ZXKitPlugin
extension HDPingTools: ZXKitPluginProtocol {
    public var pluginIdentifier: String {
        return "com.zxkit.HDPingTools"
    }

    public var pluginIcon: UIImage? {
        return UIImageHDBoundle(named: "HDPingTool.png")
    }

    public var pluginTitle: String {
        return NSLocalizedString("Ping", comment: "")
    }

    public var pluginType: ZXKitPluginType {
        return .ui
    }

    public func start() {
        self.stop()
        ZXKit.resetFloatButton()
        ZXKit.textField?.placeholder = "baidu.com"
        ZXKit.textField?.text = "baidu.com"
        ZXKit.showInput { [weak self] (url) in
            guard let self = self else { return }
            self.hostName = url
            ZXKitLogger.show()
            if !self.isPing {
                self.start(pingType: .any, interval: .second(2)) { (response, error) in
                    if let error = error {
                        ZXErrorLog(error.localizedDescription)
                    } else if let response = response {
                        let time = Int(response.responseTime.second * 1000)
                        ZXNormalLog("ping: \(response.pingAddressIP) sent \(response.responseBytes) data bytes, response:  \(time)ms")
                        ZXKit.floatButton?.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .bold)
                        ZXKit.floatButton?.setTitle("\(time)ms", for: .normal)
                        if time >= 100 {
                            ZXKit.floatButton?.backgroundColor = UIColor.zx.color(hexValue: 0xaa2b1d)
                        } else if (time >= 50 && time < 100) {
                            ZXKit.floatButton?.backgroundColor = UIColor.zx.color(hexValue: 0xf0a500)
                        } else {
                            ZXKit.floatButton?.backgroundColor = UIColor.zx.color(hexValue: 0x5dae8b)
                        }
                    }
                }
            }
        }
    }
}
