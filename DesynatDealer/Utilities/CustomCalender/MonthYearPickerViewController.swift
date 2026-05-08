//
//  MonthYearPickerViewController.swift
//  DesynatDealer
//
//  Created by fluper_mac3 on 26/02/26.
//


//import UIKit
//
//class MonthYearPickerViewController: UIViewController {
//
//    var onDateSelected: ((Date) -> Void)?
//
//    private let picker = UIPickerView()
//    private let months = Calendar.current.monthSymbols
//    private let years: [Int] = Array(Calendar.current.component(.year, from: Date())...2050)
//    private let currentYear = Calendar.current.component(.year, from: Date())
//    private let currentMonth = Calendar.current.component(.month, from: Date())
//    private var selectedMonth = Calendar.current.component(.month, from: Date()) - 1
//    private var selectedYear = Calendar.current.component(.year, from: Date())
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .white
//        setupUI()
//    }
//
//    private func setupUI() {
//
//        picker.delegate = self
//        picker.dataSource = self
//        picker.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(picker)
//
//        let doneButton = UIButton(type: .system)
//        doneButton.setTitle("Done".localiz(), for: .normal)
//        doneButton.titleLabel?.font = .boldSystemFont(ofSize: 17)
//        doneButton.addTarget(self, action: #selector(doneTapped), for: .touchUpInside)
//        doneButton.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(doneButton)
//
//        NSLayoutConstraint.activate([
//
//            // Attach directly to top (not safe area)
//            doneButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 6),
//            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
//            doneButton.heightAnchor.constraint(equalToConstant: 28),
//
//            picker.topAnchor.constraint(equalTo: doneButton.bottomAnchor, constant: 2),
//            picker.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            picker.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            picker.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        ])
//    }
//
//    @objc private func doneTapped() {
//        let components = DateComponents(
//            year: years[picker.selectedRow(inComponent: 1)],
//            month: picker.selectedRow(inComponent: 0) + 1
//        )
//
//        if let date = Calendar.current.date(from: components) {
//            onDateSelected?(date)
//        }
//
//        dismiss(animated: true)
//    }
//}
//
//extension MonthYearPickerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
//
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 2
//    }
//
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return component == 0 ? months.count : years.count
//    }
//
//    func pickerView(_ pickerView: UIPickerView,
//                    titleForRow row: Int,
//                    forComponent component: Int) -> String? {
//        return component == 0 ? months[row] : "\(years[row])"
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//
//        let selectedYear = years[pickerView.selectedRow(inComponent: 1)]
//        let selectedMonth = pickerView.selectedRow(inComponent: 0) + 1
//
//        // If current year, block past months
//        if selectedYear == currentYear && selectedMonth < currentMonth {
//            pickerView.selectRow(currentMonth - 1, inComponent: 0, animated: true)
//        }
//    }
//}

import UIKit

class MonthYearPickerViewController: UIViewController {

    var onDateSelected: ((Date) -> Void)?

    private let picker = UIPickerView()
    
    private var months: [String] = []
    private let years: [Int] = Array(Calendar.current.component(.year, from: Date())...2050)
    
    private let currentYear = Calendar.current.component(.year, from: Date())
    private let currentMonth = Calendar.current.component(.month, from: Date())
    
    private var selectedMonth = Calendar.current.component(.month, from: Date()) - 1
    private var selectedYear = Calendar.current.component(.year, from: Date())

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMonths()           // ← Important
        view.backgroundColor = .white
        setupUI()
        setupInitialSelection()
    }
    
    // MARK: - Locale Aware Months
    private func setupMonths() {
        let formatter = DateFormatter()
        
        if AppLanguageManager.shared.currentLanguage == .ar {
            formatter.locale = Locale(identifier: "ar")
        } else {
            formatter.locale = Locale(identifier: "en_US_POSIX")
        }
        
        months = formatter.monthSymbols  // This will now return Arabic month names
    }

    private func setupUI() {
        picker.delegate = self
        picker.dataSource = self
        picker.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(picker)

        let doneButton = UIButton(type: .system)
        doneButton.setTitle("Done".localiz(), for: .normal)
        doneButton.titleLabel?.font = .boldSystemFont(ofSize: 17)
        doneButton.addTarget(self, action: #selector(doneTapped), for: .touchUpInside)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(doneButton)

        NSLayoutConstraint.activate([
            doneButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 6),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            doneButton.heightAnchor.constraint(equalToConstant: 28),

            picker.topAnchor.constraint(equalTo: doneButton.bottomAnchor, constant: 2),
            picker.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            picker.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            picker.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupInitialSelection() {
        picker.selectRow(selectedMonth, inComponent: 0, animated: false)
        // Find current year index
        if let yearIndex = years.firstIndex(of: selectedYear) {
            picker.selectRow(yearIndex, inComponent: 1, animated: false)
        }
    }

    @objc private func doneTapped() {
        let components = DateComponents(
            year: years[picker.selectedRow(inComponent: 1)],
            month: picker.selectedRow(inComponent: 0) + 1
        )

        if let date = Calendar.current.date(from: components) {
            onDateSelected?(date)
        }
        dismiss(animated: true)
    }
}

// MARK: - Picker Delegate & DataSource
extension MonthYearPickerViewController: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return component == 0 ? months.count : years.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return months[row]          // Now supports Arabic
        } else {
            return "\(years[row])"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // Block past months in current year
        let selectedMonthIndex = pickerView.selectedRow(inComponent: 0)
        let selectedYearIndex = pickerView.selectedRow(inComponent: 1)
        
        if years[selectedYearIndex] == currentYear && (selectedMonthIndex + 1) < currentMonth {
            pickerView.selectRow(currentMonth - 1, inComponent: 0, animated: true)
        }
    }
}
