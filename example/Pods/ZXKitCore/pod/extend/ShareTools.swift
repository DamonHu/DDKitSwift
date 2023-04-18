//
//  ShareTools.swift
//  Nutrition
//
//  Created by Damon on 2021/11/11.
//

import UIKit
import ZXKitUtil

enum ShareType {
    case image(imageList: [UIImage])
    case url(image: UIImage?, text: String?, url: String)
    case file(url: URL)
}

enum ResultStatus {
    case success
    case fail
    case cancel
}

class ShareTools: NSObject {
    static let shared = ShareTools()
    private var shareActivityVC: UIActivityViewController?

    func share(type: ShareType, sourceView: UIView? = nil, complete: ((ResultStatus)->Void)?) {
        DispatchQueue.main.async {
            var activityItems = [Any]()
            switch type {
            case .image(let imageList):
                activityItems.append(contentsOf: imageList)
            case .url(let image, let text, let url):
                if let image = image {
                    activityItems.append(image)
                }
                if let text = text {
                    activityItems.append(text)
                }
                if let encode = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let encodeUrl = URL(string: encode) {
                    activityItems.append(encodeUrl)
                }
            case .file(let url):
                activityItems.append(url)
            }
            self.shareActivityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
            self.shareActivityVC!.completionWithItemsHandler = {(activityType, dissmiss, data, error) -> Void in
                if let complete = complete {
                    if error != nil {
                        complete(.fail)
                    } else {
                        complete(.success)
                    }
                }
            }
            let ipadView = sourceView ?? ZXKitUtil.shared.getCurrentVC()?.view
            self.shareActivityVC!.popoverPresentationController?.sourceView = ipadView
            self.shareActivityVC!.popoverPresentationController?.sourceRect = ipadView?.bounds ?? CGRect(x: 0, y: 0, width: UIScreenWidth, height: UIScreenHeight)
            
            ZXKitUtil.shared.getCurrentVC()?.present(self.shareActivityVC!, animated: true, completion: nil)
        }
    }
}
