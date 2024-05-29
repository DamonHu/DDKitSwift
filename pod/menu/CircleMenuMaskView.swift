//
//  CircleMenuMaskView.swift
//  DDKitSwift
//
//  Created by Damon on 2023/4/13.
//

import UIKit

class CircleMenuMaskView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self._createUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: UI
    lazy var mImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    lazy var mMaskView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var mLabel: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = false
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

}

private extension CircleMenuMaskView {
    func _createUI() {
        self.addSubview(mImageView)
        mImageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        mImageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        mImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        mImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true

        self.addSubview(mMaskView)
        mMaskView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        mMaskView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        mMaskView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        mMaskView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true

        self.addSubview(mLabel)
        mLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        mLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        mLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        mLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
}
