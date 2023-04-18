//
//  ZXKitUIConfig.swift
//  ZXKitCore
//
//  Created by Damon on 2022/7/23.
//

import Foundation
import ZXKitUtil

public struct ZXKitUIConfig {
    public var floatButtonColor = UIColor.zx.color(hexValue: 0x5dae8b)     //悬浮窗按钮颜色
    public var collectionViewBackgroundColor = UIColor.zx.color(hexValue: 0xffffff, alpha: 0.7)
    public var collectionViewTitleColor = UIColor.zx.color(hexValue: 0xffffff)
    public var collectionViewTitleBackgroundColor = UIColor.zx.color(hexValue: 0x5dae8b)
    public var inputBackgroundColor = UIColor.zx.color(hexValue: 0x000000, alpha: 0.7)
    public var textFieldBackgroundColor = UIColor.zx.color(hexValue: 0xffffff, alpha: 0.8)
    public var inputButtonBackgroundColor = UIColor.zx.color(hexValue: 0x5dae8b)
}

public struct ZXKitButtonConfig: Equatable {
    public var title: String?
    public var titleColor: UIColor = UIColor.zx.color(hexValue: 0xffffff)
    public var titleFont: UIFont = UIFont.systemFont(ofSize: 13, weight: .bold)
    public var backgroundColor: UIColor?

    public init(title: String?, titleColor: UIColor = UIColor.zx.color(hexValue: 0xffffff), titleFont: UIFont = UIFont.systemFont(ofSize: 13, weight: .bold), backgroundColor: UIColor? = nil) {
        self.title = title
        self.titleColor = titleColor
        self.titleFont = titleFont
        self.backgroundColor = backgroundColor
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.title == rhs.title && lhs.titleColor == rhs.titleColor && lhs.titleFont == rhs.titleFont && lhs.backgroundColor == rhs.backgroundColor
    }
}
