//
//  ColumnSettingsVC.swift
//  MyDatabase
//
//  Created by Vladyslav Yakovlev on 04.12.2017.
//  Copyright © 2017 Vladyslav Yakovlev. All rights reserved.
//

import UIKit

final class ColumnsSettingsVC: UIViewController {
    
    private let columnsNumber: Int
    private var columns = [Column]()
    
    weak var delegate: ColumnsSettingsDelegate?
    
    private let topLabel: UILabel = {
        let label = UILabel()
        label.frame.size = CGSize(width: 150, height: 24)
        label.font = UIFont(name: "Circe-Bold", size: 19)
        label.textAlignment = .center
        label.text = "Column 1"
        return label
    }()
    
    private let nameField: UITextField = {
        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: 240, height: 24))
        textField.borderStyle = .none
        textField.textAlignment = .center
        textField.placeholder = "Name"
        textField.returnKeyType = .done
        textField.font = UIFont(name: "Circe-Bold", size: 19)
        return textField
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Next", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel!.font = UIFont(name: "Circe-Bold", size: 20)
        button.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        return button
    }()
    
    private let typesTable: UITableView = {
        let table = UITableView(frame: CGRect(x: 0, y: 0, width: 160, height: 200))
        table.rowHeight = 56
        table.separatorStyle = .none
        return table
    }()
    
    private let allColumnsTypes: [ColumnType] = [.int, .real, .string]

    init(columnsNumber: Int) {
        self.columnsNumber = columnsNumber
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    private func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(nameField)
        nameField.center.x = view.center.x
        nameField.frame.origin.y = 150
        nameField.delegate = self
        nameField.becomeFirstResponder()
        
        topLabel.center.x = view.center.x
        topLabel.frame.origin.y = 46
        
        view.addSubview(topLabel)
        
        typesTable.dataSource = self
        typesTable.register(ColumnTypeCell.self, forCellReuseIdentifier: ColumnTypeCell.reuseId)
        typesTable.center.x = view.center.x
        typesTable.frame.origin.y = nameField.frame.maxY + 80
        view.addSubview(typesTable)
        
        nextButton.center.x = view.center.x
        nextButton.frame.origin.y = view.frame.height - nextButton.frame.height - 40
        nextButton.addTarget(self, action: #selector(tapNextButton), for: .touchUpInside)
        view.addSubview(nextButton)
        
        hideTypesTable()
    }
    
    private func hideTypesTable() {
        typesTable.alpha = 0
    }
    
    private func showTypesTable() {
        typesTable.alpha = 1
    }
    
    @objc private func tapNextButton() {
        if !nameField.text!.trimmingCharacters(in: .whitespaces).isEmpty, let indexPath = typesTable.indexPathForSelectedRow {
            let type = allColumnsTypes[indexPath.row]
            let name = nameField.text!.trimmingCharacters(in: .whitespaces)
            let column = Column(name: name, type: type)
            columns.append(column)
            
            if columns.count == columnsNumber {
                dismiss(animated: true) {
                    self.delegate?.columnsCreated(columns: self.columns)
                }
                return
            }
            
            topLabel.text = "Column \(columns.count + 1)"
            nameField.text = ""
            hideTypesTable()
            nameField.becomeFirstResponder()
            typesTable.deselectRow(at: indexPath, animated: false)
        }
    }

}

extension ColumnsSettingsVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameField {
            if !nameField.text!.isEmpty {
                showTypesTable()
                nameField.resignFirstResponder()
            }
        }
        return true
    }
}

extension ColumnsSettingsVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allColumnsTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ColumnTypeCell.reuseId, for: indexPath) as! ColumnTypeCell
        let type = allColumnsTypes[indexPath.row]
        cell.setType(type.rawValue)
        return cell
    }
}

protocol ColumnsSettingsDelegate: class {
    
    func columnsCreated(columns: [Column])
}

