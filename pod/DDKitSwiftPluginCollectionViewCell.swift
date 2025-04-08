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
        self.contentView.addSubview(mContentView)
        mContentView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 13).isActive = true
        mContentView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        mContentView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        mContentView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        mContentView.addSubview(mIconImageView)
        mIconImageView.centerXAnchor.constraint(equalTo: self.mContentView.centerXAnchor).isActive = true
        mIconImageView.centerYAnchor.constraint(equalTo: self.mContentView.centerYAnchor).isActive = true
        mIconImageView.widthAnchor.constraint(equalToConstant: 23).isActive = true
        mIconImageView.heightAnchor.constraint(equalToConstant: 23).isActive = true

        mContentView.addSubview(mContentLabel)
        mContentLabel.topAnchor.constraint(equalTo: self.mContentView.topAnchor).isActive = true
        mContentLabel.bottomAnchor.constraint(equalTo: self.mContentView.bottomAnchor).isActive = true
        mContentLabel.leftAnchor.constraint(equalTo: self.mContentView.leftAnchor).isActive = true
        mContentLabel.rightAnchor.constraint(equalTo: self.mContentView.rightAnchor).isActive = true
        
        self.contentView.addSubview(mStatusView)
        mStatusView.topAnchor.constraint(equalTo: self.mContentView.topAnchor, constant: -2).isActive = true
        mStatusView.leftAnchor.constraint(equalTo: self.mContentView.leftAnchor, constant: -2).isActive = true
        mStatusView.widthAnchor.constraint(equalToConstant: 10).isActive = true
        mStatusView.heightAnchor.constraint(equalToConstant: 10).isActive = true


        self.contentView.addSubview(mTitleLabel)
        mTitleLabel.topAnchor.constraint(equalTo: self.mContentView.bottomAnchor, constant: 4).isActive = true
        mTitleLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 10).isActive = true
        mTitleLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -10).isActive = true
    }

    func updateUI(plugin: DDKitSwiftPluginProtocol, config: DDPluginItemConfig) {
        mTitleLabel.text = plugin.pluginTitle
        mStatusView.isHidden = !plugin.isRunning
        
        self.mContentView.backgroundColor = UIColor.dd.color(hexValue: 0x171619)
        switch config {
        case .default:
            self.mContentLabel.isHidden = true
            self.mIconImageView.isHidden = false
            self.mIconImageView.image = plugin.pluginIcon
        case .text(let title, let backgroundColor):
            self.mContentLabel.isHidden = false
            self.mIconImageView.isHidden = true
            self.mContentView.backgroundColor = backgroundColor
            self.mContentLabel.attributedText = title
        case .image(let image):
            self.mContentLabel.isHidden = true
            self.mIconImageView.isHidden = false
            self.mIconImageView.image = image
        }
    }

    //MARK: UI
    lazy var mContentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.dd.color(hexValue: 0x171619)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 25
        view.layer.borderWidth = 3.5
        view.layer.borderColor = UIColor.dd.color(hexValue: 0xd8e3e7).cgColor
        return view
    }()
    lazy var mIconImageView: UIImageView = {
        let tImageView = UIImageView()
        tImageView.translatesAutoresizingMaskIntoConstraints = false
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
        tLabel.textColor = UIColor.dd.color(hexValue: 0x1a1a1a)
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
