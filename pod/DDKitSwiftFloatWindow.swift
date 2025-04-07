//
//  DDKitSwiftFloatWindow.swift
//  DDKitSwift
//
//  Created by Damon on 2021/4/25.
//

import UIKit
import DDUtils
import DDLoggerSwift

enum ZXFloatMenuButtonType {
    case `default`
    case info(config: DDKitSwiftButtonConfig, image: UIImage?)
}

class DDKitSwiftFloatWindow: UIWindow {
    var menuButtonType: ZXFloatMenuButtonType = .default {
        didSet {
            switch menuButtonType {
                case .default:
                    mButton.setImage(UIImage(named: "zx_logo"), for: .normal)
                    mButton.setTitle(nil, for: .normal)
                    mButton.backgroundColor = DDKitSwift.UIConfig.floatButtonColor
                case .info(let config, let image):
                    mButton.setImage(image, for: .normal)
                    mButton.setTitle(config.title, for: .normal)
                    mButton.titleLabel?.font = config.titleFont
                    mButton.setTitleColor(config.titleColor, for: .normal)
                    mButton.backgroundColor = config.backgroundColor ?? DDKitSwift.UIConfig.floatButtonColor
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

    lazy var mButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImageHDBoundle(named: "zx_logo"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = DDKitSwift.UIConfig.floatButtonColor
        button.dd.addLayerShadow(color: UIColor.dd.color(hexValue: 0x333333), offset: CGSize(width: 2, height: 2), radius: 4, cornerRadius: 30)
        button.addTarget(self, action: #selector(_clickFloatButton), for: .touchUpInside)
        let pan = UIPanGestureRecognizer(target: self, action: #selector(_touchMove(p:)))
        button.addGestureRecognizer(pan)
        return button
    }()
}

private extension DDKitSwiftFloatWindow {
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
        guard let window = DDUtils.shared.getCurrentNormalWindow() else { return }
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
        guard let window = DDUtils.shared.getCurrentNormalWindow() else { return }
        var x: CGFloat = 50
        if self.center.x > (window.bounds.size.width) / 2.0 {
            x = window.bounds.size.width - 50
        } else {
            x = 50
        }
        let y = min(max(130, self.center.y), window.bounds.size.height - 140)
        UIView.animate(withDuration: 0.35) {
            self.center = CGPoint(x: x, y: y)
        }
    }
    
    @objc func _clickFloatButton() {
        DDKitSwift.show()
    }
}
