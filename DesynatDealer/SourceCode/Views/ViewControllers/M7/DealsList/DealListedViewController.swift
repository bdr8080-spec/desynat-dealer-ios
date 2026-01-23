//
//  DealListedViewController.swift
//  DesynatDealer
//
//  Created by fluper_mac3 on 22/01/26.
//

import UIKit
import AVFAudio
import Speech

class DealListedViewController: UIViewController {

    @IBOutlet weak var noDataFoundLabel: UILabel!
    @IBOutlet weak var searchView: CustomView!
    @IBOutlet weak var listTableView: UITableView! {
        didSet {
            listTableView.registerCellFromNib(cellID: "ListedDealsTableViewCell")
        }
    }
    @IBOutlet weak var serachTF: UITextField!
    @IBOutlet weak var expiredButton: CustomButton!
    @IBOutlet weak var expiredLabel: UILabel!
    @IBOutlet weak var enrollLabel: UILabel!
    @IBOutlet weak var enrollButton: CustomButton!
    @IBOutlet weak var listedDealsLabel: UILabel!
    @IBOutlet weak var listedDealsButton: CustomButton!
    
    var tabType: DealsListedType = .listedDeals
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    private var isListening = false
    private lazy var viewModel = DealListedViewModel(hostVC: self)
    private var searchWorkItem: DispatchWorkItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        serachTF.delegate = self
        requestPermissions()
        handleListedDealsAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.dealsListRequest()
    }
    
    deinit {
        stopListening()
    }
    
    @IBAction func micDidTapped(_ sender: UIButton) {
        if isListening {
            stopListening()
            sender.setImage(UIImage(systemName: "mic"), for: .normal)
        } else {
            startListening()
            sender.setImage(UIImage(systemName: "mic.fill"), for: .normal)
            sender.tintColor = .systemRed // optional: show it's active
        }
    }
    
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func listedDidTapped(_ sender: Any) {
        handleListedDealsAction()
        searchView.isHidden = true
        listTableView.reloadData()
    }
    
    @IBAction func enrolledDidTapped(_ sender: Any) {
        handleEnrolledAction()
        searchView.isHidden = false
        listTableView.reloadData()
    }
    
    @IBAction func expiredDidTapped(_ sender: Any) {
        handleExpiredAction()
        searchView.isHidden = false
        listTableView.reloadData()
    }
    
    private func handleListedDealsAction() {
        activateTab(
            button: listedDealsButton,
            label: listedDealsLabel,
            corners: [.layerMinXMinYCorner, .layerMinXMaxYCorner],
            viewType: .listedDeals
        )
    }

    private func handleEnrolledAction() {
        activateTab(
            button: enrollButton,
            label: enrollLabel,
            viewType: .enrolled
        )
    }

    private func handleExpiredAction() {
        activateTab(
            button: expiredButton,
            label: expiredLabel,
            corners: [.layerMaxXMinYCorner, .layerMaxXMaxYCorner],
            viewType: .expired
        )
    }

    private func resetTabs() {
        let buttons = [expiredButton, listedDealsButton, enrollButton]
        let labels = [expiredLabel, listedDealsLabel, enrollLabel]

        buttons.forEach {
            $0?.setImage(nil, for: .normal)
            $0?.layer.cornerRadius = 0
            $0?.clipsToBounds = false
        }

        labels.forEach {
            $0?.textColor = .black
        }
    }

    private func activateTab(
        button: UIButton,
        label: UILabel,
        corners: CACornerMask = [],
        viewType: DealsListedType
    ) {
        resetTabs()

        button.setImage(UIImage(named: "topTabbar"), for: .normal)
        button.layer.cornerRadius = corners.isEmpty ? 0 : 5
        button.layer.maskedCorners = corners
        button.clipsToBounds = !corners.isEmpty

        label.textColor = .white
        tabType = viewType
    }
    
    private func requestPermissions() {
        SFSpeechRecognizer.requestAuthorization { _ in }
        AVAudioSession.sharedInstance().requestRecordPermission { _ in }
    }
    
    // MARK: - Start Listening (Speech → Text)
    private func startListening() {
        // Reset everything
        recognitionTask?.cancel()
        recognitionTask = nil
        recognitionRequest = nil
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("Audio session error: \(error)")
            return
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let request = recognitionRequest else { return }
        request.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer?.recognitionTask(with: request) { [weak self] result, error in
            guard let self = self else { return }
            
            if let result = result {
                let text = result.bestTranscription.formattedString
                self.serachTF.text = text
                // CALL API HERE FOR SEARCHs
            }
            
            if error != nil || result?.isFinal == true {
                self.stopListening()
                DispatchQueue.main.async {
                    (self.serachTF.inputView as? UIButton)?.setImage(UIImage(systemName: "mic"), for: .normal)
                }
            }
        }
        
        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            request.append(buffer)
        }
        
        audioEngine.prepare()
        do {
            try audioEngine.start()
            isListening = true
            serachTF.becomeFirstResponder() // optional: show cursor
        } catch {
            print("Failed to start audio engine: \(error)")
            stopListening()
        }
    }
    
    // MARK: - Stop Listening
    private func stopListening() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionRequest?.endAudio()
        recognitionRequest = nil
        recognitionTask?.cancel()
        recognitionTask = nil
        isListening = false
    }
}

extension DealListedViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tabType {
        case .listedDeals:
            return viewModel.listedDeal?.count ?? 0
        case .enrolled:
            return viewModel.enrolledDeals?.count ?? 0
        case .expired:
            return viewModel.expiredDeal?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListedDealsTableViewCell", for: indexPath) as! ListedDealsTableViewCell
        switch tabType {
        case .listedDeals:
            cell.configData(type: tabType, data: viewModel.listedDeal?[indexPath.row])
        case .enrolled:
            cell.configData(type: tabType, data: viewModel.enrolledDeals?[indexPath.row])
        case .expired:
            cell.configData(type: tabType, data: viewModel.expiredDeal?[indexPath.row])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = DealsDetailsViewController.instantiate(fromAppStoryboard: .OrderAndChat)
        nextVC.tabType = tabType
        switch tabType {
        case .listedDeals:
            nextVC.dealID = viewModel.listedDeal?[indexPath.row].id ?? 0
        case .enrolled:
            nextVC.dealID = viewModel.enrolledDeals?[indexPath.row].id ?? 0
        case .expired:
            nextVC.dealID = viewModel.expiredDeal?[indexPath.row].id ?? 0
        }
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}

extension DealListedViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        searchWorkItem?.cancel()
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            self.viewModel.searchText = currentText
            viewModel.dealsListRequest()
        }
        searchWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
        return true
    }
}


enum DealsListedType {
    case listedDeals
    case enrolled
    case expired
}
