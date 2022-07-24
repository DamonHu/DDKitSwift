//
//  ZXUserDefaultEditVC.swift
//  ZXUserDefaultManager
//
//  Created by Damon on 2021/7/16.
//

import UIKit
import SnapKit
import ZXKitUtil

class ZXUserDefaultEditVC: UIViewController {
    private var model: ZXDataCellModel
    
    init(model: ZXDataCellModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let rightBarItem = UIBarButtonItem(title: "save".ZXLocaleString, style: .plain, target: self, action: #selector(_rightBarItemClick))
        self.navigationItem.rightBarButtonItem = rightBarItem
        self._createUI()
        self._loadData()
    }

    //MARK: UI
    lazy var mTitleLabel: UILabel = {
        let tLabel = UILabel()
        tLabel.textAlignment = .center
        tLabel.numberOfLines = 2
        tLabel.font = .systemFont(ofSize: 16, weight: .medium)
        tLabel.textColor = UIColor.zx.color(hexValue: 0x333333)
        return tLabel
    }()

    lazy var mSegment: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["Bool", "Number", "String", "Object"])
        segment.addTarget(self, action: #selector(_changeType), for: .valueChanged)
        return segment
    }()
    
    lazy var mValueSegment: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["true", "false"])
        segment.isHidden = true
        return segment
    }()
    
    lazy var mTextView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 14)
        textView.layer.cornerRadius = 10
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = UIColor.zx.color(hexValue: 0xeeeeee).cgColor
        return textView
    }()
}

extension ZXUserDefaultEditVC {
    @objc func _rightBarItemClick() {
        switch self.mSegment.selectedSegmentIndex {
            case 0:
                UserDefaults.standard.set(mValueSegment.selectedSegmentIndex == 0 ? true : false, forKey: model.key)
            case 1:
                UserDefaults.standard.set(Double(String(mTextView.text)) ?? 0, forKey: model.key)
            case 2:
                UserDefaults.standard.set(mTextView.text, forKey: model.key)
            default:
                if let jsonData = mTextView.text.data(using: .utf8), let object = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) {
                    UserDefaults.standard.set(object, forKey: model.key)
                } else {
                    UserDefaults.standard.set(mTextView.text, forKey: model.key)
                }
        }
        self.navigationController?.popViewController(animated: true)
    }

    func _createUI() {
        self.view.backgroundColor = UIColor.zx.color(hexValue: 0xffffff)
        self.view.addSubview(mTitleLabel)
        mTitleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(20)
        }

        self.view.addSubview(mSegment)
        mSegment.snp.makeConstraints { make in
            make.left.right.equalTo(self.mTitleLabel)
            make.top.equalTo(mTitleLabel.snp.bottom).offset(30)
            make.height.equalTo(34)
        }
        
        self.view.addSubview(mValueSegment)
        mValueSegment.snp.makeConstraints { make in
            make.left.right.equalTo(mSegment)
            make.top.equalTo(mSegment.snp.bottom).offset(10)
            make.height.equalTo(40)
        }

        self.view.addSubview(mTextView)
        mTextView.snp.makeConstraints { make in
            make.left.right.equalTo(mSegment)
            make.top.equalTo(mSegment.snp.bottom).offset(10)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
    }

    func _loadData() {
        mTitleLabel.text = model.key
        if model.value is Bool {
            mSegment.selectedSegmentIndex = 0
        } else if model.value is NSNumber {
            mSegment.selectedSegmentIndex = 1
        } else if model.value is String {
            mSegment.selectedSegmentIndex = 2
        } else if (model.value is NSArray || model.value is NSDictionary) {
            mSegment.selectedSegmentIndex = 3
        }
        self._changeType()
    }

    @objc func _changeType() {
        mValueSegment.isHidden = true
        mTextView.isHidden = false
        mTextView.resignFirstResponder()
        switch self.mSegment.selectedSegmentIndex {
            case 0:
                mValueSegment.isHidden = false
                mTextView.isHidden = true
                mValueSegment.selectedSegmentIndex = "\(model.value)".boolValue ? 0 : 1
            case 1:
                mTextView.keyboardType = .decimalPad
                if model.value is NSNumber {
                    mTextView.text = "\(model.value)"
                } else {
                    mTextView.text = "\(Double("\(model.value)") ?? 0)"
                }
            default:
                mTextView.keyboardType = .default
                if JSONSerialization.isValidJSONObject(model.value), let jsonData = try? JSONSerialization.data(withJSONObject: model.value, options: .prettyPrinted) {
                    mTextView.text = String(data: jsonData, encoding: .utf8)
                } else {
                    mTextView.text = "\(model.value)"
                }
        }
    }
}

extension String {
    var boolValue: Bool {
        switch self.lowercased() {
            case "false", "no", "0":
                return false
            default:
                return !self.isEmpty
        }
    }
}
