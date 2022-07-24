//
//  ViewController.swift
//  ZXKitSwiftDemo
//
//  Created by Damon on 2021/4/26.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.createUI()
    }

    func createUI() {
        self.view.backgroundColor = UIColor.white
        let button = UIButton(frame: CGRect(x: (UIScreen.main.bounds.size.width - 100)/2.0, y: UIScreen.main.bounds.size.height - 200, width: 100, height: 40))
        button.setTitle("打开工具", for: .normal)
        button.setTitleColor(UIColor.zx.color(hexValue: 0xffffff), for: .normal)
        button.backgroundColor = UIColor.blue
        self.view.addSubview(button)
        button.addTarget(self, action: #selector(_click), for: .touchUpInside)
    }

    @objc func _click() {
        ZXKit.show()
    }
}

