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
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var editButtonView: UIButton!
    
    private var searchWorkItem: DispatchWorkItem?
    private lazy var viewModel = LiveCoverageListViewModel(hostVC: self)
    private var monthYearPicker: UIDatePicker?
    var liveRequestTimeslotISSelcted: Bool = true
    var selectedDateString: String? = ""
    var hasActionPermission: Bool = false
    
    private lazy var selectedDateFormatterForLiveRequestTimeSlot: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
//    private lazy var shortDateFormatterForCalender: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "EEE , MMM d"
//        formatter.locale = Locale(identifier: "en_US_POSIX")
//        return formatter
//    }()
    private lazy var shortDateFormatterForCalender: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE , MMM d"
        if AppLanguageManager.shared.currentLanguage == .ar {
            formatter.locale = Locale(identifier: "ar")
        } else {
            formatter.locale = Locale(identifier: "en_US_POSIX")
        }
        return formatter
    }()
//    lazy private var monthYearFormatter: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "MMMM yyyy"   // November 2025
//        return formatter
//    }()
    lazy private var monthYearFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"   // e.g. May 2026 or مايو ٢٠٢٦
        
        if AppLanguageManager.shared.currentLanguage == .ar {
            formatter.locale = Locale(identifier: "ar")   // Important for Arabic names
        } else {
            formatter.locale = Locale(identifier: "en_US_POSIX")
        }
        
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
        if AppLanguageManager.shared.currentLanguage == .ar {
                self.view.semanticContentAttribute = .forceRightToLeft
                UIView.appearance().semanticContentAttribute = .forceRightToLeft
            } else {
                self.view.semanticContentAttribute = .forceLeftToRight
                UIView.appearance().semanticContentAttribute = .forceLeftToRight
            }
        searchTF.delegate = self
        configureCalendar()
        selectTodayDate()
        mainScrollView.delegate = self
        editButtonView.isHidden = !hasActionPermission
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.viewCalendar.reloadData()
                self.viewCalendar.layoutIfNeeded()
            }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getAllLiveCoverageRequest()
    }
    
    @IBAction func editDidTapped(_ sender: Any) {
        editHandleMonthAndYearDatePicker()
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
        let vc = LiveCoverageFilterViewController.instantiate(fromAppStoryboard: .Profile)
        vc.delegate = self
        vc.appliedFilter = viewModel.appliedFilter
        self.navigationController?.present(vc, animated: true)
    }
    
    @IBAction func monthYearDidTapped(_ sender: Any) {
        let vc = MonthYearPickerViewController()
           vc.modalPresentationStyle = .pageSheet

        if let sheet = vc.sheetPresentationController {
            sheet.detents = [
                .custom { _ in 280 } // or 220–250 for compact layout
            ]
            sheet.prefersGrabberVisible = true
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
        }
           vc.onDateSelected = { [weak self] selectedDate in
               guard let self = self else { return }

               self.viewCalendar.setCurrentPage(selectedDate, animated: true)
               self.dateAndYearLabel.text = self.monthYearFormatter.string(from: selectedDate)
           }

           present(vc, animated: true)
    }
    
//    private func editHandleMonthAndYearDatePicker() {
//        let pickerVC = UIViewController()
//        pickerVC.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
//
//        let picker = UIDatePicker()
//        picker.datePickerMode = .date
//        picker.preferredDatePickerStyle = .inline
//        picker.date = viewCalendar.selectedDate ?? Date()
//        
//        // ✅ Disable past dates so they appear gray
//        picker.minimumDate = Date() // today
//        picker.maximumDate = nil
//        
//        picker.translatesAutoresizingMaskIntoConstraints = false
//        picker.layer.cornerRadius = 12
//        picker.clipsToBounds = true
//        picker.backgroundColor = .systemBackground
//
//        pickerVC.view.addSubview(picker)
//
//        NSLayoutConstraint.activate([
//            picker.centerXAnchor.constraint(equalTo: pickerVC.view.centerXAnchor),
//            picker.centerYAnchor.constraint(equalTo: pickerVC.view.centerYAnchor),
//            picker.leadingAnchor.constraint(equalTo: pickerVC.view.leadingAnchor, constant: 25),
//            picker.trailingAnchor.constraint(equalTo: pickerVC.view.trailingAnchor, constant: -25)
//        ])
//
//        let dismissView = UIView()
//        dismissView.translatesAutoresizingMaskIntoConstraints = false
//        pickerVC.view.insertSubview(dismissView, at: 0)
//        NSLayoutConstraint.activate([
//            dismissView.topAnchor.constraint(equalTo: pickerVC.view.topAnchor),
//            dismissView.bottomAnchor.constraint(equalTo: pickerVC.view.bottomAnchor),
//            dismissView.leadingAnchor.constraint(equalTo: pickerVC.view.leadingAnchor),
//            dismissView.trailingAnchor.constraint(equalTo: pickerVC.view.trailingAnchor)
//        ])
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissDatePicker))
//        dismissView.addGestureRecognizer(tapGesture)
//
//        picker.addTarget(self, action: #selector(centerDatePicked(_:)), for: .valueChanged)
//
//        pickerVC.modalPresentationStyle = .overCurrentContext
//        pickerVC.modalTransitionStyle = .crossDissolve
//        present(pickerVC, animated: true)
//
//        self.monthYearPicker = picker
//    }
    
    private func editHandleMonthAndYearDatePicker() {
        let pickerVC = UIViewController()
        pickerVC.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .inline
        picker.date = viewCalendar.selectedDate ?? Date()
        
        // ==================== ARABIC MONTHS + ENGLISH NUMBERS ====================
        if AppLanguageManager.shared.currentLanguage == .ar {
            let arabicLocale = Locale(identifier: "ar")
            
            picker.locale = arabicLocale
            picker.semanticContentAttribute = .forceRightToLeft
            picker.calendar = Calendar(identifier: .gregorian)
            
            // Strong force for English (Western) numbers
            picker.locale = Locale(identifier: "ar")
            
            pickerVC.view.semanticContentAttribute = .forceRightToLeft
        } else {
            picker.locale = Locale(identifier: "en_US_POSIX")
            picker.semanticContentAttribute = .forceLeftToRight
            pickerVC.view.semanticContentAttribute = .forceLeftToRight
        }
        // =====================================================================
        
        picker.minimumDate = Date()
        picker.maximumDate = nil
        
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.layer.cornerRadius = 12
        picker.clipsToBounds = true
        picker.backgroundColor = .systemBackground
        
        pickerVC.view.addSubview(picker)
        
        NSLayoutConstraint.activate([
            picker.centerXAnchor.constraint(equalTo: pickerVC.view.centerXAnchor),
            picker.centerYAnchor.constraint(equalTo: pickerVC.view.centerYAnchor),
            picker.leadingAnchor.constraint(equalTo: pickerVC.view.leadingAnchor, constant: 25),
            picker.trailingAnchor.constraint(equalTo: pickerVC.view.trailingAnchor, constant: -25)
        ])
        
        // Dismiss on tap outside
        let dismissView = UIView()
        dismissView.translatesAutoresizingMaskIntoConstraints = false
        pickerVC.view.insertSubview(dismissView, at: 0)
        
        NSLayoutConstraint.activate([
            dismissView.topAnchor.constraint(equalTo: pickerVC.view.topAnchor),
            dismissView.bottomAnchor.constraint(equalTo: pickerVC.view.bottomAnchor),
            dismissView.leadingAnchor.constraint(equalTo: pickerVC.view.leadingAnchor),
            dismissView.trailingAnchor.constraint(equalTo: pickerVC.view.trailingAnchor)
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissDatePicker))
        dismissView.addGestureRecognizer(tapGesture)
        
        picker.addTarget(self, action: #selector(centerDatePicked(_:)), for: .valueChanged)
        
        pickerVC.modalPresentationStyle = .overCurrentContext
        pickerVC.modalTransitionStyle = .crossDissolve
        present(pickerVC, animated: true)
        
        self.monthYearPicker = picker
    }
    
    @objc private func centerDatePicked(_ sender: UIDatePicker) {
        let selectedDate = sender.date

        // Update FSCalendar
        viewCalendar.setCurrentPage(selectedDate, animated: true)
        viewCalendar.select(selectedDate)

        // Update labels
        dateAndYearLabel.text = monthYearFormatter.string(from: selectedDate) // November 2025
        dateLabelInCustomCalender.text = shortDateFormatterForCalender.string(from: selectedDate) // Mon, Nov 17

        // Store selected date for API
        selectedDateString = apiDateFormatter.string(from: selectedDate) // "yyyy-MM-dd"

        // Dismiss picker automatically
        dismissDatePicker()
    }
    
    @objc private func dismissDatePicker() {
        presentedViewController?.dismiss(animated: true)
    }
    
    func handleHeightOfTableView() {
        DispatchQueue.main.async {
            self.timeSlotsTableView.layoutIfNeeded()
            self.liveRequestTbleViewHieghtConstarint.constant =
                self.timeSlotsTableView.contentSize.height
            self.view.layoutIfNeeded()
        }
    }
    
    private func selectTodayDate() {
        let today = Calendar.current.startOfDay(for: Date())
        viewCalendar.select(today)
        viewCalendar.setCurrentPage(today, animated: false)
        dateAndYearLabel.text = monthYearFormatter.string(from: today)
        
        selectedDateString = apiDateFormatter.string(from: today)
        dateLabelInCustomCalender.text = shortDateFormatterForCalender.string(from: today)
    }
    
//    private func configureCalendar() {
//        viewCalendar.delegate = self
//        viewCalendar.dataSource = self
//        viewCalendar.register(
//            GradientCalendarCell.self,
//            forCellReuseIdentifier: "GradientCalendarCell"
//        )
//        viewCalendar.appearance.selectionColor = .clear
//        viewCalendar.appearance.titleSelectionColor = .white
//        
//        viewCalendar.appearance.todayColor = .clear
//        viewCalendar.appearance.titleTodayColor = .black
//        
//        viewCalendar.appearance.weekdayFont = UIFont.systemFont(ofSize: 15, weight: .semibold)
//        viewCalendar.appearance.weekdayTextColor = .black
//        viewCalendar.appearance.headerTitleColor = .black
//        viewCalendar.appearance.headerTitleFont = UIFont.systemFont(ofSize: 18, weight: .bold)
//        viewCalendar.appearance.caseOptions = [.weekdayUsesSingleUpperCase]
//        
//        viewCalendar.appearance.headerMinimumDissolvedAlpha = 0.0
//        viewCalendar.headerHeight = 0
//        
//        dateAndYearLabel.text = monthYearFormatter.string(from: viewCalendar.currentPage)
//    }
    
    private func configureCalendar() {
        viewCalendar.delegate = self
        viewCalendar.dataSource = self
        
        // ==================== STRONG RTL FIX ====================
        if AppLanguageManager.shared.currentLanguage == .ar {
            viewCalendar.locale = Locale(identifier: "ar")     // Better than "ar"
            viewCalendar.semanticContentAttribute = .forceRightToLeft
            viewCalendar.firstWeekday = 7                          // Sunday start for Arabic (or 6 for Monday)
            
            // Force direction on calendar itself
            viewCalendar.semanticContentAttribute = .forceRightToLeft
        } else {
            viewCalendar.locale = Locale(identifier: "en_US_POSIX")
            viewCalendar.semanticContentAttribute = .forceLeftToRight
            viewCalendar.firstWeekday = 1                          // Sunday start for English
        }
        // ======================================================
        
        viewCalendar.register(GradientCalendarCell.self, forCellReuseIdentifier: "GradientCalendarCell")
        
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
        
        // Force refresh
        viewCalendar.reloadData()
        viewCalendar.setNeedsLayout()
        viewCalendar.layoutIfNeeded()
    }
    
}

extension LiveCoverageListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.liveRequestList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LiveCoverageRequestTableViewCell", for: indexPath) as! LiveCoverageRequestTableViewCell
        let data = viewModel.liveRequestList[indexPath.row]
        cell.configData(data: data, hasActionPermission: hasActionPermission)
        cell.onCancelRequest = {
            let nextVC = CancelSendRequestViewController.instantiate(fromAppStoryboard: .Profile)
            nextVC.timeSlotsId = data.id
            nextVC.onCancellationDone = { [weak self] in
                self?.viewModel.currentPage = 1
                self?.viewModel.hasMoreData = true
                self?.viewModel.getAllLiveCoverageRequest()
            }
            self.present(nextVC, animated: true)
        }
        return cell
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard scrollView == mainScrollView else { return }
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        
        if offsetY > contentHeight - frameHeight - 100 {
            
            if !viewModel.isLoading && viewModel.hasMoreData {
                viewModel.currentPage += 1
                viewModel.getAllLiveCoverageRequest()
            }
        }
    }
    
    func handleEditAction() {
        let nextVC = SendNewLiveRequestViewController.instantiate(fromAppStoryboard: .Profile)
        nextVC.selectedDateString = selectedDateString
        nextVC.onSendTapped = { [weak self] in
            guard let self = self else { return }
            let vc = RegisterationSuccessViewController.instantiate(fromAppStoryboard: .Main)
            vc.comingReason = .liveRequest
            vc.callBackDismiss = {
                print("Success dismissed")
                self.viewModel.currentPage = 1
                self.viewModel.hasMoreData = true
                self.viewModel.getAllLiveCoverageRequest()
            }
            self.present(vc, animated: true)
        }
        self.present(nextVC, animated: true)
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            if self.hasActionPermission {
                self.handleEditAction()
            }
        }
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
            self.viewModel.hasMoreData = true
            self.viewModel.getAllLiveCoverageRequest()
        }
        searchWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
        return true
    }
}

extension LiveCoverageListViewController: LiveCoverageFilterDelegate {
    func didApplyFilter(_ filter: LiveCoverageFilterModel) {
        viewModel.appliedFilter = filter
        viewModel.currentPage = 1
        viewModel.hasMoreData = true
        viewModel.getAllLiveCoverageRequest()
    }
    
    func didClearFilter() {
        viewModel.appliedFilter = nil
        viewModel.currentPage = 1
        viewModel.hasMoreData = true
        viewModel.getAllLiveCoverageRequest()
    }

}
