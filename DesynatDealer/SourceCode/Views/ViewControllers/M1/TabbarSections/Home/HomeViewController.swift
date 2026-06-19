//
//  HomeViewController.swift
//  DesynatUser
//
//  Created by Rakhi Kumari on 23/10/25.
//

import UIKit
import Charts
import DGCharts
import SDWebImage

class HomeViewController: UIViewController {
    
    @IBOutlet weak var adminstoryImageView: UIImageView!
    @IBOutlet weak var userProfileImageView: CustomImageView!
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
    @IBOutlet weak var busyOnOffLabel: CustomLabelFont!
    @IBOutlet weak var notificationCountView: CustomView!
    @IBOutlet weak var notificationCountLabel: UILabel!
    @IBOutlet weak var adminstoryButtonOutlet: UIButton!
    @IBOutlet weak var messageCountView: CustomView!
    @IBOutlet weak var unreadMessageCountLabel: UILabel!
    
    private let datePicker = UIDatePicker()
    private var activeTextField: UITextField?
    private var dateButtons: [UIButton] { [btnToday, btnThisWeek, btnThisMonth]}
    private var statsButtons: [UIButton] { [btnTotalOrderConversion, btnTotalCustomerVisits]}
    private var lineChartView = LineChartView()
    private lazy var viewModel = HomeViewModel(hostVC: self)
    var selectedFilterType: Int = -1
    private let displayFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yyyy"
        df.locale = Locale(identifier: "en_US_POSIX")
        return df
    }()
    private let apiFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        df.locale = Locale(identifier: "en_US_POSIX")
        return df
    }()
    var selectedGraphType: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTextFields()
        setUpButtons()
        setUpChart()
        btnToday.setTitle("   Today".localiz(), for: .normal)
        btnThisWeek.setTitle("   This week".localiz(), for: .normal)
        btnThisMonth.setTitle("   This Month".localiz(), for: .normal)
        txtChooseToDate.placeholder = "To   //  //".localiz()
        txtVisitorToDate.placeholder = "To   //  //".localiz()
        txtChooseFromDate.placeholder = "From   //  //".localiz()
        txtVisitorFromDate.placeholder = "From   //  //".localiz()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        let savedStatus = UserDefaults.standard.getIntFor(key: .storeAvailabilityStatus) ?? 0
//        btnToggle.setImage(
//            UIImage(named: savedStatus == 1 ? "toggle_on" : "toggle_off"),
//            for: .normal
//        )
//        busyOnOffLabel.text = savedStatus == 1 ? "Open".localiz() : "Busy".localiz()
        viewModel.getUserProfile()
        viewModel.getCountOfNotificationRequest()
        viewModel.getAdminStory()
        viewModel.getDashboardApi(filterType: selectedFilterType, fromDate: "", toDate: "", dateAnalyticsFrom: "", dateAnalyticsTo: "")
    }
    
    @IBAction func btnDesynatShowDesign(_ sender: Any) {
        let nextVC = StoryViewerViewController.instantiate(fromAppStoryboard: .Profile)
        nextVC.comingFor = .forAdminStory
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func btnChat(_ sender: Any) {
        let nextVC = ChatInboxListViewController.instantiate(fromAppStoryboard: .OrderAndChat)
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func btnNotification(_ sender: Any) {
        let vc = MyNotificationsListViewController.instantiate(fromAppStoryboard: .NotificationAndSubscribtion)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnProfile(_ sender: Any) {
        if let savedUser: User = kSharedUserDefaults.retrieveModelFor(key: .user, model: User.self) {
            if savedUser.type == "0" {
                let vc = ProfileViewController.instantiate(fromAppStoryboard: .Profile)
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                let vc = SubDealerSideMenuViewController.instantiate(fromAppStoryboard: .Profile)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    @IBAction func btnTapToggle(_ sender: Any) {
        viewModel.statusUpdateAPI { [weak self] success in
            guard let self = self else { return }
            if success {
                if let status = viewModel.storeAvailabilityModel?.storeAvailability {
//                    busyOnOffLabel.text = savedStatus == 1 ? "Busy".localiz() : "Open".localiz()
                    if status == 1 {
                        busyOnOffLabel.text = "Open".localiz()
                        btnToggle.setImage(UIImage(named: "toggle_on"), for: .normal)
                        CommonUtils.showToast(message: "Store has been activated Successfully".localiz())
                    } else {
                        busyOnOffLabel.text = "Busy".localiz()
                        btnToggle.setImage(UIImage(named: "toggle_off"), for: .normal)
                        CommonUtils.showToast(message: "Store has been Deactivated Successfully".localiz())
                    }
                }
            }
        }
    }
    
    @IBAction func btnSelectDate(_ sender: UIButton) {
        updateRadioSelectionDashboard(for: dateButtons, selectedButton: sender)
    }
    
    @IBAction func btnChooseVisits(_ sender: UIButton) {
        updateRadioSelection(for: statsButtons, selectedButton: sender)
    }
    
    @IBAction func btnSupportChatDidTapped(_ sender: UIButton) {
        let nextVC = SupportChatViewController.instantiate(fromAppStoryboard: .NotificationAndSubscribtion)
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    private func setUpButtons() {
        btnToggle.setImage(UIImage(named: "toggle_off"), for: .normal)
        //        updateRadioSelection(for: dateButtons, selectedButton: btnToday)
        updateRadioSelection(for: statsButtons, selectedButton: btnTotalOrderConversion)
    }
    
    //    private func updateRadioSelection(for buttons: [UIButton], selectedButton: UIButton) {
    //        for button in buttons {
    //            if button == selectedButton {
    //                button.setImage(UIImage(named: "radio_select_brown"), for: .normal)
    //                selectedGraphType = button.tag
    //                setUpChart()
    //            } else {
    //                button.setImage(UIImage(named: "radio_unselect_brown"), for: .normal)
    //            }
    //        }
    //    }
    private func updateRadioSelection(for buttons: [UIButton], selectedButton: UIButton) {
        if selectedButton.isSelected {
            selectedButton.isSelected = false
            selectedButton.setImage(UIImage(named: "radio_unselect_brown"), for: .normal)
            selectedGraphType = -1
            setUpChart()
            return
        }
        for button in buttons {
            button.isSelected = (button == selectedButton)
            button.setImage(
                UIImage(named: button.isSelected ? "radio_select_brown" : "radio_unselect_brown"),
                for: .normal
            )
        }
        selectedGraphType = selectedButton.tag
        setUpChart()
    }
    
    //    private func updateRadioSelectionDashboard(for buttons: [UIButton], selectedButton: UIButton) {
    //        for button in buttons {
    //            if button == selectedButton {
    //                button.setImage(UIImage(named: "radio_select_brown"), for: .normal)
    //                selectedFilterType = button.tag + 1
    //                viewModel.getDashboardApi(filterType: button.tag + 1, fromDate: "", toDate: "", dateAnalyticsFrom: "", dateAnalyticsTo: "")
    //            } else {
    //                button.setImage(UIImage(named: "radio_unselect_brown"), for: .normal)
    //            }
    //        }
    //    }
    
    private func updateRadioSelectionDashboard(for buttons: [UIButton], selectedButton: UIButton) {
        if selectedButton.isSelected {
            selectedButton.isSelected = false
            selectedButton.setImage(UIImage(named: "radio_unselect_brown"), for: .normal)
            selectedFilterType = 0
            return
        }
        for button in buttons {
            button.isSelected = (button == selectedButton)
            button.setImage(
                UIImage(named: button.isSelected ? "radio_select_brown" : "radio_unselect_brown"),
                for: .normal
            )
        }
        selectedFilterType = selectedButton.tag + 1
        //        viewModel.getDashboardApi(
        //            filterType: selectedFilterType,
        //            fromDate: "",
        //            toDate: "",
        //            dateAnalyticsFrom: "",
        //            dateAnalyticsTo: ""
        //        )
        callDashboardAPIIfValid()
    }
    
    func setUpChart() {
        lineChartView.frame = viewChart.bounds
        lineChartView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewChart.addSubview(lineChartView)
        var months = [String]()
        var values: [Int] = []
        if selectedGraphType == 0 {
            months.removeAll()
            values.removeAll()
            self.viewModel.dashBoardData?.orderAnalytics?.forEach { data in
//                months.append(data.month ?? "")
                months.append(CommonUtils.localizedMonth(data.month ?? ""))
                values.append(data.orders ?? 0)
            }
        }else {
            months.removeAll()
            values.removeAll()
            self.viewModel.dashBoardData?.visitorAnalytics?.forEach { data in
//                months.append(data.month ?? "")
                months.append(CommonUtils.localizedMonth(data.month ?? ""))
                values.append(data.totalVisitors ?? 0)
            }
        }
        var entries: [ChartDataEntry] = []
        for (index, value) in values.enumerated() {
            entries.append(ChartDataEntry(x: Double(index), y: Double(value)))
        }
        let set = LineChartDataSet(entries: entries, label: "")
        set.mode = .linear
        set.lineWidth = 1.2
        set.circleRadius = 5
        set.circleHoleRadius = 2
        set.setColor(.black)
        set.circleColors = [.systemOrange]
        set.circleHoleColor = .white
        set.valueTextColor = .clear
        
        let data = LineChartData(dataSet: set)
        lineChartView.data = data
        
        lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: months)
        lineChartView.xAxis.granularity = 1
        lineChartView.xAxis.labelPosition = .bottom
        lineChartView.xAxis.labelFont = .systemFont(ofSize: 10)
        
        lineChartView.leftAxis.labelFont = .systemFont(ofSize: 10)
        lineChartView.rightAxis.enabled = false
        
        lineChartView.legend.enabled = false
        lineChartView.chartDescription.enabled = false
        lineChartView.xAxis.drawGridLinesEnabled = false
        lineChartView.leftAxis.drawGridLinesEnabled = true
        lineChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
    }
}

extension HomeViewController {
    private func convertToDate(_ string: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: string)
    }
    
    private func setUpTextFields() {
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        datePicker.minimumDate = nil
        datePicker.maximumDate = Date()
        datePicker.backgroundColor = .white
        if AppLanguageManager.shared.currentLanguage == .ar {
            datePicker.locale = Locale(identifier: "ar")
        } else {
            datePicker.locale = Locale(identifier: "en_US")
        }
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done".localiz(), style: .done, target: self, action: #selector(doneDatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel".localiz(), style: .plain, target: self, action: #selector(cancelDatePicker))
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
        if activeTextField == txtChooseFromDate {
            let selectedDate = datePicker.date
            txtChooseFromDate.text = formatter.string(from: selectedDate)
            if let toText = txtChooseToDate.text,
               let toDate = convertToDate(toText),
               toDate < selectedDate {
                txtChooseToDate.text = ""
            }
        }
        else if activeTextField == txtChooseToDate {
            let selectedDate = datePicker.date
            txtChooseToDate.text = formatter.string(from: selectedDate)
        }
        if activeTextField == txtVisitorFromDate {
            let selectedDate = datePicker.date
            txtVisitorFromDate.text = formatter.string(from: selectedDate)
            if let toText = txtVisitorToDate.text,
               let toDate = convertToDate(toText),
               toDate < selectedDate {
                txtVisitorToDate.text = ""
            }
        }
        else if activeTextField == txtVisitorToDate {
            let selectedDate = datePicker.date
            txtVisitorToDate.text = formatter.string(from: selectedDate)
        }
        view.endEditing(true)
        if let from = txtChooseFromDate.text,
           let to = txtChooseToDate.text,
           !from.isEmpty, !to.isEmpty {
            callDashboardAPIIfValid()
        }
        if let from = txtVisitorFromDate.text,
           let to = txtVisitorToDate.text,
           !from.isEmpty, !to.isEmpty {
            callDashboardAPIIfValid()
        }
    }
    
    func callDashboardAPIIfValid() {
        var fromDate = ""
        var toDate = ""
        var analyticsFrom = ""
        var analyticsTo = ""
        if let text = txtChooseFromDate.text,
           let date = displayFormatter.date(from: text) {
            fromDate = apiFormatter.string(from: date)
        }
        if let text = txtChooseToDate.text,
           let date = displayFormatter.date(from: text) {
            toDate = apiFormatter.string(from: date)
        }
        if let text = txtVisitorFromDate.text,
           let date = displayFormatter.date(from: text) {
            analyticsFrom = apiFormatter.string(from: date)
        }
        if let text = txtVisitorToDate.text,
           let date = displayFormatter.date(from: text) {
            analyticsTo = apiFormatter.string(from: date)
        }
        if let from = displayFormatter.date(from: txtChooseFromDate.text ?? ""),
           let to = displayFormatter.date(from: txtChooseToDate.text ?? ""),
           from > to {
            CommonUtils.showToast(message: "From date cannot be greater than To date".localiz())
            return
        }
        if let from = displayFormatter.date(from: txtVisitorFromDate.text ?? ""),
           let to = displayFormatter.date(from: txtVisitorToDate.text ?? ""),
           from > to {
            CommonUtils.showToast(message: "From date cannot be greater than To date".localiz())
            return
        }
        if (fromDate.isEmpty && !toDate.isEmpty) || (!fromDate.isEmpty && toDate.isEmpty) {
            CommonUtils.showToast(message: "Select both From and To dates".localiz())
            return
        }
        if (analyticsFrom.isEmpty && !analyticsTo.isEmpty) || (!analyticsFrom.isEmpty && analyticsTo.isEmpty) {
            CommonUtils.showToast(message: "Select both Visitor dates".localiz())
            return
        }
        viewModel.getDashboardApi(
            filterType: selectedFilterType,
            fromDate: fromDate,
            toDate: toDate,
            dateAnalyticsFrom: analyticsFrom,
            dateAnalyticsTo: analyticsTo
        )
    }
    @objc private func cancelDatePicker() {
        view.endEditing(true)
    }
}

//TExtField Delegate
extension HomeViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
        updateDatePickerRange()
    }
    private func updateDatePickerRange() {
        if activeTextField == txtChooseFromDate {
            // From date: no restriction (or max = today)
            datePicker.minimumDate = nil
            datePicker.maximumDate = Date()
        }
        else if activeTextField == txtChooseToDate {
            // If from date exists → restrict to date
            if let fromText = txtChooseFromDate.text,
               let fromDate = convertToDate(fromText) {
                datePicker.minimumDate = fromDate
            } else {
                // If no from date selected → block future selection until today logic
                datePicker.minimumDate = nil
            }
            datePicker.maximumDate = Date()
        }
    }
}
