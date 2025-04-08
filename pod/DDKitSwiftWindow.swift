//
//  DDKitSwiftWindow.swift
//  DDKitSwift
//
//  Created by Damon on 2021/4/23.
//

import UIKit

public enum DDPluginItemConfig {
    case `default`
    case text(title: NSAttributedString, backgroundColor: UIColor)
    case image(image: UIImage)
}

class DDKitSwiftWindow: UIWindow {
    var currentNavVC: UINavigationController?
    var collectionList: [[(DDKitSwiftPluginProtocol, DDPluginItemConfig)]] = []
    
    @available(iOS 13.0, *)
    override init(windowScene: UIWindowScene) {
        super.init(windowScene: windowScene)
        self._initVC()
        self._loadData()
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
    lazy var mCollectionView: UICollectionView = {
        let tCollectionViewLayout = UICollectionViewFlowLayout()
        tCollectionViewLayout.itemSize = CGSize(width: UIScreen.main.bounds.width / 4, height: UIScreen.main.bounds.width / 4)
        tCollectionViewLayout.scrollDirection = UICollectionView.ScrollDirection.vertical
        tCollectionViewLayout.minimumLineSpacing = 0
        tCollectionViewLayout.minimumInteritemSpacing = 0
        tCollectionViewLayout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 40)
        let tCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: tCollectionViewLayout)
        tCollectionView.translatesAutoresizingMaskIntoConstraints = false
        tCollectionView.contentInsetAdjustmentBehavior = .never
        tCollectionView.backgroundColor = UIColor.clear
        tCollectionView.dataSource = self
        tCollectionView.delegate = self
        tCollectionView.isPagingEnabled = false
        tCollectionView.showsHorizontalScrollIndicator = false
        tCollectionView.register(DDKitSwiftPluginCollectionViewCell.self, forCellWithReuseIdentifier: "DDKitSwiftPluginCollectionViewCell")
        tCollectionView.register(DDKitSwiftCollectionViewHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "DDKitSwiftCollectionViewHeaderView")
        return tCollectionView
    }()
}

extension DDKitSwiftWindow {
    func reloadData() {
        self.mCollectionView.reloadData()
    }
    
    func updateListItem(plugin: DDKitSwiftPluginProtocol, config: DDPluginItemConfig) {
        var section = 0
        switch plugin.pluginType {
        case .ui:
            section = 0
        case .data:
            section = 1
        case .other:
            section = 2
        }
        let list = self.collectionList[section]
        if let index = list.firstIndex(where: { item in
            return item.0.pluginIdentifier == plugin.pluginIdentifier
        }) {
            var item = list[index]
            item.1 = config
            self.collectionList[section][index] = item
            self.mCollectionView.reloadItems(at: [IndexPath(item: index, section: section)])
        }
    }
}

extension DDKitSwiftWindow: UICollectionViewDelegate,UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.collectionList.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.collectionList[section].count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let pluginItem = self.collectionList[indexPath.section][indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DDKitSwiftPluginCollectionViewCell", for: indexPath) as! DDKitSwiftPluginCollectionViewCell
        cell.updateUI(plugin: pluginItem.0, config: pluginItem.1)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let title = ["UI".ZXLocaleString, "Data".ZXLocaleString, "Other".ZXLocaleString]
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "DDKitSwiftCollectionViewHeaderView", for: indexPath) as! DDKitSwiftCollectionViewHeaderView
        cell.updateUI(title: title[indexPath.section])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let plugin = DDKitSwift.pluginList[indexPath.section][indexPath.item]
        if plugin.isRunning {
            plugin.willStop()
            plugin.stop()
            self.reloadData()
        } else {
            plugin.willStart()
            plugin.start()
            self.reloadData()
        }

    }
}

private extension DDKitSwiftWindow {
    func _initVC() {
        self.backgroundColor = DDKitSwift.UIConfig.collectionViewBackgroundColor
        let rootViewController = UIViewController()

        self.currentNavVC = UINavigationController(rootViewController: rootViewController)
        self.currentNavVC!.navigationBar.barTintColor = UIColor.white
        //set title
        let view = UIView()
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = NSAttributedString(string: "DDKitSwift", attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 18, weight: .medium), NSAttributedString.Key.foregroundColor:UIColor.black])
        view.addSubview(label)
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        rootViewController.navigationItem.titleView = view
        //navigationBar
        let button = UIButton(frame: .init(x: 0, y: 0, width: 25, height: 25))
        button.setImage(UIImageHDBoundle(named: "log_icon_close"), for: .normal)
        button.addTarget(self, action: #selector(_closeBarItemClick), for: .touchUpInside)
        NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 25).isActive = true
        NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 25).isActive = true
        let leftbarItem = UIBarButtonItem(customView: button)
        
        let button1 = UIButton(frame: .init(x: 0, y: 0, width: 25, height: 25))
        button1.setImage(UIImageHDBoundle(named: "log_icon_subtract"), for: .normal)
        button1.addTarget(self, action: #selector(_hideBarItemClick), for: .touchUpInside)
        NSLayoutConstraint(item: button1, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 25).isActive = true
        NSLayoutConstraint(item: button1, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 25).isActive = true
        let leftbarItem1 = UIBarButtonItem(customView: button1)
        rootViewController.navigationItem.leftBarButtonItems = [leftbarItem, leftbarItem1]
        //
        self.rootViewController = self.currentNavVC
        self.windowLevel =  UIWindow.Level.alert
        self.isUserInteractionEnabled = true
    }

    @objc func _hideBarItemClick() {
        DDKitSwift.hide()
    }
    
    @objc func _closeBarItemClick() {
        DDKitSwift.close()
    }
    
    func _loadData() {
        self.collectionList = DDKitSwift.pluginList.map({ protocolList in
            return protocolList.map { protocolItem in
                return (protocolItem, .default)
            }
        })
    }

    func _createUI() {
        guard let navigationController = self.rootViewController as? UINavigationController, let rootViewController = navigationController.topViewController else {
            return
        }

        rootViewController.view.addSubview(mCollectionView)
        mCollectionView.leftAnchor.constraint(equalTo: rootViewController.view.leftAnchor).isActive = true
        mCollectionView.rightAnchor.constraint(equalTo: rootViewController.view.rightAnchor).isActive = true
        mCollectionView.topAnchor.constraint(equalTo: rootViewController.view.safeAreaLayoutGuide.topAnchor).isActive = true
        mCollectionView.bottomAnchor.constraint(equalTo: rootViewController.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
}
