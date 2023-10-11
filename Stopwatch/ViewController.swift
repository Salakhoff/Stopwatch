//
//  ViewController.swift
//  Stopwatch
//
//  Created by Ильфат Салахов on 11.10.2023.
//

import UIKit

final class ViewController: UIViewController {
    
    private var isTimerRunning = true
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00:00"
        label.font = .boldSystemFont(ofSize: 60)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var startAndPauseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Старт", for: .normal)
        button.backgroundColor = .green.withAlphaComponent(0.3)
        button.titleLabel?.font = .systemFont(ofSize: 25)
        button.setTitleColor(.green, for: .normal)
        button.addTarget(self, action: #selector(startPauseButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var resetButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Сброс", for: .normal)
        button.backgroundColor = .gray.withAlphaComponent(0.3)
        button.titleLabel?.font = .systemFont(ofSize: 25)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
        button.alpha = 0.5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        startAndPauseButton.layer.cornerRadius = startAndPauseButton.frame.width / 2
        resetButton.layer.cornerRadius = resetButton.frame.width / 2
    }
    
    @objc private func startPauseButtonTapped() {
        if isTimerRunning {
            startAndPauseButton.backgroundColor = UIColor.red.withAlphaComponent(0.3)
            startAndPauseButton.setTitle("Стоп", for: .normal)
            startAndPauseButton.setTitleColor(.red, for: .normal)
        } else {
            startAndPauseButton.backgroundColor = .green.withAlphaComponent(0.3)
            startAndPauseButton.setTitle("Старт", for: .normal)
            startAndPauseButton.setTitleColor(.green, for: .normal)
        }
        isTimerRunning.toggle()
        updateResetButtonAlpha()
    }
    
    @objc private func resetButtonTapped() {
        print("Тут обработаем")
    }
}

private extension ViewController {
    func setupView() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(timeLabel)
        view.addSubview(startAndPauseButton)
        view.addSubview(resetButton)
    }
    
    func setupConstraints() {
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
        if !isTimerRunning {
            resetButton.alpha = 0.5
            resetButton.isEnabled = false
        } else {
            resetButton.alpha = 1.0
            resetButton.isEnabled = true
        }
    }
}

