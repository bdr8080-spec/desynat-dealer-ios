//
//  ChangeLanguageViewController.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 24/03/26.
//

import UIKit

class ChangeLanguageViewController: UIViewController {

    // MARK: - IBOutlet's
    @IBOutlet weak var arabicView: CustomView!
    @IBOutlet weak var englishView: CustomView!
    @IBOutlet weak var imgArabic: UIImageView!
    @IBOutlet weak var imgEnglish: UIImageView!
    
    // MARK: - Property Decalaration
    var selectedLanguage: Languages = .en
    var comingFromDashboard: Bool = false
    var hasActionPermission: Bool = false
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        LocationManager.sharedInstance.startUpdatingLocation()
        selectedLanguage = AppLanguageManager.shared.currentLanguage
        selectLanguage(isEnglishSelected: selectedLanguage != .ar)
    }
    
    // MARK: - Button's Action
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
    
    @IBAction func btnTapSave(_ sender: Any) {
        if let savedUser: User = kSharedUserDefaults.retrieveModelFor(key: .user, model: User.self) {
            if savedUser.type == "1" {
                self.getStaffDetails(userData: savedUser)
            } else {
                kSharedSceneDelegate.navigateToDealerHomeVc()
            }
        }
    }
    func getStaffDetails(userData: User) {
        if kSharedUserDefaults.isSubAdminUserHasDashboardAccess() {
            kSharedSceneDelegate.navigateToDashboardHomeVc()
        } else {
            kSharedSceneDelegate.navigateToSideMenuVc()
        }
    }
    
    private func selectLanguage(isEnglishSelected: Bool) {
        let selectedColor = UIColor(named: "darkBrown")?.cgColor
        let deselectedColor = UIColor.lightGray.cgColor
        englishView.layer.borderColor = isEnglishSelected ? selectedColor : deselectedColor
        imgEnglish.image = UIImage(named: isEnglishSelected ? "radioSelected" : "radioUnselected")
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
        let nextVC = ChangeLanguageViewController.instantiate(fromAppStoryboard: .NotificationAndSubscribtion)
        self.navigationController?.setViewControllers([nextVC], animated: false)
    }
    
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

//enum ComingReasonAtChangeLanguageScreen {
//    case fromNormalUserDashboard
//}

