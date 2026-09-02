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
    @IBOutlet weak var lblDesclaimer: UILabel!
    
    var comingFirstTime: Bool = true
    var selectedLanguage: Languages = .ar
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LocationManager.sharedInstance.startUpdatingLocation()
        let isOnBoardingChecked = UserDefaults.standard.string(forKey:"isOnBoardingChecked")
        if isOnBoardingChecked == "true" {
            comingFirstTime = false
        } else {
            comingFirstTime = true
        }
        self.lblDesclaimer.text = "Choose the language and continue to get the experience the app in your preferred language.".localiz()
        selectedLanguage = AppLanguageManager.shared.currentLanguage
        selectLanguage(isEnglishSelected: selectedLanguage != .ar)
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
    private func selectLanguage(isEnglishSelected: Bool) {
        let selectedColor = UIColor(named: "darkBrown")?.cgColor
        let deselectedColor = UIColor.lightGray.cgColor
        
        // English
        englishView.layer.borderColor = isEnglishSelected ? selectedColor : deselectedColor
        imgEnglish.image = UIImage(named: isEnglishSelected ? "radioSelected" : "radioUnselected")
        
        // Arabic
        arabicView.layer.borderColor = isEnglishSelected ? deselectedColor : selectedColor
        imgArabic.image = UIImage(named: isEnglishSelected ? "radioUnselected" : "radioSelected")
    }
    
    private func applyLanguageChange() {
        AppLanguageManager.shared.setLanguage(language: selectedLanguage)
        if selectedLanguage == .ar {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        } else {
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
        refreshUI()
    }
    
    private func refreshUI() {
        let nextVC = SelectLanguageViewController.instantiate(fromAppStoryboard: .Main)
        self.navigationController?.setViewControllers([nextVC], animated: false)
    }
    @IBAction func btnSelectLanguage(_ sender: UIButton) {
        if sender.tag == 0 {
            selectedLanguage = .en
            selectLanguage(isEnglishSelected: true)
        } else {
            selectedLanguage = .ar
            selectLanguage(isEnglishSelected: false)
        }
        applyLanguageChange()
    }
    
    @IBAction func btnTapContinue(_ sender: Any) {
        AppLanguageManager.shared.setLanguage(language: selectedLanguage)
        if comingFirstTime {
//            let vc = WelcomeScreenViewController.instantiate(fromAppStoryboard: .Main)
//            self.navigationController?.pushViewController(vc, animated: true)
            let vc = LoginViewController.instantiate(fromAppStoryboard: .Main)
            self.navigationController?.pushViewController(vc, animated: true)
            UserDefaults.standard.setValue("true", forKey: "isOnBoardingChecked")
        } else {
            kSharedSceneDelegate.navigateToLoginVC()
        }
    }
}
