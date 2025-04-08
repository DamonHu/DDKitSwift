//
//  DDKitSwiftFloatWindow.swift
//  DDKitSwift
//
//  Created by Damon on 2021/4/25.
//

import UIKit
import DDUtils
import DDLoggerSwift

class DDKitSwiftFloatWindow: UIWindow {
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

    //MARK: UI
    lazy var mLogoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImageHDBoundle(named: "zx_logo"))
        imageView.isUserInteractionEnabled = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var mButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = DDKitSwift.UIConfig.floatButtonColor
        button.dd.addLayerShadow(color: UIColor.dd.color(hexValue: 0x171619), offset: CGSize(width: 0, height: 0), radius: 5, cornerRadius: 30)
        button.layer.borderColor = UIColor.dd.color(hexValue: 0xffffff, alpha: 0.9).cgColor
        button.layer.borderWidth = 3.5
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
        
        mButton.addSubview(mLogoImageView)
        mLogoImageView.centerXAnchor.constraint(equalTo: mButton.centerXAnchor).isActive = true
        mLogoImageView.centerYAnchor.constraint(equalTo: mButton.centerYAnchor).isActive = true
        mLogoImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        mLogoImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
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
