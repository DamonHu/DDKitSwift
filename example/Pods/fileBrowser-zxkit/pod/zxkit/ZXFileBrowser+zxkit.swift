//
//  ZXFileBrowser+zxkit.swift
//  ZXFileBrowserDemo
//
//  Created by Damon on 2021/5/11.
//

import Foundation
import ZXFileBrowser
import ZXKitCore

func UIImageHDBoundle(named: String?) -> UIImage? {
    guard let name = named else { return nil }
    guard let bundlePath = Bundle(for: FileBrowserZXKit.self).path(forResource: "fileBrowser-zxkit", ofType: "bundle") else { return UIImage(named: name) }
    guard let bundle = Bundle(path: bundlePath) else { return UIImage(named: name) }
    return UIImage(named: name, in: bundle, compatibleWith: nil)
}

extension String{
    var ZXLocaleString: String {
        guard let bundlePath = Bundle(for: FileBrowserZXKit.self).path(forResource: "fileBrowser-zxkit", ofType: "bundle") else { return NSLocalizedString(self, comment: "") }
        guard let bundle = Bundle(path: bundlePath) else { return NSLocalizedString(self, comment: "") }
        let msg = NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
        return msg
    }
}

class FileBrowserZXKit: NSObject {
    
}

extension ZXFileBrowser: ZXKitPluginProtocol {
    public var pluginIdentifier: String {
        return "com.zxkit.fileBrowser"
    }

    public var pluginIcon: UIImage? {
        return UIImageHDBoundle(named: "zxfilebrowser")
    }

    public var pluginTitle: String {
        return "FileBrowser".ZXLocaleString
    }

    public var pluginType: ZXKitPluginType {
        return .other
    }

    public var isRunning: Bool {
        return false
    }
    
    public func willStart() {
        ZXKit.hide()
    }

    public func stop() {
        
    }
}
