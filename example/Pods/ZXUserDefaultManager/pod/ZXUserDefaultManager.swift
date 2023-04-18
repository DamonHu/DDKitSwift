//
//  ZXUserDefaultManager.swift
//  ZXUserDefaultManager
//
//  Created by Damon on 2021/7/15.
//

import UIKit
import ZXKitUtil

open class ZXUserDefaultManager: NSObject {
    private static let instance = ZXUserDefaultManager()
    open class var shared: ZXUserDefaultManager {
        return instance
    }

    //MARK: UI
    lazy var mNavigationController: UINavigationController = {
        let rootViewController = ZXUserDefaultVC()
        let navigation = UINavigationController(rootViewController: rootViewController)
        navigation.navigationBar.barTintColor = UIColor.white
        return navigation
    }()

}

public extension ZXUserDefaultManager {
    func start() {
        self.mNavigationController.dismiss(animated: false) { [weak self] in
            guard let self = self else { return }
            ZXKitUtil.shared.getCurrentVC()?.present(self.mNavigationController, animated: true, completion: nil)
        }
    }
}
