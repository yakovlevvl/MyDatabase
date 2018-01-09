//
//  NewTableVC.swift
//  MyDatabase
//
//  Created by Vladyslav Yakovlev on 28.11.2017.
//  Copyright © 2017 Vladyslav Yakovlev. All rights reserved.
//

import UIKit

final class NewTableVC: UIViewController {

    weak var delegate: NewTableDelegate?
    
    private let topLabel: UILabel = {
        let label = UILabel()
        label.frame.size = CGSize(width: 150, height: 24)
        label.font = UIFont(name: "Circe-Bold", size: 19)
        label.textAlignment = .center
        label.text = "New Table"
        return label
    }()
    
    private let nameField: UITextField = {
        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: 240, height: 24))
        textField.borderStyle = .none
        textField.textAlignment = .center
        textField.placeholder = "Name"
        textField.returnKeyType = .next
        textField.font = UIFont(name: "Circe-Bold", size: 19)
        return textField
    }()
    
    private let columnsNumberField: UITextField = {
        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: 240, height: 24))
        textField.borderStyle = .none
        textField.textAlignment = .center
        textField.placeholder = "Number of columns"
        textField.returnKeyType = .done
        textField.font = UIFont(name: "Circe-Bold", size: 19)
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(nameField)
        nameField.center.x = view.center.x
        nameField.frame.origin.y = 160
        nameField.delegate = self
        nameField.becomeFirstResponder()
        
        view.addSubview(columnsNumberField)
        columnsNumberField.center.x = view.center.x
        columnsNumberField.frame.origin.y = 260
        columnsNumberField.delegate = self
        
        topLabel.center.x = view.center.x
        topLabel.frame.origin.y = 46
        
        view.addSubview(topLabel)
    }

}

extension NewTableVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameField {
            if !nameField.text!.trimmingCharacters(in: .whitespaces).isEmpty {
                columnsNumberField.becomeFirstResponder()
            }
        }
        if textField == columnsNumberField {
            if !columnsNumberField.text!.trimmingCharacters(in: .whitespaces).isEmpty {
                columnsNumberField.resignFirstResponder()
                let columnsSettingsVC = ColumnsSettingsVC(columnsNumber: Int(columnsNumberField.text!)!)
                columnsSettingsVC.delegate = self
                present(columnsSettingsVC, animated: true)
            }
        }
        return true
    }
}

extension NewTableVC: ColumnsSettingsDelegate {
    
    func columnsCreated(columns: [Column]) {
        let table = Table(name: nameField.text!, columns: columns)
        delegate?.newTableCreated(table: table)
        dismiss(animated: true)
    }
}

protocol NewTableDelegate: class {
    
    func newTableCreated(table: Table)
}
