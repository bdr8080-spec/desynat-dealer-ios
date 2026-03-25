//
//  AccessModuleTableViewCell.swift
//  DesynatDealer
//
//  Created by  shailendra singh on 24/03/26.
//

import UIKit

class AccessModuleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var radioimageView: UIImageView!
    
    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.registerCellFromNib(cellID: "RadioBtnCollectionViewCell")
        }
    }
    var didSelectCollectionItem: ((Int) -> Void)?
    var rowIndex: Int = 0
    let accessmoduleType: [String] = ["View","Action"]
    var selectedIndex: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.reloadData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func updateSelectionState(isSelected: Bool) {
        if isSelected {
            // Selected state
            radioimageView.image = UIImage(named: "radioSelected" )
        } else {
            // Unselected state
            radioimageView.image = UIImage( named: "radioUnselected")
        }
    }
}
extension AccessModuleTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return accessmoduleType.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: RadioBtnCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "RadioBtnCollectionViewCell", for: indexPath) as! RadioBtnCollectionViewCell
        cell.titleLbl.text = accessmoduleType[indexPath.row]
        
        let isSelected = selectedIndex == indexPath.row
        cell.updateSelectionState(isSelected: isSelected)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            sizeForItemAt indexPath: IndexPath) -> CGSize {
            let width = (collectionView.frame.width) / 2 - 20  // Account for insets and spacing
            return CGSize(width: 150, height: 32)  // Slightly taller for better touch target
        }

//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        selectedIndex = indexPath.row
//        collectionView.reloadData()
//    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            // 1. Update local state
            self.selectedIndex = indexPath.row
            
            // 2. Trigger the callback to the ViewController
            didSelectCollectionItem?(indexPath.row)
        }
}
