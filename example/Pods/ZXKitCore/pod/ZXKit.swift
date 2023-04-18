//
//  ZXKit.swift
//  ZXKit
//
//  Created by Damon on 2021/4/23.
//

import UIKit
import ZXKitUtil
import ZXKitLogger

extension String{
    var ZXLocaleString: String {
        guard let bundlePath = Bundle(for: ZXKit.self).path(forResource: "ZXKitCore", ofType: "bundle") else { return NSLocalizedString(self, comment: "") }
        guard let bundle = Bundle(path: bundlePath) else { return NSLocalizedString(self, comment: "") }
        let msg = NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
        return msg
    }
}

func UIImageHDBoundle(named: String?) -> UIImage? {
    guard let name = named else { return nil }
    guard let bundlePath = Bundle(for: ZXKit.self).path(forResource: "ZXKitCore", ofType: "bundle") else { return UIImage(named: name) }
    guard let bundle = Bundle(path: bundlePath) else { return UIImage(named: name) }
    return UIImage(named: name, in: bundle, compatibleWith: nil)
}

public extension NSNotification.Name {
    static let ZXKitPluginRegist = NSNotification.Name("ZXKitPluginRegist")
    static let ZXKitShow = NSNotification.Name("ZXKitShow")
    static let ZXKitHide = NSNotification.Name("ZXKitHide")
    static let ZXKitClose = NSNotification.Name("ZXKitClose")
}

public enum DisplayMode {
    case none
    case input(placeholder: String?, text: String?, endEdit: ((String)->Void)?)
}

public class ZXKit: NSObject {
    public static var UIConfig = ZXKitUIConfig()
    public static let DebugFolderPath = ZXKitUtil.shared.createFileDirectory(in: .caches, directoryName: "zxkit")

    //MARK: Private
    private static var hasConfig = false
    private static var window: ZXKitWindow?
    internal static var floatWindow: ZXKitFloatWindow?
    private static var floatChangeTimer: Timer?     //悬浮按钮的修改
    private static var changeQueue = [(ZXKitButtonConfig, ZXKitPluginProtocol)]() //悬浮按钮修改的队列
    static var pluginList = [[ZXKitPluginProtocol](), [ZXKitPluginProtocol](), [ZXKitPluginProtocol]()]
}

public extension ZXKit {
    static func regist(plugin: ZXKitPluginProtocol) {
        if !hasConfig {
            self._initConfig()
        }
        var index = 0
        switch plugin.pluginType {
            case .ui:
                index = 0
            case .data:
                index = 1
            case .other:
                index = 2
        }
        if !self.pluginList[index].contains(where: { (tPlugin) -> Bool in
            return tPlugin.pluginIdentifier == plugin.pluginIdentifier
        }) {
            self.pluginList[index].append(plugin)
            plugin.didRegist()
        }
        if let window = self.window, !window.isHidden {
            DispatchQueue.main.async {
                window.reloadData()
            }
        }
        NotificationCenter.default.post(name: .ZXKitPluginRegist, object: self.pluginList)
    }

    static func show(_ mode: DisplayMode = .none) {
        if !hasConfig {
            self._initConfig()
        }
        NotificationCenter.default.post(name: .ZXKitShow, object: nil)
        DispatchQueue.main.async {
            self.floatWindow?.isHidden = true
            if let window = self.window {
                window.isHidden = false
            } else {
                if #available(iOS 13.0, *) {
                    for windowScene:UIWindowScene in ((UIApplication.shared.connectedScenes as? Set<UIWindowScene>)!) {
                        if windowScene.activationState == .foregroundActive {
                            self.window = ZXKitWindow(windowScene: windowScene)
                            self.window?.frame = UIScreen.main.bounds
                        }
                    }
                }
                if self.window == nil {
                    self.window = ZXKitWindow(frame: UIScreen.main.bounds)
                }
                self.window?.isHidden = false
                self.window?.reloadData()
            }
            //显示mode
            switch mode {
                case .none:
                    break
                case .input(let placeholder, let text, let endEdit):
                    self.window?.showInput(placeholder: placeholder, text: text, complete: endEdit)
            }
        }
    }

    static func hide() {
        NotificationCenter.default.post(name: .ZXKitHide, object: nil)
        DispatchQueue.main.async {
            self.window?.isHidden = true
            //float window
            if let window = self.floatWindow {
                window.isHidden = false
            } else {
                if #available(iOS 13.0, *) {
                    for windowScene:UIWindowScene in ((UIApplication.shared.connectedScenes as? Set<UIWindowScene>)!) {
                        if windowScene.activationState == .foregroundActive {
                            self.floatWindow = ZXKitFloatWindow(windowScene: windowScene)
                            self.floatWindow?.frame = CGRect(x: UIScreen.main.bounds.size.width - 80, y: 100, width: 60, height: 60)
                        }
                    }
                }
                if self.floatWindow == nil {
                    self.floatWindow = ZXKitFloatWindow(frame: CGRect(x: UIScreen.main.bounds.size.width - 80, y: 100, width: 60, height: 60))
                }
                self.floatWindow?.isHidden = false
            }
            let count = ZXKitLogger.getItemCount(type: .error)
            if count == 0 {
                self.floatWindow?.setBadge(value: nil, index: 3)
            } else {
                self.floatWindow?.setBadge(value: "\(count)", index: 3)
            }
        }
    }

    static func close() {
        NotificationCenter.default.post(name: .ZXKitClose, object: nil)
        DispatchQueue.main.async {
            self.window?.isHidden = true
            self.floatWindow?.isHidden = true
            self.floatWindow?.menuButtonType = .default
            self.floatChangeTimer?.invalidate()
            self.floatChangeTimer = nil
        }
    }
    
    static func updateFloatButton(config: ZXKitButtonConfig, plugin: ZXKitPluginProtocol) {
        if let last = self.changeQueue.last, last.0 == config, last.1.pluginIdentifier == plugin.pluginIdentifier {
            //如果和最后一次重复就不再添加
            return
        }
        self.changeQueue.append((config, plugin))
        //更新
        self._floatButtonChange()
    }
}

private extension ZXKit {
    static func _initConfig() {
        if hasConfig {
            return
        }
        self.hasConfig = true
        self.regist(plugin: ZXKitLogger.shared)
    }
    
    static func _floatButtonChange() {
        guard let firstQueue = self.changeQueue.first else { return }
        if let floatWindow = self.floatWindow {
            if self.floatChangeTimer == nil {
                self.floatChangeTimer = Timer(timeInterval: 2, repeats: true, block: { timer in
                    DispatchQueue.main.async {
                        if self.changeQueue.isEmpty {
                            //队列已循环完毕
                            floatWindow.menuButtonType = .default
                            self.floatChangeTimer?.invalidate()
                            self.floatChangeTimer = nil
                        } else {
                            floatWindow.menuButtonType = .info(config: firstQueue.0, image: firstQueue.1.pluginIcon)
                            self.changeQueue.removeFirst()
                        }
                    }
                })
                RunLoop.main.add(self.floatChangeTimer!, forMode: .common)
                self.floatChangeTimer?.fire()
            }
        }
    }
}
