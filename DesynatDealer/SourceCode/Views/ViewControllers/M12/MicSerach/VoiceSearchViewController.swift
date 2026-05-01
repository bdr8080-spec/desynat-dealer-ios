//
//  VoiceSearchViewController.swift
//  DesynatDealer
//
//  Created by fluper_mac3 on 08/04/26.
//


import UIKit
import Speech

class VoiceSearchViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var micImageView: UIImageView!
    
    // MARK: - Property Decalaration
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    private var isListening = false
    private var silenceTimer: Timer?
    private let silenceDuration: TimeInterval = 1.5 // seconds of silence before stopping
    private var finalRecognizedText: String = ""
    private var latestSpokenText: String = ""
    private var hasFinishedListening = false
    var onSearchedCompletionTxt: ((String) -> Void)?
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = "Listening...".localiz()
        requestPermissions()
        if isListening {
            stopListening()
        } else {
            startListening()
            // need to show image like Pulsing Animation
        }
    }
    
    //MARK: Function's declaration
    private func requestPermissions() {
        SFSpeechRecognizer.requestAuthorization { status in
            print("Speech permission: \(status)")
        }
        
        if #available(iOS 17.0, *) {
            AVAudioApplication.requestRecordPermission { granted in
                DispatchQueue.main.async {
                    print("Mic permission: \(granted)")
                }
            }
        } else {
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                DispatchQueue.main.async {
                    print("Mic permission: \(granted)")
                }
            }
        }
    }
    
    private func startListening() {
        // Reset everything
        DispatchQueue.main.async {
            self.micImageView.image = UIImage(named: "micListing") // original mic image
            self.titleLabel.text = "Listening...".localiz()
        }
        hasFinishedListening = false
        latestSpokenText = ""
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
            
            // Ignore updates after finishing
            if self.hasFinishedListening { return }
            
            if let result = result {
                let text = result.bestTranscription.formattedString.trimmingCharacters(in: .whitespacesAndNewlines)
                
                // Ignore empty text
                if !text.isEmpty {
                    self.latestSpokenText = text
                    
                    DispatchQueue.main.async {
                        self.titleLabel.text = text
                    }
                    
                    self.resetSilenceTimer()
                }
            }
            
            if let error = error {
                print("Recognition error:", error)
                DispatchQueue.main.async {
                    self.finishListening()
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
            DispatchQueue.main.async {
                self.startMicPulse()
            }
        } catch {
            print("Failed to start audio engine: \(error)")
            stopListening()
        }
    }
    
    private func resetSilenceTimer() {
        silenceTimer?.invalidate()
        
        silenceTimer = Timer.scheduledTimer(withTimeInterval: silenceDuration, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.finishListening()
            }
        }
    }
    
    private func finishListening() {
        guard !hasFinishedListening else { return }
        hasFinishedListening = true
        
        stopListening()
        
        // Force label to keep last spoken text
        titleLabel.text = latestSpokenText
        
        micImageView.image = UIImage(named: "micSearch")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.navigateToNextScreen()
        }
    }
    
    private func navigateToNextScreen() {
        let searchText = latestSpokenText
        stopListening()
        print("Navigate with text: \(searchText)")
        dismiss(animated: true) { [weak self] in
            self?.onSearchedCompletionTxt?(searchText)
        }
    }
    
    // MARK: - Stop Listening
    private func stopListening() {
        silenceTimer?.invalidate()
        silenceTimer = nil
        
        if audioEngine.isRunning {
            audioEngine.stop()
            audioEngine.inputNode.removeTap(onBus: 0)
        }
        
        recognitionRequest?.endAudio()
        recognitionRequest = nil
        recognitionTask?.cancel()
        recognitionTask = nil
        isListening = false
        
        // Only update UI if view is still loaded
        if isViewLoaded {
            DispatchQueue.main.async {
                self.stopMicPulse()
            }
        }
    }
    
    private func startMicPulse() {
        micImageView.layer.removeAllAnimations()
        
        // Scale animation
        let scale = CABasicAnimation(keyPath: "transform.scale")
        scale.fromValue = 1.0
        scale.toValue = 1.2
        scale.duration = 0.8
        scale.autoreverses = true
        scale.repeatCount = .infinity
        scale.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        // Opacity animation (soft breathing feel)
        let opacity = CABasicAnimation(keyPath: "opacity")
        opacity.fromValue = 1.0
        opacity.toValue = 0.9
        opacity.duration = 0.8
        opacity.autoreverses = true
        opacity.repeatCount = .infinity
        opacity.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        micImageView.layer.add(scale, forKey: "micScale")
        micImageView.layer.add(opacity, forKey: "micOpacity")
    }
    
    private func stopMicPulse() {
        micImageView.layer.removeAllAnimations()
        micImageView.transform = .identity
        micImageView.alpha = 1.0
    }
    
}
