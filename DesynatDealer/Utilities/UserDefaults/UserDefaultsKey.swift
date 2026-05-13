//
//  UserDefaultsKey.swift
//  DemoProject
//
//  Created by Rakhi Kumari on 22/09/25.
//


import Foundation
let KSubAdminHasDashboardAccess = "isSubAdminHasDashboardAccess"
let KHasActionDashboardAccess   = "isHasActionDashboardAccess"
/// User For User Default. Add Desired Key to save associated value in user default
enum UserDefaultsKey : String {
    case deviceToken
    case accessToken
    case userLocation
    case user
    case isSkip
    case documents
    case address
    case selectedLanguage
    case defaultLanguage
    case language
    case sessionToken
    case storeAvailabilityStatus
}

extension UserDefaults {
    
    func isOnBoardingChecked() -> Bool {
        return self.bool(forKey: kisOnBoardingChecked)
    }
    
    func setSubAdminUserHasDashboardAccess(hasDashboardAccess: Bool) {
        self.set(hasDashboardAccess, forKey: KSubAdminHasDashboardAccess)
        self.synchronize()
    }
    
    func setSubAdminActionDashboardAccess(hasActionDashboardAccess: Bool) {
        self.set(hasActionDashboardAccess, forKey: KHasActionDashboardAccess)
        self.synchronize()
    }
    
    func saveValue<T>(Key: UserDefaultsKey, value:T) {
        self.set(value, forKey: Key.rawValue)
        self.synchronize()
    }
    func getValue<T>(Key: UserDefaultsKey) -> T? {
        return self.value(forKey: Key.rawValue) as? T
    }
    
    func getStringFor(key:UserDefaultsKey) -> String? {
        return self.string(forKey: key.rawValue)
    }
    
    func saveIntFor(key:UserDefaultsKey, value:Int?) {
        self.saveValue(value: value, for: key)
    }
    
    func getIntFor(key:UserDefaultsKey) -> Int? {
        return self.integer(forKey: key.rawValue)
    }
    
    func retrieveModelFor<T: Decodable>(key: UserDefaultsKey, model: T.Type) -> T? {
        guard let data = self.data(forKey: key.rawValue) else { return nil }
        do {
            let decodedObject = try JSONDecoder().decode(model, from: data)
            return decodedObject
        } catch {
//            print("❌ Failed to decode model for key \(key.rawValue): \(error)")
            return nil
        }
    }
    
    func saveModelFor(key:UserDefaultsKey, value:Encodable) {
        if let encoded = try? JSONEncoder().encode(value) {
            self.set(encoded, forKey: key.rawValue)
            self.synchronize()
        }
    }
    
    func saveBoolFor(key:UserDefaultsKey, value:Bool) {
        self.saveValue(value: value, for: key)
    }
    
    private func saveValue(value:Any?, for Key:UserDefaultsKey) {
        self.set(value, forKey: Key.rawValue)
        self.synchronize()
    }
    
    func clearAllData(except:[UserDefaultsKey]) {
        let exceptKey = except.map({$0.rawValue})
        for (key, _) in self.dictionaryRepresentation() {
            if !exceptKey.contains(key) { self.removeObject(forKey: key) }
        }
        self.synchronize()
    }
    func clearData(key:UserDefaultsKey) {
        self.removeObject(forKey: key.rawValue)
        self.synchronize()
    }
    
    func getModelFor<T:Decodable>(key:UserDefaultsKey,
                                  model:T.Type,
                                  completion:@escaping(_ result:Result<T, UserDefaulError>) -> Void) {
        if let data = self.object(forKey: key.rawValue) as? Data {
            do {
                let response = try JSONDecoder().decode(model, from: data)
                completion(.success(response))
            } catch let err {
                printInConsole("Error Fetching model from user default\n\(err)")
                completion(.failure(.errorDecodingData))
            }
        } else {
            completion(.failure(.noDataFound))
        }
    }
    
    func isSubAdminUserHasDashboardAccess() -> Bool {
        return self.bool(forKey: KSubAdminHasDashboardAccess)
    }
    
    func isSubAdminHasActionDashboardAccess() -> Bool {
        return self.bool(forKey: KHasActionDashboardAccess)
    }
}

enum UserDefaulError: Error {
    case noDataFound
    case errorDecodingData
}

extension UserDefaulError : LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .noDataFound:
            return NSLocalizedString(AlertConstant.noDataFound.value().localiz(), comment: "")
        case .errorDecodingData:
            return NSLocalizedString(AlertConstant.unableToDecode.value().localiz(), comment: "")
        }
    }
}
