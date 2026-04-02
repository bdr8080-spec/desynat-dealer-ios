//
//  StoryProgressView.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 27/03/26.
//


import UIKit

class StoryProgressView: UIView {

    private var bars: [UIProgressView] = []

    func configure(count: Int) {
        subviews.forEach { $0.removeFromSuperview() }
        bars = []

        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 4
        stack.distribution = .fillEqually
        
        for _ in 0..<count {
            let bar = UIProgressView(progressViewStyle: .default)
            bar.progress = 0
            bars.append(bar)
            stack.addArrangedSubview(bar)
        }

        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func setProgress(_ index: Int, _ progress: Float) {
        bars[index].progress = progress
    }
}