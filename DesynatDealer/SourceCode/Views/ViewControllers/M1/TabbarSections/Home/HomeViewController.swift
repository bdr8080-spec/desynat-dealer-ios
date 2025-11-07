//
//  HomeViewController.swift
//  DesynatUser
//
//  Created by Rakhi Kumari on 23/10/25.
//

import UIKit
import Charts
import DGCharts

class HomeViewController: UIViewController {

    @IBOutlet weak var btnToggle: UIButton!
    @IBOutlet weak var txtChooseFromDate: UITextField!
    @IBOutlet weak var txtChooseToDate: UITextField!
    @IBOutlet weak var btnToday: UIButton!
    @IBOutlet weak var btnThisWeek: UIButton!
    @IBOutlet weak var btnThisMonth: UIButton!
    @IBOutlet weak var lblTotalRevenue: CustomLabelFont!
    
    @IBOutlet weak var lblTotalProducts: CustomLabelFont!
    @IBOutlet weak var lblActiveProducts: CustomLabelFont!
    @IBOutlet weak var lblInActiveProducts: CustomLabelFont!
    
    @IBOutlet weak var lblTotalOrders: CustomLabelFont!
    @IBOutlet weak var lblNewOrders: CustomLabelFont!
    @IBOutlet weak var lblOngoingOrders: CustomLabelFont!
    @IBOutlet weak var lblCompletedOrders: CustomLabelFont!
    @IBOutlet weak var lblCancelledOrders: CustomLabelFont!
    
    @IBOutlet weak var lblTotalStaff: CustomLabelFont!
    @IBOutlet weak var lblActiveStaff: CustomLabelFont!
    @IBOutlet weak var lblInActiveStaff: CustomLabelFont!
    
    @IBOutlet weak var txtVisitorFromDate: UITextField!
    @IBOutlet weak var txtVisitorToDate: UITextField!
    
    @IBOutlet weak var btnTotalOrderConversion: UIButton!
    @IBOutlet weak var btnTotalCustomerVisits: UIButton!
    
    @IBOutlet weak var viewChart: UIView!
    
    
    
    let datePicker = UIDatePicker()
    private var activeTextField: UITextField?
    var isToggleOn: Bool = false
    var dateButtons: [UIButton] { [btnToday, btnThisWeek, btnThisMonth]}
    var statsButtons: [UIButton] { [btnTotalOrderConversion, btnTotalCustomerVisits]}
    var lineChartView = LineChartView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTextFields()
        setUpButtons()
        setUpChart()
    }
    
    private func setUpButtons() {
        btnToggle.setImage(UIImage(named: "toggle_off"), for: .normal)
        updateRadioSelection(for: dateButtons, selectedButton: btnToday)
        updateRadioSelection(for: statsButtons, selectedButton: btnTotalOrderConversion)
    }

    private func updateRadioSelection(for buttons: [UIButton], selectedButton: UIButton) {
        for button in buttons {
            if button == selectedButton {
                button.setImage(UIImage(named: "radio_select_brown"), for: .normal)
            } else {
                button.setImage(UIImage(named: "radio_unselect_brown"), for: .normal)
            }
        }
    }
    
    private func setUpChart() {
        // Add chart view to container
        lineChartView.frame = viewChart.bounds
        lineChartView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewChart.addSubview(lineChartView)
        
        // Sample Data
        let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep"]
        let values: [Double] = [50, 200, 100, 400, 300, 220, 180, 250, 320]
        
        var entries: [ChartDataEntry] = []
        for (index, value) in values.enumerated() {
            entries.append(ChartDataEntry(x: Double(index), y: value))
        }
        
        // Create dataset
        let set = LineChartDataSet(entries: entries, label: "")
        set.mode = .linear
        set.lineWidth = 1.2
        set.circleRadius = 5
        set.circleHoleRadius = 2
        set.setColor(.black)
        set.circleColors = [.systemOrange]
        set.circleHoleColor = .white
        set.valueTextColor = .clear // hide value labels
        
        // Create data object
        let data = LineChartData(dataSet: set)
        lineChartView.data = data
        
        // Customize X-axis
        lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: months)
        lineChartView.xAxis.granularity = 1
        lineChartView.xAxis.labelPosition = .bottom
        lineChartView.xAxis.labelFont = .systemFont(ofSize: 10)
        
        // Customize Y-axis
        lineChartView.leftAxis.labelFont = .systemFont(ofSize: 10)
        lineChartView.rightAxis.enabled = false
        
        // Remove gridlines background
        lineChartView.legend.enabled = false
        lineChartView.chartDescription.enabled = false
        lineChartView.xAxis.drawGridLinesEnabled = false
        lineChartView.leftAxis.drawGridLinesEnabled = true
        
        // Optional: smooth animation
        lineChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
    }


    @IBAction func btnTapLogout(_ sender: UIButton) {
        kSharedSceneDelegate.navigateToSelectLanguage()
        UserDefaults.standard.setValue("No", forKey:"isLogin")
    }
    
    @IBAction func btnDesynatShowDesign(_ sender: Any) {
    }
    
    @IBAction func btnChat(_ sender: Any) {
    }
    
    @IBAction func btnNotification(_ sender: Any) {
    }
    
    @IBAction func btnProfile(_ sender: Any) {
    }
    
    @IBAction func btnTapToggle(_ sender: Any) {
        isToggleOn.toggle() // switch state
        let imageName = isToggleOn ? "toggle_on" : "toggle_off"
        btnToggle.setImage(UIImage(named: imageName), for: .normal)
    }
    
    @IBAction func btnSelectDate(_ sender: UIButton) {
        updateRadioSelection(for: dateButtons, selectedButton: sender)
    }
    
    @IBAction func btnChooseVisits(_ sender: UIButton) {
        updateRadioSelection(for: statsButtons, selectedButton: sender)
    }
    
    

}


extension HomeViewController {
    private func setUpTextFields() {
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        datePicker.minimumDate = nil
        datePicker.backgroundColor = .white
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneDatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker))
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        
        let textFields = [txtChooseFromDate, txtChooseToDate, txtVisitorFromDate, txtVisitorToDate]
        textFields.forEach { textField in
            textField?.inputView = datePicker
            textField?.inputAccessoryView = toolbar
            textField?.delegate = self
        }
    }
    
    @objc private func doneDatePicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        
        guard let activeTextField = activeTextField else { return }
        
        // Apply selected date
        activeTextField.text = formatter.string(from: datePicker.date)
        view.endEditing(true)
        
        // Handle automatic focus movement
        switch activeTextField {
        case txtChooseFromDate:
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.txtChooseToDate.becomeFirstResponder()
            }
            
        case txtVisitorFromDate:
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.txtVisitorToDate.becomeFirstResponder()
            }
            
        default:
            break
        }
    }
    
    @objc private func cancelDatePicker() {
        view.endEditing(true)
    }
}

extension HomeViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        
        if textField == txtChooseToDate, let fromDateText = txtChooseFromDate.text, let fromDate = formatter.date(from: fromDateText) {
            datePicker.minimumDate = fromDate
        } else if textField == txtVisitorToDate, let fromDateText = txtVisitorFromDate.text, let fromDate = formatter.date(from: fromDateText) {
            datePicker.minimumDate = fromDate
        } else {
            datePicker.minimumDate = nil
        }
    }
}
