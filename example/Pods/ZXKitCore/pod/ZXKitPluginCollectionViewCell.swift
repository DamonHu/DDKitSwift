//
//  ZXKitPluginCollectionViewCell.swift
//  ZXKit
//
//  Created by Damon on 2021/4/23.
//

import UIKit

class ZXKitPluginCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func createUI() {
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.zx.color(hexValue: 0xeeeeee, alpha: 0.7).cgColor
        self.contentView.addSubview(mImageView)
        mImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 13).isActive = true
        mImageView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        mImageView.widthAnchor.constraint(equalToConstant: 44).isActive = true
        mImageView.heightAnchor.constraint(equalToConstant: 44).isActive = true

        self.contentView.addSubview(mStatusView)
        mStatusView.topAnchor.constraint(equalTo: self.mImageView.topAnchor, constant: -5).isActive = true
        mStatusView.leftAnchor.constraint(equalTo: self.mImageView.leftAnchor, constant: -5).isActive = true
        mStatusView.widthAnchor.constraint(equalToConstant: 10).isActive = true
        mStatusView.heightAnchor.constraint(equalToConstant: 10).isActive = true


        self.contentView.addSubview(mTitleLabel)
        mTitleLabel.topAnchor.constraint(equalTo: self.mImageView.bottomAnchor, constant: 5).isActive = true
        mTitleLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 10).isActive = true
        mTitleLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -10).isActive = true
    }

    func updateUI(plugin: ZXKitPluginProtocol) {
        mImageView.image = plugin.pluginIcon
        mTitleLabel.text = plugin.pluginTitle
        mStatusView.isHidden = !plugin.isRunning
    }

    //MARK: UI
    lazy var mImageView: UIImageView = {
        let tImageView = UIImageView()
        tImageView.translatesAutoresizingMaskIntoConstraints = false
        tImageView.backgroundColor = UIColor(displayP3Red: 62.0/255.0, green: 183.0/255.0, blue: 142.0/255.0, alpha: 1.0)
        tImageView.layer.masksToBounds = true
        tImageView.layer.cornerRadius = 22
        tImageView.layer.borderWidth = 3
        tImageView.layer.borderColor = UIColor.zx.color(hexValue: 0xd8e3e7).cgColor
        return tImageView
    }()

    lazy var mTitleLabel: UILabel = {
        let tLabel = UILabel()
        tLabel.translatesAutoresizingMaskIntoConstraints = false
        tLabel.numberOfLines = 2
        tLabel.textAlignment = .center
        tLabel.font = .systemFont(ofSize: 13, weight: .medium)
        tLabel.textColor = UIColor.zx.color(hexValue: 0x666666)
        return tLabel
    }()

    lazy var mStatusView: UIView = {
        let tView = UIView()
        tView.translatesAutoresizingMaskIntoConstraints = false
        tView.isHidden = true
        tView.backgroundColor = UIColor.zx.color(hexValue: 0x81b214)
        tView.layer.masksToBounds = true
        tView.layer.cornerRadius = 5
        return tView
    }()
}
