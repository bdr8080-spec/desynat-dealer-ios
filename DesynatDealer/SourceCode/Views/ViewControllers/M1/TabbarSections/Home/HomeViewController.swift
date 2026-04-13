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
    
    private let datePicker = UIDatePicker()
    private var activeTextField: UITextField?
    private var dateButtons: [UIButton] { [btnToday, btnThisWeek, btnThisMonth]}
    private var statsButtons: [UIButton] { [btnTotalOrderConversion, btnTotalCustomerVisits]}
    private var lineChartView = LineChartView()
    private lazy var viewModel = HomeViewModel(hostVC: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTextFields()
        setUpButtons()
        setUpChart()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let savedStatus = UserDefaults.standard.getIntFor(key: .storeAvailabilityStatus) ?? 0
        btnToggle.setImage(
            UIImage(named: savedStatus == 1 ? "toggle_on" : "toggle_off"),
            for: .normal
        )
        busyOnOffLabel.text = savedStatus == 1 ? "Busy/On" : "Busy/Off"
        viewModel.getUserProfile()
        viewModel.getCountOfNotificationRequest()
        viewModel.getAdminStory()
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
        let vc = ProfileViewController.instantiate(fromAppStoryboard: .Profile)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnTapToggle(_ sender: Any) {
        viewModel.statusUpdateAPI { [weak self] success in
            guard let self = self else { return }
            if success {
                if let status = viewModel.storeAvailabilityModel?.storeAvailability {
                    if status == 1 {
                        busyOnOffLabel.text = "Busy/On"
                        btnToggle.setImage(UIImage(named: "toggle_on"), for: .normal)
                        CommonUtils.showToast(message: "Store has been activated Successfully")
                    } else {
                        busyOnOffLabel.text = "Busy/Off"
                        btnToggle.setImage(UIImage(named: "toggle_off"), for: .normal)
                        CommonUtils.showToast(message: "Store has been Deactivated Successfully")
                    }
                }
            }
        }
    }
    
    @IBAction func btnSelectDate(_ sender: UIButton) {
        updateRadioSelection(for: dateButtons, selectedButton: sender)
    }
    
    @IBAction func btnChooseVisits(_ sender: UIButton) {
        updateRadioSelection(for: statsButtons, selectedButton: sender)
    }
    
    @IBAction func btnChatSupportDidTapped(_ sender: UIButton) {
        let nextVC = SupportChatViewController.instantiate(fromAppStoryboard: .NotificationAndSubscribtion)
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    private func setUpButtons() {
        btnToggle.setImage(UIImage(named: "toggle_off"), for: .normal)
        updateRadioSelection(for: dateButtons, selectedButton: btnToday)
        updateRadioSelection(for: statsButtons, selectedButton: btnTotalOrderConversion)
    }
    
    func showProfileImage() {
        if let storeImageUrl = viewModel.userProfile?.profilePic,
           let url = URL(string: storeImageUrl) {
            userProfileImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            userProfileImageView.sd_imageIndicator?.startAnimatingIndicator()
            userProfileImageView.sd_setImage(with: url, placeholderImage: .userProfile)
        }
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
        lineChartView.frame = viewChart.bounds
        lineChartView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewChart.addSubview(lineChartView)
        let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep"]
        let values: [Double] = [50, 200, 100, 400, 300, 220, 180, 250, 320]
        
        var entries: [ChartDataEntry] = []
        for (index, value) in values.enumerated() {
            entries.append(ChartDataEntry(x: Double(index), y: value))
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

// Date Picker
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

//TExtField Delegate
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
