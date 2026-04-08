//
//  PDFViewerViewController.swift
//  DesynatDealer
//
//  Created by fluper_mac3 on 08/04/26.
//


import UIKit
import PDFKit

class PDFViewerViewController: UIViewController {

    var pdfURLString: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let pdfView = PDFView(frame: view.bounds)
        pdfView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        pdfView.autoScales = true
        view.addSubview(pdfView)
        
        if let urlString = pdfURLString, let url = URL(string: urlString) {
            if let document = PDFDocument(url: url) {
                pdfView.document = document
            } else {
                print("Failed to load PDF")
            }
        }
    }
}
