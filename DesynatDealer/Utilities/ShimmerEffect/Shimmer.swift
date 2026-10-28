//
//  Shimmer.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 09/02/26.
//




import UIView_Shimmer
import UIKit
import Foundation
import SVProgressHUD

extension UILabel: @retroactive ShimmeringViewProtocol { }
extension UITextField: @retroactive ShimmeringViewProtocol { }
extension UITextView: @retroactive ShimmeringViewProtocol { }
extension UISwitch: @retroactive ShimmeringViewProtocol { }
extension UIProgressView: @retroactive ShimmeringViewProtocol { }
extension UIStepper: @retroactive ShimmeringViewProtocol { }
extension UISlider: @retroactive ShimmeringViewProtocol { }
extension UIImageView: @retroactive ShimmeringViewProtocol { }

class Shimmer: NSObject {

    static let shared = Shimmer()
    func show(show: Bool) {

        DispatchQueue.main.async {

            if let vc = UIApplication.shared.topViewController(),
               let view = vc.view as UIView? {

                view.setTemplateWithSubviews(show)

            } else {

                if show {
                    SVProgressHUD.setDefaultMaskType(.none)
                    SVProgressHUD.setDefaultStyle(.custom)
                    SVProgressHUD.setForegroundColor(.darkBrown)
                    SVProgressHUD.setBackgroundColor(.white)
                    SVProgressHUD.show()
                } else {
                    SVProgressHUD.dismiss()
                }
            }
        }
    }

}
