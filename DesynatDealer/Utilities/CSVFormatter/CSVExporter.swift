//
//  CSVExporter.swift
//  DesynatAdmin
//
//  Created by fluper_mac2 on 05/05/26.
//


import UIKit

class CSVExporter {
    static func exportCSV(fileName: String, csvString: String, vc: UIViewController) {
        let path = FileManager.default.temporaryDirectory.appendingPathComponent("\(fileName).csv")
        do {
            try csvString.write(to: path, atomically: true, encoding: .utf8)
            let activityVC = UIActivityViewController(activityItems: [path], applicationActivities: nil)
            if let popover = activityVC.popoverPresentationController {
                popover.sourceView = vc.view
            }
            vc.present(activityVC, animated: true)
        } catch {
            print("CSV Export Error: \(error)")
        }
    }
}
