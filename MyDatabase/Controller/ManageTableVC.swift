//
//  ManageTableVC.swift
//  MyDatabase
//
//  Created by Vladyslav Yakovlev on 19.12.2017.
//  Copyright © 2017 Vladyslav Yakovlev. All rights reserved.
//

import UIKit

final class TableVC: UIViewController {
    
    var table: Table!
    
    var delegate: TableDelegate?
    
    private let tableView: TableView = {
        let tableView = TableView()
        tableView.rowHeight = 56
        //tableView.
        tableView.backgroundColor = .white
        return tableView
    }()
    
    private let deleteTableButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .white
        button.setTitle("Delete Table", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.titleLabel!.font = UIFont(name: "Circe-Bold", size: 19)
        button.frame = CGRect(x: 0, y: 0, width: 0, height: 76)
        return button
    }()
    
    private let addRowButton: UIButton = {
        let button = UIButton(type: .custom)
        button.contentMode = .center
        button.setImage(UIImage(named: "NewDatabase"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 68, height: 68)
        return button
    }()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .custom)
        button.contentMode = .center
        button.setImage(UIImage(named: "Back"), for: .normal)
        button.frame = CGRect(x: 5, y: 0, width: 68, height: 68)
        return button
    }()
    
    private let topLabel: UILabel = {
        let label = UILabel()
        label.frame.size = CGSize(width: 150, height: 24)
        label.font = UIFont(name: "Circe-Bold", size: 19)
        label.textAlignment = .center
        return label
    }()
    
    private let alertLabel: UILabel = {
        let label = UILabel()
        label.text = "No data"
        label.frame.size = CGSize(width: 200, height: 24)
        label.font = UIFont(name: "Circe-Bold", size: 20)
        label.textAlignment = .center
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame.origin.x = 0
        tableView.frame.origin.y = 78
        tableView.frame.size.width = view.frame.width
        tableView.frame.size.height = view.frame.height - tableView.frame.origin.y - deleteTableButton.frame.height
        view.addSubview(tableView)
        
        deleteTableButton.frame.size.width = view.frame.width
        deleteTableButton.frame.origin.y = view.frame.height - deleteTableButton.frame.height
        deleteTableButton.addTarget(self, action: #selector(deleteTable), for: .touchUpInside)
        view.addSubview(deleteTableButton)
        
        addRowButton.center.y = tableView.frame.origin.y/2
        addRowButton.frame.origin.x = view.frame.width - addRowButton.frame.width - 10
        addRowButton.addTarget(self, action: #selector(addRow), for: .touchUpInside)
        view.addSubview(addRowButton)
        
        backButton.center.y = tableView.frame.origin.y/2
        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        view.addSubview(backButton)
        
        topLabel.text = table.name
        topLabel.center.x = view.center.x
        topLabel.center.y = backButton.center.y + 1
        view.addSubview(topLabel)
        
        showAlertIfTableIsEmpty()
    }
    
    private func showAlertIfTableIsEmpty() {
        if table.rowsCount == 0 {
            alertLabel.center = tableView.center
            view.addSubview(alertLabel)
        }
    }
    
    @objc private func addRow() {
        let newRowVC = NewRowVC()
        newRowVC.delegate = self
        newRowVC.table = table
        present(newRowVC, animated: true)
    }
    
    @objc private func deleteTable() {
        delegate?.tableDeleted(table)
        dismiss(animated: true)
    }
    
    @objc private func back() {
        dismiss(animated: true)
    }
    
    deinit {
        print("deinit ManageTableVC")
    }
    
}

extension TableVC: NewRowDelegate {

    func newRowCreated(row: Row) {
        table.rows.append(row)
        tableView.reload()
        if alertLabel.superview != nil {
            alertLabel.removeFromSuperview()
        }
    }
}

//extension TableVC: UICollectionViewDataSource {
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        var count = 0
//        switch collectionView {
//            case itemsView : count = table.itemsCount
//            case headerView : count = table.columnsCount
//            case enumeratorView : count = table.rowsCount + 1
//            default : break
//        }
//        return count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//
//        // Like a table view, your collection view can have sections and items: each row of your spreadsheet could be a section, and then the individual elements (Last Name, Social, Address, etc) could be items.
//
//
//
//        switch collectionView {
//            case itemsView :
//                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCell.reuseId, for: indexPath) as! ItemCell
//                cell.item = table.itemForCell(with: indexPath.item)
//            return cell
//            //case headerView : cell.text = table.columns[indexPath.item]
//            //case enumeratorView : cell.text = indexPath.item == 0 ? "n" : "\(indexPath.item)"
//            default : break
//        }
//        return UICollectionViewCell()
//    }
//}

//extension TableVC: UICollectionViewDelegateFlowLayout {
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if collectionView == enumeratorView {
//            if indexPath.row == 0 { return }
//            let cell = collectionView.cellForItem(at: indexPath) as! ItemCell
//            let rowNumber = Int(cell.text!)!
//
//            let darkView = UIView(frame: view.frame)
//            darkView.backgroundColor = .black
//            darkView.alpha = 0
//            view.addSubview(darkView)
//
//            let baseView = UIView(frame: CGRect(x: 0, y: view.frame.height - 156, width: view.frame.width, height: 170))
//            baseView.backgroundColor = .white
//            let cancelButton = UIButton(type: .custom)
//            cancelButton.setTitle("Cancel", for: .normal)
//            cancelButton.setTitleColor(.black, for: .normal)
//            cancelButton.titleLabel!.font = UIFont(name: "Circe-Bold", size: 19)
//            cancelButton.frame = CGRect(x: 0, y: baseView.frame.height/2, width: baseView.frame.width, height: baseView.frame.height/2 - 10)
//            cancelButton.addTarget(self, action: #selector(cancelRemoving), for: .touchUpInside)
//            let removeButton = UIButton(type: .custom)
//            removeButton.setTitle("Delete record \(rowNumber)", for: .normal)
//            removeButton.setTitleColor(.red, for: .normal)
//            removeButton.titleLabel!.font = UIFont(name: "Circe-Bold", size: 19)
//            removeButton.frame = CGRect(x: 0, y: 10, width: baseView.frame.width, height: baseView.frame.height/2 - 10)
//            removeButton.tag = rowNumber
//            removeButton.addTarget(self, action: #selector(removeRow(sender:)), for: .touchUpInside)
//            baseView.addSubview(cancelButton)
//            baseView.addSubview(removeButton)
//            view.addSubview(baseView)
//            baseView.frame.origin.y = view.frame.height
//
//            UIView.animate(withDuration: 0.28, animations: {
//                baseView.frame.origin.y = self.view.frame.height - baseView.frame.height
//                darkView.alpha = 0.6
//            })
//        }
//    }
//
//    @objc private func removeRow(sender: UIButton) {
//        hideRemovingView()
//        let row = sender.tag
//        table.rows.remove(at: row - 1)
//        itemsView.reloadData()
//        enumeratorView.reloadData()
//        let itemsViewFlowLayout = (itemsView.collectionViewLayout as! UICollectionViewFlowLayout)
//        itemsView.frame.size.height = itemSize.height*CGFloat(table.rowsCount) + itemsViewFlowLayout.minimumLineSpacing*CGFloat(table.rowsCount - 1) + itemsViewFlowLayout.sectionInset.top + itemsViewFlowLayout.sectionInset.bottom
//
//        let headerViewFlowLayout = (headerView.collectionViewLayout as! UICollectionViewFlowLayout)
//        let headerViewHeight = headerViewFlowLayout.sectionInset.top + headerItemSize.height
//
//        enumeratorView.frame.size.height = itemsView.frame.size.height + headerViewHeight
//
//        scrollView.contentSize.height = enumeratorView.frame.size.height
//          checkIfTableIsNotEmpty()
//    }
//
//    @objc private func cancelRemoving() {
//        hideRemovingView()
//    }
//
//    private func hideRemovingView() {
//        let baseView = view.subviews.last!
//        let darkView = view.subviews[view.subviews.count - 2]
//
//        UIView.animate(withDuration: 0.28, animations: {
//            baseView.frame.origin.y = self.view.frame.height
//            darkView.alpha = 0
//        }, completion: { _ in
//            darkView.removeFromSuperview()
//            baseView.removeFromSuperview()
//        })
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        var size = CGSize()
//        switch collectionView {
//            case itemsView : size = itemSize
//            case headerView : size = headerItemSize
//            case enumeratorView : size = indexPath.item == 0 ? CGSize(width: enumeratorItemSize.width, height: headerItemSize.height)  : enumeratorItemSize
//            default : break
//        }
//        return size
//    }
//
//
//}

extension TableVC: TableViewDataSource {
    
    func numberOfRows(in: TableView) -> Int {
        return table.rowsCount
    }
    
    func numberOfColumns(in: TableView) -> Int {
        return table.columnsCount
    }
    
    func tableView(_ tableView: TableView, itemForRowAt rowIndex: Int, forColumnAt columnIndex: Int) -> Item {
        let item = Item(row: rowIndex, column: columnIndex)
        item.value = table.itemFor(row: rowIndex, column: columnIndex).value
        return item
    }
    
    func tableView(_ tableView: TableView, headerTitleForColumnAt index: Int) -> String {
        return table.columns[index].name
    }
    
}

extension TableVC: TableViewDelegate {
    
    func tableView(_ tableView: TableView, didSelectItemAtRow rowIndex: Int, columnIndex: Int) {
        print("didSelectItemAtRow \(rowIndex), \(columnIndex)")
    }
    
    func tableView(_ tableView: TableView, didSelectColumnHeaderAt index: Int) {
        print("didSelectColumnHeaderAt \(index)")
    }
    
    func tableView(_ tableView: TableView, didSelectRowEnumeratorAt index: Int) {
        print("didSelectRowEnumeratorAt \(index)")
    }
    
}

protocol TableDelegate {    //  : class (for weak)
    
    func tableDeleted(_ table: Table)
}
