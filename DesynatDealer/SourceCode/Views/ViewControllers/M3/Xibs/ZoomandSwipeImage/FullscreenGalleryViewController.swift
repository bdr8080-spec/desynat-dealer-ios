//
//  FullscreenGalleryViewController.swift
//  DesynatDealer
//
//  Created by fluper on 06/01/26.
//

import UIKit

class FullscreenGalleryViewController: UIViewController,
                                      UICollectionViewDelegate,
                                      UICollectionViewDataSource,
                                      UICollectionViewDelegateFlowLayout {

    var images: [String] = []
    var startIndex: Int = 0

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black

        collectionView.frame = view.bounds
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .black
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(
            FullscreenImageCell.self,
            forCellWithReuseIdentifier: FullscreenImageCell.id
        )
        view.addSubview(collectionView)

        // Close button
        let close = UIButton(frame: CGRect(x: 20, y: 50, width: 40, height: 40))
        close.setTitle("✕", for: .normal)
        close.titleLabel?.font = .systemFont(ofSize: 28)
        close.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        view.addSubview(close)

        // Scroll to selected image
        DispatchQueue.main.async {
            self.collectionView.scrollToItem(
                at: IndexPath(item: self.startIndex, section: 0),
                at: .centeredHorizontally,
                animated: false
            )
        }
    }

    // MARK: - UICollectionView DataSource

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FullscreenImageCell.id,
            for: indexPath
        ) as! FullscreenImageCell

        cell.configure(images[indexPath.item])
        return cell
    }

    // MARK: - UICollectionView FlowLayout

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }

    // MARK: - Actions

    @objc private func closeTapped() {
        dismiss(animated: true)
    }
}
