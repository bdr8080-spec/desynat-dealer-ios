//
//  AppLanguage.swift
//  DesynatDealer
//
//  Created by fluper_mac3 on 30/01/26.
//


import Foundation

//enum AppLanguage {
//    case english
//    case arabic
//
//    static var current: AppLanguage {
//        let lang = UserDefaults.standard.string(forKey: "AppLanguage") ?? "en"
//        return lang == "ar" ? .arabic : .english
//    }
//}

//class LanguageManager {
//
//    static var currentLanguageCode: String {
//        return UserDefaults.standard.string(forKey: "AppLanguage") ?? "en"
//    }
//
//    static var isArabic: Bool {
//        return currentLanguageCode == "ar"
//    }
//}


class TranslationService {

    private static let apiKey = "AIzaSyB4mtISC8aJQl8DkwEd8DAIpBvuHCleO7s"

    static func translateToArabic(_ text: String, completion: @escaping (String) -> Void) {

        // If empty or already Arabic → return
        guard !text.isEmpty else {
            completion(text)
            return
        }

        let urlString = "https://translation.googleapis.com/language/translate/v2?key=\(apiKey)"
        guard let url = URL(string: urlString) else {
            completion(text)
            return
        }

        let body: [String: Any] = [
            "q": text,
            "source": "en",
            "target": "ar",
            "format": "text"
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, _, error in

            guard error == nil,
                  let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let dataDict = json["data"] as? [String: Any],
                  let translations = dataDict["translations"] as? [[String: Any]],
                  let translatedText = translations.first?["translatedText"] as? String
            else {
                completion(text)   // fallback
                return
            }

            completion(translatedText)

        }.resume()
    }
}
