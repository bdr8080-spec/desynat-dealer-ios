//
//  GlobalVariables.swift
//  ChorApp
//
//  Created by Navanindra Vats on 18/12/23.
//

import Foundation
import UIKit

let kSharedUserDefaults         = UserDefaults.standard
let kSharedAppDelegate          = UIApplication.shared.delegate as! AppDelegate
let kSharedSceneDelegate        = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
let kScreenWidth = UIScreen.main.bounds.size.width
let kScreenHeight = UIScreen.main.bounds.size.height
var sizesList: [SizeListDataModel] = []
//var globalWindow:UIWindow?


final class Global {
    static let shared = Global()
    private init() { 
        kSharedUserDefaults.getModelFor(key:.user, model: User.self, completion: { result in
            switch result {
            case .success(let success):
                self.user = success
            case .failure(let failure):
                print("User Not Found \(failure.localizedDescription)")
            }
        })
    }
    var user:User?
}

enum CURRENCY : String {
    case sign   = "€"
    case code   = "EURO"
}
