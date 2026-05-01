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
    
//    var didSelectCollectionItem: ((Int) -> Void)?
//    var rowIndex: Int = 0
    let accessmoduleType: [String] = ["View","Action"]
    var selectedIndex = -1
    var isOuterRowSelected: Bool = false
//    let accessmoduleType: [String] = ["View","Action"]
//    var selectedIndex = -1
//    var isOuterRowSelected: Bool = false
    var moduleId: Int = 0
    var isRowSelected: Bool = false
    var viewSelected: Bool = false
    var actionSelected: Bool = false
    var selectionUpdated: ((_ moduleId: Int, _ viewSelected: Bool, _ actionSelected: Bool) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.reloadData()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
extension AccessModuleTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return accessmoduleType.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RadioBtnCollectionViewCell",for: indexPath) as! RadioBtnCollectionViewCell
        cell.titleLbl.text = accessmoduleType[indexPath.row].localiz()
        if indexPath.row == 0 {
            cell.imageView.image = viewSelected ? .radioSelected : .radioUnselected
        } else {
            cell.imageView.image = actionSelected ? .radioSelected : .radioUnselected
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isRowSelected == false { return }
        if indexPath.row == 0 {
            viewSelected.toggle()
            if viewSelected == false {
                actionSelected = false
            }
        } else {
            if actionSelected {
                actionSelected = false
            } else {
                actionSelected = true
                viewSelected = true
            }
        }
        collectionView.reloadData()
        selectionUpdated?(moduleId, viewSelected, actionSelected)
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 32)
    }
}
