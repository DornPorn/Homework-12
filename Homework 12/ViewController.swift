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
    var animationDuration: TimeInterval = 1500
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
    
    private lazy var circularProgressBar = CircularProgressBar(frame: .zero)
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setupHierarchy()
        setupLayout()
        setupView()
    }
    
    // MARK: - Settings
    
    private func setupHierarchy() {
        view.addSubview(circularProgressBar)
        view.addSubview(timerStack)
        view.addSubview(modeButtonsStackView)
        
        timerStack.addArrangedSubview(timerLabel)
        timerStack.addArrangedSubview(controlButton)
        
        modeButtonsStackView.addArrangedSubview(workModeButton)
        modeButtonsStackView.addArrangedSubview(restModeButton)
    }
    
    private func setupLayout() {
        circularProgressBar.translatesAutoresizingMaskIntoConstraints = false
        circularProgressBar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        circularProgressBar.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100).isActive = true

        timerStack.translatesAutoresizingMaskIntoConstraints = false
        timerStack.centerXAnchor.constraint(equalTo: circularProgressBar.centerXAnchor).isActive = true
        timerStack.centerYAnchor.constraint(equalTo: circularProgressBar.centerYAnchor).isActive = true
        
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
            
        timerLabel.textColor = isWorkMode ? .systemRed : .systemGreen
        controlButton.tintColor = isWorkMode ? .systemRed : .systemGreen
        controlButton.setImage(UIImage(systemName: isStarted ? Strings.pauseButtonStateImage : Strings.playButtonStateImage), for: .normal)
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
        animationDuration = 1500
        circularProgressBar.backgroundLayer.strokeColor = UIColor.systemRed.cgColor
        circularProgressBar.stopAnimation()
        updateTimerLabel(minutes: minutes, seconds: seconds)
    }
    
    @objc private func restModeOn() {
        isWorkMode = false
        isStarted = false
        timer.invalidate()
        minutes = 5
        seconds = 0
        durationTimer = 300
        animationDuration = 300
        circularProgressBar.backgroundLayer.strokeColor = UIColor.systemGreen.cgColor
        circularProgressBar.stopAnimation()
        updateTimerLabel(minutes: minutes, seconds: seconds)
    }
    
    @objc private func startTimer() {
        isStarted.toggle()
        
        if isStarted {
            controlButton.setImage(UIImage(systemName: Strings.pauseButtonStateImage), for: .normal)
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
            circularProgressBar.addAnimation(duration: animationDuration)
        } else {
            controlButton.setImage(UIImage(systemName: Strings.playButtonStateImage), for: .normal)
            timer.invalidate()
            circularProgressBar.pauseAnimation()
            
            if isWorkMode {
                animationDuration -= Double(1500 - durationTimer)
                print(animationDuration)
            } else {
                animationDuration -= Double(300 - durationTimer)
                print(animationDuration)
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
        
        updateTimerLabel(minutes: minutes, seconds: seconds)
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
        static let pauseButtonStateImage: String = "pause"
        static let workModeButtonTitle: String = "Work"
        static let restModeButtonTitle: String = "Rest"
        static let timerLabelInitialValue: String = "25:00"
    }
}


// MARK: - Circular progress bar

class CircularProgressBar: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createCircularParh()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    let backgroundLayer = CAShapeLayer()
    let progressLayer = CAShapeLayer()
    
    private let startPoint = CGFloat(-Double.pi / 2)
    private let endPoint = CGFloat(3 * Double.pi / 2)
    
    func createCircularParh() {
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2, y: frame.size.height / 2), radius: 80, startAngle: startPoint, endAngle: endPoint, clockwise: true)
        backgroundLayer.path = circularPath.cgPath
        backgroundLayer.fillColor = UIColor.clear.cgColor
        backgroundLayer.lineWidth = 2.0
        backgroundLayer.strokeEnd = 1
        backgroundLayer.strokeColor = UIColor.systemRed.cgColor
        layer.addSublayer(backgroundLayer)
        
        progressLayer.path = circularPath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .round
        progressLayer.lineWidth = 2.0
        progressLayer.strokeEnd = 0
        progressLayer.strokeColor = UIColor.white.cgColor
        layer.addSublayer(progressLayer)
    }
    
    func addAnimation(duration: TimeInterval) {
        let circularProgressAnimation = CABasicAnimation(keyPath: "strokeEnd")
        circularProgressAnimation.duration = duration
        circularProgressAnimation.toValue = 1
        circularProgressAnimation.fillMode = .forwards
        circularProgressAnimation.isRemovedOnCompletion = false
        progressLayer.add(circularProgressAnimation, forKey: "progressAnim")
    }
    
    func stopAnimation() {
        progressLayer.strokeEnd = 0
        progressLayer.removeAnimation(forKey: "progressAnim")
    }
    
    func pauseAnimation() {
        guard let presentation = progressLayer.presentation() else { return }
        progressLayer.strokeEnd = presentation.strokeEnd
        progressLayer.removeAnimation(forKey: "progressAnim")
    }
}

