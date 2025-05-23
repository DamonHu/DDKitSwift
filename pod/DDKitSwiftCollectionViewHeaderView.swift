//
//  DDKitSwiftCollectionViewHeaderView.swift
//  DDKitSwift
//
//  Created by Damon on 2021/4/23.
//

import UIKit

class DDKitSwiftCollectionViewHeaderView: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func createUI() {
        self.contentView.backgroundColor = DDKitSwift.UIConfig.collectionViewTitleBackgroundColor
        self.contentView.addSubview(mTitleLabel)

        mTitleLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 20).isActive = true
        mTitleLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -20).isActive = true
        mTitleLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
    }

    func updateUI(title: String) {
        mTitleLabel.text = title
    }

    //MARK: UI
    lazy var mTitleLabel: UILabel = {
        let tLabel = UILabel()
        tLabel.translatesAutoresizingMaskIntoConstraints = false
        tLabel.numberOfLines = 2
        tLabel.textAlignment = .left
        tLabel.font = .systemFont(ofSize: 16, weight: .medium)
        tLabel.textColor = DDKitSwift.UIConfig.collectionViewTitleColor
        return tLabel
    }()
}
