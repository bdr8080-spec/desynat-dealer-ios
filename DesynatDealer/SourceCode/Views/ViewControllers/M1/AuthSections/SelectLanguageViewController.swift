//
//  SelectLanguageViewController.swift
//  DesynatUser
//
//  Created by Rakhi Kumari on 22/10/25.
//

import UIKit

class SelectLanguageViewController: UIViewController {

    @IBOutlet weak var arabicView: CustomView!
    @IBOutlet weak var englishView: CustomView!
    @IBOutlet weak var imgArabic: UIImageView!
    @IBOutlet weak var imgEnglish: UIImageView!
    
    var comingFirstTime: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LocationManager.sharedInstance.startUpdatingLocation()
        let isOnBoardingChecked = UserDefaults.standard.string(forKey:"isOnBoardingChecked")
        if isOnBoardingChecked == "true" {
            comingFirstTime = false
        } else {
            comingFirstTime = true
        }
    }
    
    private func showNotificationPermission() {
        let vc = NotificationPermissionViewController.instantiate(fromAppStoryboard: .Main)
        vc.onPermissionCompletion = { [weak self] in
            self?.showMediaPermission()
        }
        self.present(vc, animated: true)
    }

    private func showMediaPermission() {
        let vc = MediaPermissionViewController.instantiate(fromAppStoryboard: .Main)
        vc.onPermissionCompletion = {
            print("All permissions done")
        }
        self.present(vc, animated: true)
    }

    
    @IBAction func btnSelectLanguage(_ sender: UIButton) {
        if sender.tag == 0 {
            imgArabic.image = UIImage(named: "radioUnselected")
            imgEnglish.image = UIImage(named: "radioSelected")
            arabicView.layer.borderColor = UIColor.lightGray.cgColor
            englishView.layer.borderColor = UIColor(named: "darkBrown")?.cgColor
        } else {
            imgArabic.image = UIImage(named: "radioSelected")
            imgEnglish.image = UIImage(named: "radioUnselected")
            arabicView.layer.borderColor = UIColor(named: "darkBrown")?.cgColor
            englishView.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    
    @IBAction func btnTapContinue(_ sender: Any) {
        if comingFirstTime {
            let vc = WelcomeScreenViewController.instantiate(fromAppStoryboard: .Main)
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            kSharedSceneDelegate.navigateToLoginVC()
        }
    }

}
