//
//  ZXKitFloatWindow.swift
//  ZXKit
//
//  Created by Damon on 2021/4/25.
//

import UIKit
import ZXKitUtil
import ZXKitLogger
import SSZipArchive

enum ZXFloatMenuStatus {
    case collapsed
    case open
}

enum ZXFloatMenuButtonType {
    case `default`
    case info(config: ZXKitButtonConfig, image: UIImage?)
}

class ZXKitFloatWindow: UIWindow {
    let items: [(icon: String, color: UIColor)] = [
        ("icon_home", UIColor(red: 0.19, green: 0.57, blue: 1, alpha: 1)),
        ("icon_share", UIColor(red: 0.22, green: 0.74, blue: 0, alpha: 1)),
        ("icon_close", UIColor(red: 0.96, green: 0.23, blue: 0.21, alpha: 1)),
        ("icon_notice", UIColor(red: 0.51, green: 0.15, blue: 1, alpha: 1)),
        ("nearby-btn", UIColor(red: 1, green: 0.39, blue: 0, alpha: 1))
    ]

    var menuStatus: ZXFloatMenuStatus = .collapsed {
        didSet {
            switch menuStatus {
                case .collapsed:
                    self.bounds.size.width = 60
                    self.bounds.size.height = 60
                case .open:
                    self.bounds.size.width = 240
                    self.bounds.size.height = 240
            }
            self._resetPosition()
        }
    }

    var menuButtonType: ZXFloatMenuButtonType = .default {
        didSet {
            switch menuButtonType {
                case .default:
                    mButton.mMaskView.mImageView.image = nil
                    mButton.mMaskView.mLabel.text = nil
                    mButton.mMaskView.mMaskView.backgroundColor = .clear
                case .info(let config, let image):
                    mButton.mMaskView.mImageView.image = image
                    mButton.mMaskView.mLabel.text = config.title
                    mButton.mMaskView.mLabel.textColor = config.titleColor
                    mButton.mMaskView.mMaskView.backgroundColor = config.backgroundColor ?? UIColor.zx.color(hexValue: 0x000000, alpha: 0.5)
                    mButton.mMaskView.mLabel.font = config.titleFont
            }
        }
    }



    @available(iOS 13.0, *)
    override init(windowScene: UIWindowScene) {
        super.init(windowScene: windowScene)
        self._initVC()
        self._createUI()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self._initVC()
        self._createUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var mButton: CircleMenu = {
        let button = CircleMenu(
            frame: CGRect(x: 0, y: 0, width: 60, height: 60),
            normalIcon:"zx_logo",
            selectedIcon:"zx_logo",
            buttonsCount: 4,
            duration: 1.5,
            distance: 120)
        button.delegate = self
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = ZXKit.UIConfig.floatButtonColor
        button.zx.addLayerShadow(color: UIColor.zx.color(hexValue: 0x333333), offset: CGSize(width: 2, height: 2), radius: 4, cornerRadius: 30)

        let pan = UIPanGestureRecognizer(target: self, action: #selector(_touchMove(p:)))
        button.addGestureRecognizer(pan)
        return button
    }()
}

extension ZXKitFloatWindow {
    func setBadge(value: String?, index: Int) {
        self.mButton.setBadge(value: value, index: index)
    }
}

private extension ZXKitFloatWindow {
    func _initVC() {
        self.rootViewController = UIViewController()
        self.windowLevel =  UIWindow.Level.alert
        self.isUserInteractionEnabled = true
    }

    func _createUI() {
        guard let rootViewController = self.rootViewController else {
            return
        }

        rootViewController.view.addSubview(mButton)
        mButton.centerXAnchor.constraint(equalTo: rootViewController.view.centerXAnchor).isActive = true
        mButton.centerYAnchor.constraint(equalTo: rootViewController.view.centerYAnchor).isActive = true
        mButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        mButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }

    @objc func _touchMove(p:UIPanGestureRecognizer) {
        guard let window = ZXKitUtil.shared.getCurrentNormalWindow() else { return }
        let panPoint = p.location(in: window)
        //跟随手指拖拽
        if p.state == .changed {
            self.center = CGPoint(x: panPoint.x, y: panPoint.y)
            p.setTranslation(CGPoint.zero, in: self)
        }
        //弹回边界
        if p.state == .ended || p.state == .cancelled {
            self._resetPosition()
            p.setTranslation(CGPoint.zero, in: self)
        }
    }

    func _resetPosition() {
        guard let window = ZXKitUtil.shared.getCurrentNormalWindow() else { return }
        var x: CGFloat = 50
        if self.center.x > (window.bounds.size.width) / 2.0 {
            switch self.menuStatus {
                case .open:
                    x = window.bounds.size.width - 150
                default:
                    x = window.bounds.size.width - 50
            }
        } else {
            switch self.menuStatus {
                case .open:
                    x = 150
                default:
                    x = 50
            }
        }
        let y = min(max(130, self.center.y), window.bounds.size.height - 140)
        UIView.animate(withDuration: 0.35) {
            self.center = CGPoint(x: x, y: y)
        }
    }
}

extension ZXKitFloatWindow: CircleMenuDelegate {
    func circleMenu(_: CircleMenu, willDisplay button: UIButton, atIndex: Int) {
        button.backgroundColor = items[atIndex].color

        button.setImage(UIImageHDBoundle(named: items[atIndex].icon), for: .normal)

        // set highlited image
        let highlightedImage = UIImageHDBoundle(named: items[atIndex].icon)?.withRenderingMode(.alwaysTemplate)
        button.setImage(highlightedImage, for: .highlighted)
        button.tintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
    }

    func circleMenu(_ circleMenu: CircleMenu, buttonWillSelected button: UIButton, atIndex: Int) {
        if atIndex == 1 {
            let zipPath = ZXKitUtil.shared.getFileDirectory(type: .caches).appendingPathComponent("zxkit.zip", isDirectory: false)
            if FileManager.default.fileExists(atPath: zipPath.path) {
                try? FileManager.default.removeItem(at: zipPath)
            }
            SSZipArchive.createZipFile(atPath: zipPath.path, withContentsOfDirectory: ZXKit.DebugFolderPath.path)
            //分享
            ShareTools.shared.share(type: .file(url: zipPath), sourceView: button) { result in
                if result == .fail {
                    printError("share error")
                }
            }
        }
    }

    func circleMenu(_: CircleMenu, buttonDidSelected button: UIButton, atIndex: Int) {
        if atIndex == 0 {
            ZXKit.show()
        } else if atIndex == 1 {
            //已经提前处理
        } else if atIndex == 2 {
            ZXKit.close()
        } else if atIndex == 3 {
            ZXKitLogger.show(filterType: .error)
        }
    }

    func menuCollapsed(_ circleMenu: CircleMenu) {
        self.menuStatus = .collapsed
    }

    func menuOpened(_ circleMenu: CircleMenu) {
        self.menuStatus = .open
        //计算运行中的数量
        let count = ZXKit.pluginList.flatMap { $0 }.filter { plugin in
            plugin.isRunning
        }.count
        if count == 0 {
            self.setBadge(value: nil, index: 0)
        } else {
            self.setBadge(value: "\(count)", index: 0)
        }
    }
}
