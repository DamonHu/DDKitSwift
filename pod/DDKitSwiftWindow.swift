//
//  DDKitSwiftWindow.swift
//  DDKitSwift
//
//  Created by Damon on 2021/4/23.
//

import UIKit

class DDKitSwiftWindow: UIWindow {
    private var inputComplete: ((String)->Void)?

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

    lazy var mInputBGView: UIView = {
        let tView = UIView()
        tView.translatesAutoresizingMaskIntoConstraints = false
        tView.isHidden = true
        tView.backgroundColor = DDKitSwift.UIConfig.inputBackgroundColor
        let tap = UITapGestureRecognizer(target: self, action: #selector(_endTextField))
        tView.addGestureRecognizer(tap)
        return tView
    }()

    lazy var mTextField: UITextField = {
        let tTextField = UITextField()
        tTextField.translatesAutoresizingMaskIntoConstraints = false
        tTextField.leftViewMode = .always
        tTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 14, height: 10))
        tTextField.backgroundColor = DDKitSwift.UIConfig.textFieldBackgroundColor
        tTextField.font = .systemFont(ofSize: 14)
        tTextField.placeholder = "input text".ZXLocaleString
        tTextField.clearButtonMode = .always
        tTextField.layer.borderWidth = 1.0
        tTextField.layer.borderColor = UIColor.dd.color(hexValue: 0xcccccc).cgColor
        tTextField.delegate = self
        tTextField.textColor = UIColor.dd.color(hexValue: 0x333333)
        return tTextField
    }()

    lazy var mButton: UIButton = {
        let tButton = UIButton(type: .custom)
        tButton.translatesAutoresizingMaskIntoConstraints = false
        tButton.addTarget(self, action: #selector(_endTextField), for: .touchUpInside)
        tButton.setTitle("confirm".ZXLocaleString, for: .normal)
        tButton.setTitleColor(UIColor.dd.color(hexValue: 0xffffff), for: .normal)
        tButton.backgroundColor = DDKitSwift.UIConfig.inputButtonBackgroundColor
        tButton.layer.borderWidth = 1.0
        tButton.layer.borderColor = UIColor.dd.color(hexValue: 0xcccccc).cgColor
        return tButton
    }()
}

extension DDKitSwiftWindow {
    func reloadData() {
        self.mCollectionView.reloadData()
    }

    func showInput(placeholder: String?, text: String?, complete: ((String)->Void)?) {
        self.inputComplete = complete
        self.mTextField.placeholder = placeholder
        self.mTextField.text = text
        self.mInputBGView.isHidden = false
        self.mTextField.becomeFirstResponder()
    }

    func hideInput() {
        self.mTextField.endEditing(true)
        self.mInputBGView.isHidden = true
        self.mTextField.placeholder = "input text".ZXLocaleString
        self.mTextField.text = ""
    }
}

extension DDKitSwiftWindow: UICollectionViewDelegate,UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return DDKitSwift.pluginList.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DDKitSwift.pluginList[section].count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let plugin = DDKitSwift.pluginList[indexPath.section][indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DDKitSwiftPluginCollectionViewCell", for: indexPath) as! DDKitSwiftPluginCollectionViewCell
        cell.updateUI(plugin: plugin)
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

extension DDKitSwiftWindow: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let complete = self.inputComplete {
            complete(textField.text ?? "")
            self.reloadData()
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}

private extension DDKitSwiftWindow {

    func _initVC() {
        self.backgroundColor = DDKitSwift.UIConfig.collectionViewBackgroundColor
        let rootViewController = UIViewController()

        let navigation = UINavigationController(rootViewController: rootViewController)
        navigation.navigationBar.barTintColor = UIColor.white
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
        let rightBarItem = UIBarButtonItem(title: "hide".ZXLocaleString, style: .plain, target: self, action: #selector(_rightBarItemClick))
        rootViewController.navigationItem.rightBarButtonItem = rightBarItem
        //
        self.rootViewController = navigation
        self.windowLevel =  UIWindow.Level.alert
        self.isUserInteractionEnabled = true
    }

    @objc func _rightBarItemClick() {
        if !self.mInputBGView.isHidden {
            self.hideInput()
        }
        DDKitSwift.hide()
    }

    @objc func _endTextField() {
        self.hideInput()
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


        rootViewController.view.addSubview(mInputBGView)
        mInputBGView.leftAnchor.constraint(equalTo: rootViewController.view.leftAnchor).isActive = true
        mInputBGView.rightAnchor.constraint(equalTo: rootViewController.view.rightAnchor).isActive = true
        mInputBGView.topAnchor.constraint(equalTo: rootViewController.view.safeAreaLayoutGuide.topAnchor).isActive = true
        mInputBGView.bottomAnchor.constraint(equalTo: rootViewController.view.safeAreaLayoutGuide.bottomAnchor).isActive = true


        mInputBGView.addSubview(mTextField)
        mTextField.leftAnchor.constraint(equalTo: mInputBGView.leftAnchor).isActive = true
        mTextField.topAnchor.constraint(equalTo: rootViewController.view.safeAreaLayoutGuide.topAnchor).isActive = true
        mTextField.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width*2.0/3.0).isActive = true
        mTextField.heightAnchor.constraint(equalToConstant: 38).isActive = true

        mInputBGView.addSubview(mButton)
        mButton.leftAnchor.constraint(equalTo: mTextField.rightAnchor).isActive = true
        mButton.rightAnchor.constraint(equalTo: mInputBGView.rightAnchor).isActive = true
        mButton.topAnchor.constraint(equalTo: mTextField.topAnchor).isActive = true
        mButton.heightAnchor.constraint(equalToConstant: 38).isActive = true
    }
}
