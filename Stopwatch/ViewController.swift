//
//  ViewController.swift
//  Stopwatch
//
//  Created by Ильфат Салахов on 11.10.2023.
//

import UIKit

final class ViewController: UIViewController {
    
    // MARK: UI
    private var isTimerRunning = true
    private var stopwatchTimer: Timer?
    private var elapsedTime: TimeInterval = 0
    private var displayLink: CADisplayLink?
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00,00"
        label.font = UIFont(name: "Menlo", size: 60)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var startAndPauseButton: UIButton = {
        return makeRoundButton(
            title: "Старт",
            color: .green,
            action: #selector(startPauseButtonTapped)
        )
    }()
    
    private lazy var resetButton: UIButton = {
        let button = makeRoundButton(
            title: "Сброс",
            color: .gray,
            action: #selector(resetButtonTapped)
        )
        button.alpha = 0.5
        return button
    }()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        startAndPauseButton.layer.cornerRadius = startAndPauseButton.frame.width / 2
        resetButton.layer.cornerRadius = resetButton.frame.width / 2
    }
    
    // MARK: Action
    @objc private func startPauseButtonTapped() {
        if isTimerRunning {
            startTimer()
        } else {
            pauseTimer()
        }
        isTimerRunning.toggle()
    }
    
    @objc private func resetButtonTapped() {
        resetTimer()
    }
    
    // MARK: Timer
    private func startTimer() {
        stopwatchTimer  = Timer.scheduledTimer(withTimeInterval: 0.0523, repeats: true, block: { [weak self] timer in
            self?.elapsedTime += 0.0523
            self?.updateTimerLabel()
        })
        startAndPauseButton.setTitle("Стоп", for: .normal)
        startAndPauseButton.backgroundColor = .red.withAlphaComponent(0.3)
        startAndPauseButton.setTitleColor(.red, for: .normal)
        resetButton.isEnabled = false
        updateResetButtonAlpha()
        
        startDisplayLink()
    }
    
    private func pauseTimer() {
        stopwatchTimer?.invalidate()
        startAndPauseButton.setTitle("Старт", for: .normal)
        startAndPauseButton.backgroundColor = .green.withAlphaComponent(0.3)
        startAndPauseButton.setTitleColor(.green, for: .normal)
        resetButton.isEnabled = true
        updateResetButtonAlpha()
        
        stopDisplayLink()
    }
    
    private func resetTimer() {
        stopwatchTimer?.invalidate()
        elapsedTime = 0
        updateTimerLabel()
        startAndPauseButton.setTitle("Старт", for: .normal)
        startAndPauseButton.backgroundColor = .green.withAlphaComponent(0.3)
        isTimerRunning = true
        updateResetButtonAlpha()
        
        stopDisplayLink()
    }
    
    // MARK: SetupUI
    private func makeRoundButton(title: String, color: UIColor, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.backgroundColor = color.withAlphaComponent(0.3)
        button.titleLabel?.font = .systemFont(ofSize: 25)
        button.setTitleColor(color, for: .normal)
        button.addTarget(self, action: action, for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(timeLabel)
        view.addSubview(startAndPauseButton)
        view.addSubview(resetButton)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            timeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            timeLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            
            startAndPauseButton.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 100),
            startAndPauseButton.trailingAnchor.constraint(equalTo: timeLabel.trailingAnchor),
            startAndPauseButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.25),
            startAndPauseButton.heightAnchor.constraint(equalTo: startAndPauseButton.widthAnchor),
            
            resetButton.heightAnchor.constraint(equalTo: startAndPauseButton.heightAnchor),
            resetButton.widthAnchor.constraint(equalTo: startAndPauseButton.widthAnchor),
            resetButton.leadingAnchor.constraint(equalTo: timeLabel.leadingAnchor),
            resetButton.centerYAnchor.constraint(equalTo: startAndPauseButton.centerYAnchor)
        ])
    }
    
    private func updateResetButtonAlpha() {
        resetButton.alpha = isTimerRunning ? 0.5 : 1.0
    }
    
    private func updateTimerLabel() {
        let totalMilliseconds = Int(elapsedTime * 1000)
        let milliseconds = totalMilliseconds % 100
        let seconds = (totalMilliseconds / 1000) % 60
        let minutes = (totalMilliseconds / 1000) / 60
        let hours = (totalMilliseconds / 1000) / 3600
        
        if hours == 0 {
            let timeString = String(format: "%02d:%02d,%02d", minutes, seconds, milliseconds)
            timeLabel.text = timeString
        } else {
            let timeString = String(format: "%02d:%02d:%02d,%02d", hours, minutes, seconds, milliseconds)
            timeLabel.text = timeString
        }
    }
    
    // MARK: CADisplayLink
    private func startDisplayLink() {
        displayLink = CADisplayLink(target: self, selector: #selector(displayLinkFired))
        displayLink?.add(to: .current, forMode: .default)
    }
    
    private func stopDisplayLink() {
        displayLink?.invalidate()
        displayLink = nil
    }
    
    @objc private func displayLinkFired() {
        updateTimerLabel()
    }
}

