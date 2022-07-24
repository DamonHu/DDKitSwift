//
//  ZXKitCollectionViewHeaderView.swift
//  ZXKit
//
//  Created by Damon on 2021/4/23.
//

import UIKit

class ZXKitCollectionViewHeaderView: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func createUI() {
        self.contentView.backgroundColor = ZXKit.UIConfig.collectionViewTitleBackgroundColor
        self.contentView.addSubview(mTitleLabel)
        mTitleLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.centerY.equalToSuperview()
        }
    }

    func updateUI(title: String) {
        mTitleLabel.text = title
    }

    //MARK: UI
    lazy var mTitleLabel: UILabel = {
        let tLabel = UILabel()
        tLabel.numberOfLines = 2
        tLabel.textAlignment = .left
        tLabel.font = .systemFont(ofSize: 18, weight: .medium)
        tLabel.textColor = ZXKit.UIConfig.collectionViewTitleColor
        return tLabel
    }()
}
