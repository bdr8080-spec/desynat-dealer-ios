//
//  FullscreenImageCell.swift
//  DesynatDealer
//
//  Created by fluper on 06/01/26.
//

import UIKit


class FullscreenImageCell: UICollectionViewCell, UIScrollViewDelegate {

    static let id = "FullscreenImageCell"

    private let scrollView = UIScrollView()
    private let imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        scrollView.frame = contentView.bounds
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 4
        scrollView.delegate = self
        contentView.addSubview(scrollView)

        imageView.frame = scrollView.bounds
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        scrollView.addSubview(imageView)

        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapZoom))
        doubleTap.numberOfTapsRequired = 2
        imageView.addGestureRecognizer(doubleTap)
    }

    func configure(_ url: String) {
        imageView.sd_setImage(with: URL(string: url))
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }

    @objc private func doubleTapZoom() {
        scrollView.setZoomScale(scrollView.zoomScale == 1 ? 2 : 1, animated: true)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        scrollView.setZoomScale(1, animated: false)
    }
}
