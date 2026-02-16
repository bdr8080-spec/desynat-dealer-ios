//
//  LiveCoverageListViewController.swift
//  DesynatDealer
//
//  Created by fluper_mac3 on 13/02/26.
//

import UIKit
import FSCalendar

class LiveCoverageListViewController: UIViewController {
    
    @IBOutlet weak var dateAndYearLabel: UILabel!
    @IBOutlet weak var dateLabelInCustomCalender: UILabel!
    @IBOutlet weak var viewCalendar: FSCalendar!
    @IBOutlet weak var liveRequestTbleViewHieghtConstarint: NSLayoutConstraint!
    @IBOutlet weak var noDataFoundLabel: UILabel!
    @IBOutlet weak var timeSlotsTableView: UITableView! {
        didSet {
            timeSlotsTableView.registerCellFromNib(cellID: "LiveCoverageRequestTableViewCell")
        }
    }
    @IBOutlet weak var searchTF: UITextField!
    
    private var searchWorkItem: DispatchWorkItem?
    var liveRequestTimeslotISSelcted: Bool = true
    private lazy var viewModel = LiveCoverageListViewModel(hostVC: self)
    var selectedDateString: String? = ""
    
    private lazy var selectedDateFormatterForLiveRequestTimeSlot: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    private lazy var shortDateFormatterForCalender: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE , MMM d"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    lazy private var monthYearFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"   // November 2025
        return formatter
    }()
    private lazy var apiDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTF.delegate = self
        configureCalendar()
        selectTodayDate()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        DispatchQueue.main.async {
            self.liveRequestTbleViewHieghtConstarint.constant = self.timeSlotsTableView.contentSize.height
        }
    }
    
    @IBAction func editDidTapped(_ sender: Any) {
        let nextVC = SendNewLiveRequestViewController.instantiate(fromAppStoryboard: .Profile)
        nextVC.onSendTapped = { [weak self] in
            guard let self = self else { return }
            let vc = RegisterationSuccessViewController.instantiate(fromAppStoryboard: .Main)
            vc.comingReason = .liveRequest
            vc.callBackDismiss = {
                print("Success dismissed")
            }
            self.present(vc, animated: true)
        }
        self.present(nextVC, animated: true)
    }
    
    @IBAction func btnCalenderBackTap(_ sender: Any) {
        let currentPage = viewCalendar.currentPage
        let prevMonth = Calendar.current.date(byAdding: .month, value: -1, to: currentPage)
        viewCalendar.setCurrentPage(prevMonth!, animated: true)
    }
    
    @IBAction func btnCalenderFrontTap(_ sender: Any) {
        let currentPage = viewCalendar.currentPage
        let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: currentPage)
        viewCalendar.setCurrentPage(nextMonth!, animated: true)
    }
    
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func filterDidTapped(_ sender: Any) {
    }
    
    private func selectTodayDate() {
        let today = Calendar.current.startOfDay(for: Date())
        viewCalendar.select(today)
        viewCalendar.setCurrentPage(today, animated: false)
        dateAndYearLabel.text = monthYearFormatter.string(from: today)
        
        selectedDateString = apiDateFormatter.string(from: today)
        dateLabelInCustomCalender.text = shortDateFormatterForCalender.string(from: today)
    }
    
    private func configureCalendar() {
        viewCalendar.delegate = self
        viewCalendar.dataSource = self
        viewCalendar.register(
            GradientCalendarCell.self,
            forCellReuseIdentifier: "GradientCalendarCell"
        )
        viewCalendar.appearance.selectionColor = .clear
        viewCalendar.appearance.titleSelectionColor = .white
        
        viewCalendar.appearance.todayColor = .clear
        viewCalendar.appearance.titleTodayColor = .black
        
        viewCalendar.appearance.weekdayFont = UIFont.systemFont(ofSize: 15, weight: .semibold)
        viewCalendar.appearance.weekdayTextColor = .black
        viewCalendar.appearance.headerTitleColor = .black
        viewCalendar.appearance.headerTitleFont = UIFont.systemFont(ofSize: 18, weight: .bold)
        viewCalendar.appearance.caseOptions = [.weekdayUsesSingleUpperCase]
        
        viewCalendar.appearance.headerMinimumDissolvedAlpha = 0.0
        viewCalendar.headerHeight = 0
        
        dateAndYearLabel.text = monthYearFormatter.string(from: viewCalendar.currentPage)
    }
    
}

extension LiveCoverageListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LiveCoverageRequestTableViewCell", for: indexPath) as! LiveCoverageRequestTableViewCell
        cell.cancelRequestView.isHidden = true
        cell.rejectedView.isHidden = true
        cell.rejectedDateView.isHidden = true
        if indexPath.row == 0 {
            cell.cancelRequestView.isHidden = false
        } else if indexPath.row == 1 {
            cell.rejectedView.isHidden = false
            cell.rejectedDateView.isHidden = false
        }
        cell.onCancelRequest = {
            let nextVC = CancelSendRequestViewController.instantiate(fromAppStoryboard: .Profile)
            self.navigationController?.present(nextVC, animated: true)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewWillLayoutSubviews()
    }
}

extension LiveCoverageListViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        let today = Calendar.current.startOfDay(for: Date())
        let targetDate = Calendar.current.startOfDay(for: date)
        return targetDate >= today
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let today = Calendar.current.startOfDay(for: Date())
        let targetDate = Calendar.current.startOfDay(for: date)
        guard targetDate >= today else { return }
        selectedDateString = apiDateFormatter.string(from: targetDate)
        dateLabelInCustomCalender.text = shortDateFormatterForCalender.string(from: targetDate)
        //        viewModel.fetchTimeSlotsIfPossible()
        calendar.reloadData()
    }
    
    // Highlight selected range
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        return nil
    }
    
    // Title color
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        let today = Calendar.current.startOfDay(for: Date())
        let targetDate = Calendar.current.startOfDay(for: date)
        if targetDate < today {
            return .lightGray
        } else if targetDate >= today {
            return .black
        }
        return .black
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        dateAndYearLabel.text = monthYearFormatter.string(from: calendar.currentPage)
    }
    
    func calendar(_ calendar: FSCalendar,cellFor date: Date,at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: "GradientCalendarCell",for: date, at: position) as! GradientCalendarCell
        return cell
    }
    
}

extension LiveCoverageListViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        searchWorkItem?.cancel()
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            self.viewModel.searchText = currentText
            self.viewModel.currentPage = 1
            //            self.viewModel.getLiveRequest()
        }
        searchWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
        return true
    }
}
