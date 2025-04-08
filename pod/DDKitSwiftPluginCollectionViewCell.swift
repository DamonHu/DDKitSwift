//
//  DDKitSwiftPluginCollectionViewCell.swift
//  DDKitSwift
//
//  Created by Damon on 2021/4/23.
//

import UIKit

class DDKitSwiftPluginCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func createUI() {
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.dd.color(hexValue: 0xeeeeee, alpha: 0.7).cgColor
        self.contentView.addSubview(mIconImageView)
        mIconImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 13).isActive = true
        mIconImageView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        mIconImageView.widthAnchor.constraint(equalToConstant: 44).isActive = true
        mIconImageView.heightAnchor.constraint(equalToConstant: 44).isActive = true

        self.contentView.addSubview(mContentLabel)
        mContentLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 13).isActive = true
        mContentLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        mContentLabel.widthAnchor.constraint(equalToConstant: 44).isActive = true
        mContentLabel.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        self.contentView.addSubview(mStatusView)
        mStatusView.topAnchor.constraint(equalTo: self.mIconImageView.topAnchor, constant: -5).isActive = true
        mStatusView.leftAnchor.constraint(equalTo: self.mIconImageView.leftAnchor, constant: -5).isActive = true
        mStatusView.widthAnchor.constraint(equalToConstant: 10).isActive = true
        mStatusView.heightAnchor.constraint(equalToConstant: 10).isActive = true


        self.contentView.addSubview(mTitleLabel)
        mTitleLabel.topAnchor.constraint(equalTo: self.mIconImageView.bottomAnchor, constant: 5).isActive = true
        mTitleLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 10).isActive = true
        mTitleLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -10).isActive = true
    }

    func updateUI(plugin: DDKitSwiftPluginProtocol, config: DDPluginItemConfig) {
        mTitleLabel.text = plugin.pluginTitle
        mStatusView.isHidden = !plugin.isRunning
        
        switch config {
        case .default:
            self.mContentLabel.isHidden = true
            self.mIconImageView.isHidden = false
            self.mIconImageView.image = plugin.pluginIcon
        case .text(let title, let backgroundColor):
            self.mContentLabel.isHidden = false
            self.mIconImageView.isHidden = true
            self.mContentLabel.backgroundColor = backgroundColor
            self.mContentLabel.attributedText = title
        case .image(let image):
            self.mContentLabel.isHidden = true
            self.mIconImageView.isHidden = false
            self.mIconImageView.image = image
        }
    }

    //MARK: UI
    lazy var mIconImageView: UIImageView = {
        let tImageView = UIImageView()
        tImageView.translatesAutoresizingMaskIntoConstraints = false
        tImageView.backgroundColor = UIColor.dd.color(hexValue: 0x171619)
        tImageView.layer.masksToBounds = true
        tImageView.layer.cornerRadius = 22
        tImageView.layer.borderWidth = 3
        tImageView.layer.borderColor = UIColor.dd.color(hexValue: 0xd8e3e7).cgColor
        return tImageView
    }()
    
    lazy var mContentLabel: UILabel = {
        let tLabel = UILabel()
        tLabel.isHidden = true
        tLabel.translatesAutoresizingMaskIntoConstraints = false
        tLabel.numberOfLines = 2
        tLabel.textAlignment = .center
        tLabel.font = .systemFont(ofSize: 13, weight: .medium)
        tLabel.textColor = UIColor.dd.color(hexValue: 0x333333)
        tLabel.layer.masksToBounds = true
        tLabel.layer.cornerRadius = 22
        tLabel.layer.borderWidth = 3
        tLabel.layer.borderColor = UIColor.dd.color(hexValue: 0xd8e3e7).cgColor
        return tLabel
    }()
    

    lazy var mTitleLabel: UILabel = {
        let tLabel = UILabel()
        tLabel.translatesAutoresizingMaskIntoConstraints = false
        tLabel.numberOfLines = 2
        tLabel.textAlignment = .center
        tLabel.font = .systemFont(ofSize: 13, weight: .medium)
        tLabel.textColor = UIColor.dd.color(hexValue: 0x666666)
        return tLabel
    }()

    lazy var mStatusView: UIView = {
        let tView = UIView()
        tView.translatesAutoresizingMaskIntoConstraints = false
        tView.isHidden = true
        tView.backgroundColor = UIColor.dd.color(hexValue: 0x81b214)
        tView.layer.masksToBounds = true
        tView.layer.cornerRadius = 5
        return tView
    }()
}
