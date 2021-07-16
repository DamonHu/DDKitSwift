//
//  ZXDataTableViewCell.swift
//  ZXUserDefaultManager
//
//  Created by Damon on 2021/7/15.
//

import UIKit
import SnapKit

class ZXDataTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self._createUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    lazy var mIconButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .systemFont(ofSize: 12)
        button.setTitleColor(UIColor.zx.color(hexValue: 0xffffff), for: .normal)
        button.backgroundColor = UIColor.zx.color(hexValue: 0x93D9A3)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 5
        return button
    }()

    lazy var mTitleLabel: UILabel = {
        let tLabel = UILabel()
        tLabel.lineBreakMode = .byCharWrapping
        tLabel.numberOfLines = 3
        tLabel.font = .systemFont(ofSize: 12)
        tLabel.textColor = UIColor.zx.color(hexValue: 0x333333)
        return tLabel
    }()
}

extension ZXDataTableViewCell {
    func updateUI(model: ZXDataCellModel) {
        self._updateButton(model: model)

        let attributedString = NSMutableAttributedString(string: "Key: \(model.key)\n\n")
        attributedString.setAttributes([NSAttributedString.Key.foregroundColor : UIColor.zx.color(hexValue: 0xFF616D), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .bold)], range: NSRange(location: 0, length: 4))

        let valueAttributedString = NSMutableAttributedString(string: "Value: \(model.value)")
        valueAttributedString.setAttributes([NSAttributedString.Key.foregroundColor : UIColor.zx.color(hexValue: 0x5D8233), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .bold)], range: NSRange(location: 0, length: 7))
        attributedString.append(valueAttributedString)
        mTitleLabel.attributedText = attributedString
    }
}

extension ZXDataTableViewCell {
    func _createUI() {
        self.contentView.addSubview(mIconButton)
        mIconButton.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(70)
            $0.height.equalTo(20)
        }

        self.contentView.addSubview(mTitleLabel)
        mTitleLabel.snp.makeConstraints {
            $0.left.equalTo(mIconButton.snp.right).offset(10)
            $0.top.equalToSuperview().offset(5)
            $0.bottom.equalToSuperview().offset(-5)
            $0.right.equalToSuperview().offset(-20)
        }
    }

    func _updateButton(model: ZXDataCellModel) {
        if model.value is Bool {
            mIconButton.backgroundColor = UIColor.zx.color(hexValue: 0xA03C78)
            mIconButton.setTitle("Bool", for: .normal)
        } else if model.value is NSNumber {
            mIconButton.backgroundColor = UIColor.zx.color(hexValue: 0xED8E7C)
            mIconButton.setTitle("Number", for: .normal)
        } else if model.value is String {
            mIconButton.backgroundColor = UIColor.zx.color(hexValue: 0x96BAFF)
            mIconButton.setTitle("String", for: .normal)
        } else if model.value is NSArray {
            mIconButton.backgroundColor = UIColor.zx.color(hexValue: 0x7C83FD)
            mIconButton.setTitle("Array", for: .normal)
        } else if model.value is NSDictionary {
            mIconButton.backgroundColor = UIColor.zx.color(hexValue: 0x88FFF7)
            mIconButton.setTitle("Dictionary", for: .normal)
        } else {
            mIconButton.setTitle("\(type(of: model.value))", for: .normal)
        }
    }
}
