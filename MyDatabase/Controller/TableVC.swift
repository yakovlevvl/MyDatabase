//
//  TableVC.swift
//  MyDatabase
//
//  Created by Vladyslav Yakovlev on 02.01.2018.
//  Copyright © 2018 Vladyslav Yakovlev. All rights reserved.
//

import UIKit

final class TableVC: UIViewController {
    
    var table: Table!
    
    weak var delegate: TableDelegate?
    
    private let tableView: TableView = {
        let tableView = TableView()
        tableView.rowHeight = 56
        tableView.backgroundColor = .white
        return tableView
    }()
    
    private let addRowButton: UIButton = {
        let button = UIButton(type: .custom)
        button.contentMode = .center
        button.setImage(UIImage(named: "Plus"), for: .normal)
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
    
    private let otherButton: UIButton = {
        let button = UIButton(type: .custom)
        button.contentMode = .center
        button.setImage(UIImage(named: "Other"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 68, height: 68)
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
        tableView.frame.size.height = view.frame.height - tableView.frame.origin.y - addRowButton.frame.height - 8
        view.addSubview(tableView)
        
        otherButton.center.y = tableView.frame.origin.y/2
        otherButton.frame.origin.x = view.frame.width - otherButton.frame.width - 12
        otherButton.addTarget(self, action: #selector(tapOtherButton), for: .touchUpInside)
        view.addSubview(otherButton)
        
        addRowButton.center.y = tableView.frame.maxY + (view.frame.height - tableView.frame.maxY)/2 - 1
        addRowButton.center.x = view.center.x
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
    
    @objc private func tapOtherButton() {
        let actionSheet = ActionSheet()
        let renameAction = Action(title: "Rename table", type: .normal) { _ in
            self.renameTable()
        }
        actionSheet.addAction(renameAction)
        let removeAction = Action(title: "Remove table", type: .destructive) { _ in
            self.removeTable()
        }
        actionSheet.addAction(removeAction)
        let cancelAction = Action(title: "Cancel", type: .cancel)
        actionSheet.addAction(cancelAction)
        actionSheet.present()
    }
    
    @objc private func addRow() {
        let newRowVC = NewRowVC()
        newRowVC.delegate = self
        newRowVC.table = table
        present(newRowVC, animated: true)
    }
    
    private func removeTable() {
        let alertVC = AlertController(message: "Are you sure ?")
        alertVC.addAction(Action(title: "Cancel", type: .cancel))
        let removeAction = Action(title: "Remove", type: .destructive) { _ in
            self.delegate?.tableDeleted(self.table)
            self.dismiss(animated: true)
        }
        alertVC.addAction(removeAction)
        alertVC.present()
    }
    
    private func renameTable() {
        let alertVC = AlertController(message: "Rename table")
        alertVC.includeTextField = true
        alertVC.allowEmptyTextField = false
        let doneAction = Action(title: "Done", type: .normal) { _ in
            if let name = alertVC.textField?.text?.trimmingCharacters(in: .whitespaces) {
                self.tryRenameTableWithName(name)
            }
        }
        let cancelAction = Action(title: "Cancel", type: .cancel)
        alertVC.addAction(doneAction)
        alertVC.addAction(cancelAction)
        alertVC.present()
    }
    
    private func tryRenameTableWithName(_ name: String) {
        if self.delegate!.tableWithNameExists(name: name) {
            let alertVC = AlertController(message: "Table with this name exists")
            alertVC.addAction(Action(title: "Okay", type: .cancel))
            alertVC.present()
        } else {
            self.table.name = name
            self.topLabel.text = name
            self.delegate?.tableRenamed()
        }
    }
    
    private func renameColumn(_ column: Column) {
        let alertVC = AlertController(message: "Rename column")
        alertVC.includeTextField = true
        alertVC.allowEmptyTextField = false
        let doneAction = Action(title: "Done", type: .normal) { _ in
            if let name = alertVC.textField?.text?.trimmingCharacters(in: .whitespaces) {
                self.tryRenameColumn(column, with: name)
            }
        }
        let cancelAction = Action(title: "Cancel", type: .cancel)
        alertVC.addAction(doneAction)
        alertVC.addAction(cancelAction)
        alertVC.present()
    }
    
    private func tryRenameColumn(_ column: Column, with name: String) {
        if column.name == name { return }
        if table.columns.contains(where: { $0.name == name }) {
            let alertVC = AlertController(message: "Column with this name exists")
            alertVC.addAction(Action(title: "Okay", type: .cancel))
            alertVC.present()
        } else {
            column.name = name
            tableView.reload()
        }
    }
    
    private func removeRowAtIndex(_ index: Int) {
        let alertVC = AlertController(message: "Remove row ?")
        alertVC.addAction(Action(title: "Cancel", type: .cancel))
        let removeAction = Action(title: "Remove", type: .destructive) { _ in
            self.table.rows.remove(at: index)
            self.tableView.reload()
            self.showAlertIfTableIsEmpty()
        }
        alertVC.addAction(removeAction)
        alertVC.present()
    }
    
    private func changeItemValueAt(rowIndex: Int, columnIndex: Int) {
        let alertVC = AlertController(message: "Change value")
        alertVC.includeTextField = true
        alertVC.allowEmptyTextField = false
        let doneAction = Action(title: "Done", type: .normal) { _ in
            if let value = alertVC.textField?.text?.trimmingCharacters(in: .whitespaces) {
                let item = self.table.itemFor(row: rowIndex, column: columnIndex)
                item.value = value
                self.tableView.reload()
            }
        }
        let cancelAction = Action(title: "Cancel", type: .cancel)
        alertVC.addAction(doneAction)
        alertVC.addAction(cancelAction)
        alertVC.present()
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

extension TableVC: TableViewDataSource {
    
    func numberOfRows(in: TableView) -> Int {
        return table.rowsCount
    }
    
    func numberOfColumns(in: TableView) -> Int {
        return table.columnsCount
    }
    
    func tableView(_ tableView: TableView, headerTitleForColumnAt index: Int) -> String {
        return table.columns[index].name
    }
    
    func tableView(_ tableView: TableView, valueForRowAt rowIndex: Int, forColumnAt columnIndex: Int) -> String {
        return table.itemFor(row: rowIndex, column: columnIndex).value
    }
}

extension TableVC: TableViewDelegate {
    
    func tableView(_ tableView: TableView, didSelectColumnHeaderAt index: Int) {
        let column = table.columns[index]
        renameColumn(column)
    }
    
    func tableView(_ tableView: TableView, didSelectRowEnumeratorAt index: Int) {
        removeRowAtIndex(index)
    }
    
    func tableView(_ tableView: TableView, didSelectItemAtRow rowIndex: Int, columnIndex: Int) {
        changeItemValueAt(rowIndex: rowIndex, columnIndex: columnIndex)
    }
}

protocol TableDelegate: class {
    
    func tableRenamed()
    
    func tableDeleted(_ table: Table)
    
    func tableWithNameExists(name: String) -> Bool
}

