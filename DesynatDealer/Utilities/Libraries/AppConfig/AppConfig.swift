//
//  ApplicationConstant.swift
//  BasicSetupProject
//
//  Created by Developer on 02/12/23.
//

import Foundation

//This will be used to get the running environment of application

/*
 To make this work then add 'configuration' in info.Plist
 */

enum Environment: String { // 1
    case debug      = "Debug"
    case release    = "Release"
}

class BuildConfiguration { // 2
    static let shared = BuildConfiguration()
    
    var environment: Environment //Current Environment
    init() {
        let currentConfiguration = Bundle.main.object(forInfoDictionaryKey: "Configuration") as! String
        environment = Environment(rawValue: currentConfiguration)!
    }
}


/// Custom print Function
/// - Parameter object: pass your value
func printInConsole <T> (_ object: T) {
    if BuildConfiguration.shared.environment == .debug {
        print(object)
    }
}
