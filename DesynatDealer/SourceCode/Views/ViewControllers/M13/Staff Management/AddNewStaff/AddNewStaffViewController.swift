//
//  AddNewStaffViewController.swift
//  DesynatDealer
//
//  Created by  shailendra singh on 24/03/26.
//

import UIKit

class AddNewStaffViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var roleSelectionCollectionView: UICollectionView!{
        didSet{
            roleSelectionCollectionView.dataSource = self
            roleSelectionCollectionView.delegate = self
            roleSelectionCollectionView.registerCellFromNib(cellID: "RadioBtnCollectionViewCell")
        }
    }
    @IBOutlet weak var accessModuleTableView: TableViewDynamicHeight!{
        didSet{
            accessModuleTableView.registerCellFromNib(cellID: "AccessModuleTableViewCell")
        }
    }
    
    @IBOutlet weak var addBtnLbl: UILabel!
    @IBOutlet weak var confirmPasswortTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var editStaffView: UIView!
    @IBOutlet weak var addNewStaffView: CustomView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    
    // MARK: - Variable
    let roles = ["Manager", "Officer", "Sales employee"]
    var selectedRow: Int?
    private var selectedRoleIndex: Int?
    private var selectedAccessModule: Int?
    var  comingReason : comingFrom?
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        DispatchQueue.main.async {
            self.tableViewHeightConstraint.constant = self.accessModuleTableView.contentSize.height
        }
    }
    
    
    // MARK: - Navigation
    @IBAction func backbtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func passwordEyebtn(_ sender: UIButton) {
        sender.isSelected.toggle()
        passwordTxtField.isSecureTextEntry.toggle()
    }
    @IBAction func confirmPasswordEyebtn(_ sender: UIButton) {
        sender.isSelected.toggle()
        confirmPasswortTxtField.isSecureTextEntry.toggle()
    }
    
    // MARK: - Function
    func initialSetup() {
        switch comingReason {
        case .addNewStaff:
            titleLbl.text = "Add New Staff"
            addNewStaffView.isHidden = false
            editStaffView.isHidden = true
            addBtnLbl.text = "ADD"
        case .editStaff:
            titleLbl.text = "Edit"
            editStaffView.isHidden = false
            addNewStaffView.isHidden = true
            addBtnLbl.text = "Save changes"
        case nil:
            return
        }
    }
    
    
}
extension AddNewStaffViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return roles.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RadioBtnCollectionViewCell", for: indexPath) as! RadioBtnCollectionViewCell
        cell.titleLbl.text = roles[indexPath.row]
        let isSelected = selectedRoleIndex == indexPath.row
        cell.updateSelectionState(isSelected: isSelected)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = roles[indexPath.row]
        let font = UIFont(name: "Poppins-Medium", size: 14) ?? UIFont.systemFont(ofSize: 14)
        let width = (text as NSString).size(withAttributes: [.font: font]).width
        return CGSize(width: width + 16, height: 24)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let previousIndex = selectedRoleIndex
        selectedRoleIndex = indexPath.row
        roleSelectionCollectionView.reloadData()
        print("Selected role: \(roles[indexPath.row])")
    }
    
}
extension AddNewStaffViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccessModuleTableViewCell") as! AccessModuleTableViewCell
        //        cell.rowIndex = indexPath.row
        if selectedRow == indexPath.row {
            cell.selectedIndex = -1
            cell.isOuterRowSelected = true
            cell.radioimageView.image = .radioSelected
            cell.collectionView.reloadData()
        } else {
            cell.selectedIndex = -1
            cell.isOuterRowSelected = false
            cell.radioimageView.image = .radioUnselected
            cell.collectionView.reloadData()
        }
        //        cell.didSelectCollectionItem = { [weak self] collectionIndex in
        //            guard let self = self else { return }
        //            self.selectedRow = indexPath.row
        //            self.selectedAccessModule = collectionIndex
        //            self.accessModuleTableView.reloadData()
        //        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewWillLayoutSubviews()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath.row
        tableView.reloadData()
    }
}
enum comingFrom {
    case addNewStaff, editStaff
}
