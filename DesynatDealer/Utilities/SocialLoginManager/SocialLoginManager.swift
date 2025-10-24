//
//  SocialLoginManager.swift
//  DemoProject
//
//  Created by Rakhi Kumari on 22/09/25.
//

import Foundation
import GoogleSignIn
import AuthenticationServices
import UIKit

// MARK: - Social Login Manager
class SocialLoginManager: NSObject {
    
    // MARK: - Singleton
    static let shared = SocialLoginManager()
    
    // MARK: - Typealiases
    public typealias SignupCompletion = ([String: Any]?, Error?) -> Void
    
    // MARK: - Properties
    public var appleSignUpStatus: SignupCompletion?
    
    private override init() {
        super.init()
    }
}

// MARK: - Google Sign-In
extension SocialLoginManager {
    
    public func signupWithGoogle(_ vc: UIViewController, completion: @escaping SignupCompletion) {
        GIDSignIn.sharedInstance.signIn(withPresenting: vc) { signInResult, error in
            if let error = error {
                completion(nil, error)
                return
            }
            guard let result = signInResult else {
                completion(nil, nil)
                return
            }
            
            let finalDict: [String: Any] = [
                "social_id": result.user.userID ?? "",
                "social_login_type": "google",
                "email": result.user.profile?.email ?? ""
            ]
            completion(finalDict, nil)
        }
    }
}

// MARK: - Apple Sign-In
extension SocialLoginManager: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    public func signupWithApple(_ vc: UIViewController) {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    // MARK: ASAuthorizationControllerDelegate
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let finalDict: [String: Any] = [
                "social_id": appleIDCredential.user,
                "name": appleIDCredential.fullName?.givenName ?? "",
                "email": appleIDCredential.email ?? "",
                "social_login_type": "apple"
            ]
            self.appleSignUpStatus?(finalDict, nil)
        } else {
            self.appleSignUpStatus?(nil, nil)
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Sign in with Apple failed: \(error.localizedDescription)")
        self.appleSignUpStatus?(nil, error)
    }
    
    // MARK: ASAuthorizationControllerPresentationContextProviding
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first { $0.isKeyWindow } ?? ASPresentationAnchor()
        } else {
            return UIApplication.shared.keyWindow ?? ASPresentationAnchor()
        }
    }
}

/// usuage

//SocialLoginManager.shared.signupWithGoogle(self) { result, error in
//    if let error = error {
//        print("Google Sign-In error: \(error.localizedDescription)")
//    } else if let userInfo = result {
//        print("Google User info: \(userInfo)")
//    }
//}


//SocialLoginManager.shared.appleSignUpStatus = { result, error in
//    if let error = error {
//        print("Apple Sign-In error: \(error.localizedDescription)")
//    } else if let userInfo = result {
//        print("Apple User info: \(userInfo)")
//    }
//}
//
//// Call sign-in
//SocialLoginManager.shared.signupWithApple(self)
