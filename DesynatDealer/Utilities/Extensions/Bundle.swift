//
//  Bundle.swift
//  ChorApp
//
//  Created by Developer on 07/12/23.
//

import Foundation

extension Bundle {
    ///Application Name
    var ApplicationName: String? {
        return infoDictionary?["CFBundleDisplayName"] as? String ?? infoDictionary?["CFBundleName"] as? String
    }
    
    ///Release Version Number
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    ///Build Version Number
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}
