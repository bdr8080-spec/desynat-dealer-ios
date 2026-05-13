//
//  WelcomeScreenViewController.swift
//  DesynatUser
//
//  Created by Rakhi Kumari on 22/10/25.
//

import UIKit
import JXPageControl

class WelcomeScreenViewController: UIViewController {
    
    @IBOutlet weak var skipButtonOutlet: CustomButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ellipse: BannerPageControl!
    @IBOutlet weak var walkthroghtCollectionView: UICollectionView!
    @IBOutlet weak var previousButtonOutlet: UIButton!

    var bannerArray: [WalkthroughModel] = [
        WalkthroughModel(image: UIImage(named: "walk1") ?? UIImage(systemName: "photo")!, // Fallback to system image
                         name: "Order Item".localiz(),
                         description: "Lorem ipsum dolor sit amet consectetur. Mi ultrices diam sociis volutpat orci non. Commodo pretium urna ut augue ac amet sed.".localiz()),
        WalkthroughModel(image: UIImage(named: "walk2") ?? UIImage(systemName: "photo")!,
                         name: "Product Delivery".localiz(),
                         description: "Lorem ipsum dolor sit amet consectetur. Mi ultrices diam sociis volutpat orci non. Commodo pretium urna ut augue ac amet sed.".localiz()),
        WalkthroughModel(image: UIImage(named: "walk3") ?? UIImage(systemName: "photo")!,
                         name: "Item Tracking".localiz(),
                         description: "Lorem ipsum dolor sit amet consectetur. Mi ultrices diam sociis volutpat orci non. Commodo pretium urna ut augue ac amet sed.".localiz())
    ]
    var currentCellIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        configurePageControl()
        updateUI(for: 0)
        // Force initial reload to ensure correct cell display
        walkthroghtCollectionView.reloadData()
//        print("Initial load: bannerArray images - \(bannerArray.map { $0.image })")
    }
    
    @IBAction func forwardNextButtonDidTapped(_ sender: Any) {
        if currentCellIndex < bannerArray.count - 1 {
            moveToPage(currentCellIndex + 1)
        } else {
            let vc = LoginViewController.instantiate(fromAppStoryboard: .Main)
            self.navigationController?.pushViewController(vc, animated: true)
            UserDefaults.standard.setValue("true", forKey: "isOnBoardingChecked")
        }
    }
    
    @IBAction func previousPageDidTapped(_ sender: Any) {
        if currentCellIndex > 0 {
            moveToPage(currentCellIndex - 1)
        }
    }
    
    @IBAction func skipDidTapped(_ sender: Any) {
        let vc = LoginViewController.instantiate(fromAppStoryboard: .Main)
        self.navigationController?.pushViewController(vc, animated: true)
//        UserDefaults.standard.setValue("false", forKey: "isAppInstall")
        UserDefaults.standard.setValue("true", forKey: "isOnBoardingChecked")
    }
    
    private func setupCollectionView() {
        walkthroghtCollectionView.delegate = self
        walkthroghtCollectionView.dataSource = self
        walkthroghtCollectionView.isPagingEnabled = true
        walkthroghtCollectionView.showsHorizontalScrollIndicator = false
        
        if let layout = walkthroghtCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
        }
    }
    
    func configurePageControl() {
        ellipse.numberOfPages = bannerArray.count
        ellipse.currentPage = 0
        ellipse.activeSize = CGSize(width: 16, height: 8)
        ellipse.inactiveSize = CGSize(width: 8, height: 8)
        ellipse.activeColor = .brown // Adjust color as needed
        ellipse.inactiveColor = .gray
        ellipse.isUserInteractionEnabled = false
    }
    
    private func moveToPage(_ index: Int) {
        guard bannerArray.indices.contains(index) else {
            return
        }
        currentCellIndex = index
        let indexPath = IndexPath(item: currentCellIndex, section: 0)
        walkthroghtCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.updateUI(for: self.currentCellIndex)
                self.walkthroghtCollectionView.reloadItems(at: [indexPath])
            }
    }
    
    func updateUI(for index: Int) {
        guard bannerArray.indices.contains(index) else { return }
        titleLabel.text = bannerArray[index].name
        descriptionLabel.text = bannerArray[index].description
        ellipse.currentPage = index
        skipButtonOutlet.isHidden = (index == bannerArray.count - 1)
        previousButtonOutlet.isHidden = (index == 0)
    }

}

extension WelcomeScreenViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bannerArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WalkThroughCell", for: indexPath) as! WalkThroughCell
        let data = bannerArray[indexPath.row]
        cell.imageWalk.image = nil
        cell.imageWalk.image = data.image
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.frame.width)
        currentCellIndex = page
        updateUI(for: page)
        let indexPath = IndexPath(item: page, section: 0)
        walkthroghtCollectionView.reloadItems(at: [indexPath])
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.frame.width)
//        print("Scroll ended (animation) at page: \(page), offset: \(scrollView.contentOffset)")
        currentCellIndex = page
        updateUI(for: page)
        let indexPath = IndexPath(item: page, section: 0)
        walkthroghtCollectionView.reloadItems(at: [indexPath])
    }
}

extension WelcomeScreenViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width,
                      height: collectionView.frame.height)
    }

    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

struct WalkthroughModel {
    var image: UIImage
    var name: String
    var description: String
}
