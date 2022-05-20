//
//  ViewController.swift
//  Homework 12
//
//  Created by Stanislav Rassolenko on 5/19/22.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Initial values
    
    var minutesString = ""
    var secondsString = ""
    var minutes = 25
    var seconds = 0
    var durationTimer = 1500
    var isStarted = false
    var isWorkMode = true
    var timer = Timer()
    
    // MARK: - UI Elements
    
    private lazy var modeButtonsStackView: UIStackView = {
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = Metric.modeButtonsStackViewSpacing
        return stackView
        
    }()
    
    private lazy var workModeButton = createModeButton(with: Strings.workModeButtonTitle, contentColor: UIColor.systemRed)
    private lazy var restModeButton = createModeButton(with: Strings.restModeButtonTitle, contentColor: UIColor.systemGreen)
        
    
    private lazy var timerLabel: UILabel = {
        
        let label = UILabel()
        label.text = Strings.timerLabelInitialValue
        label.font = .systemFont(ofSize: Metric.timerLabelFontSize, weight: .light)
        label.textColor = .systemRed
        label.textAlignment = .center
        return label
        
    }()
    
    private lazy var controlButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: Strings.playButtonStateImage), for: .normal)
        button.tintColor = .systemRed
        return button
        
    }()
    
    private lazy var timerStack: UIStackView = {
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = Metric.timerStackViewSpacing
        return stackView
        
    }()
    
       
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setupHierarchy()
        setupLayout()
        setupView()
    }
    
    // MARK: - Settings
    
    private func setupHierarchy() {
        
        view.addSubview(timerStack)
        view.addSubview(modeButtonsStackView)
        timerStack.addArrangedSubview(timerLabel)
        timerStack.addArrangedSubview(controlButton)
        modeButtonsStackView.addArrangedSubview(workModeButton)
        modeButtonsStackView.addArrangedSubview(restModeButton)
      
    }
    
    private func setupLayout() {

        timerStack.translatesAutoresizingMaskIntoConstraints = false
        timerStack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        timerStack.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        modeButtonsStackView.translatesAutoresizingMaskIntoConstraints = false
        modeButtonsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        modeButtonsStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Metric.modeButtonsStackViewBottomPadding).isActive = true
        modeButtonsStackView.heightAnchor.constraint(equalToConstant: Metric.modeButtonsStackViewHeight).isActive = true
        modeButtonsStackView.widthAnchor.constraint(equalToConstant: Metric.modeButtonsStackViewWidth).isActive = true
        
    }
    
    private func setupView() {
        
        controlButton.addTarget(self, action: #selector(startTimer), for: .touchUpInside)
        workModeButton.addTarget(self, action: #selector(workModeOn), for: .touchUpInside)
        restModeButton.addTarget(self, action: #selector(restModeOn), for: .touchUpInside)

    }

    // MARK: - Private functions
    
    private func updateTimerLabel(minutes: Int, seconds: Int) {
        
        if isWorkMode {
            minutesString = "\(minutes)"
            secondsString = "0\(seconds)"
            timerLabel.textColor = .systemRed
            controlButton.tintColor = .systemRed
            controlButton.setImage(UIImage(systemName: Strings.playButtonStateImage), for: .normal)
        } else {
            minutesString = "0\(minutes)"
            secondsString = "0\(seconds)"
            timerLabel.textColor = .systemGreen
            controlButton.tintColor = .systemGreen
            controlButton.setImage(UIImage(systemName: Strings.playButtonStateImage), for: .normal)
        }
        
        timerLabel.text = "\(minutesString):\(secondsString)"
    }
    
    private func createModeButton(with title: String, contentColor: UIColor) -> UIButton {
        
        let button = UIButton(type: .system)
        button.layer.cornerRadius = Metric.modeButtonCornerRadius
        button.setTitle(title, for: .normal)
        button.setTitleColor(contentColor, for: .normal)
        button.backgroundColor = .clear
        button.layer.borderWidth = Metric.modeButtonBorderWidth
        button.layer.borderColor = contentColor.cgColor
        return button
        
    }
    
    // MARK: - Button actions
    
    @objc private func workModeOn() {
        
        isWorkMode = true
        isStarted = false
        timer.invalidate()
        minutes = 25
        seconds = 0
        durationTimer = 1500
        updateTimerLabel(minutes: minutes, seconds: seconds)
        
    }
    
    @objc private func restModeOn() {
        
        isWorkMode = false
        isStarted = false
        timer.invalidate()
        minutes = 5
        seconds = 0
        durationTimer = 300
        updateTimerLabel(minutes: minutes, seconds: seconds)
        
    }
    
    @objc private func startTimer() {
        
        isStarted.toggle()
        
        if isStarted {
            controlButton.setImage(UIImage(systemName: Strings.stopButtonStateImage), for: .normal)
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        } else {
            controlButton.setImage(UIImage(systemName: Strings.playButtonStateImage), for: .normal)
            timer.invalidate()
            if isWorkMode {
                minutes = 25
                seconds = 0
                durationTimer = 1500
            } else {
                minutes = 5
                seconds = 0
                durationTimer = 300
            }
            updateTimerLabel(minutes: minutes, seconds: seconds)
        }
    }
    
    
    @objc private func timerAction() {
        
        if durationTimer == 1 {
            if isWorkMode {
                restModeOn()
                startTimer()
            } else {
                workModeOn()
                startTimer()
            }
        }
        
        if seconds == 0 {
            minutes -= 1
            seconds = 60
        }
        
        seconds -= 1
        durationTimer -= 1
        
        if minutes < 10 {
            minutesString = "0\(minutes)"
        } else {
            minutesString = "\(minutes)"
        }
        
        if seconds < 10 {
            secondsString = "0\(seconds)"
        } else {
            secondsString = "\(seconds)"
        }
        
        timerLabel.text = "\(minutesString):\(secondsString)"
        
    }
}

// MARK: - Constants

extension ViewController {
    enum Metric {
        static let modeButtonsStackViewSpacing: CGFloat = 10
        static let modeButtonCornerRadius: CGFloat = 20
        static let modeButtonBorderWidth: CGFloat = 2
        static let timerLabelFontSize: CGFloat = 36
        static let timerStackViewSpacing: CGFloat = 20
        static let modeButtonsStackViewBottomPadding: CGFloat = 100
        static let modeButtonsStackViewHeight: CGFloat = 70
        static let modeButtonsStackViewWidth: CGFloat = 300
    }
    
    enum Strings {
        static let playButtonStateImage: String = "play"
        static let stopButtonStateImage: String = "stop"
        static let workModeButtonTitle: String = "Work"
        static let restModeButtonTitle: String = "Rest"
        static let timerLabelInitialValue: String = "25:00"
    }
}

