//
//  NewRowVC.swift
//  MyDatabase
//
//  Created by Vladyslav Yakovlev on 03.12.2017.
//  Copyright © 2017 Vladyslav Yakovlev. All rights reserved.
//

import UIKit

final class NewRowVC: UIViewController {
    
    var table: Table!
    
    weak var delegate: NewRowDelegate?
    
    private var rowItems = [Item]()
    
    private let topLabel: UILabel = {
        let label = UILabel()
        label.frame.size = CGSize(width: 150, height: 24)
        label.font = UIFont(name: "Circe-Bold", size: 20)
        label.textAlignment = .center
        label.text = "New Row"
        return label
    }()
    
    private let textField: UITextField = {
        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: 240, height: 24))
        textField.borderStyle = .none
        textField.textAlignment = .center
        textField.returnKeyType = .done
        textField.font = UIFont(name: "Circe-Bold", size: 21)
        return textField
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton(type: .custom)
        button.contentMode = .center
        button.setImage(UIImage(named: "Back"), for: .normal)
        button.frame = CGRect(x: 5, y: 5, width: 68, height: 68)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        
        textField.delegate = self
        textField.placeholder = table.columns.first!.name
        textField.center.x = view.center.x
        textField.frame.origin.y = 210
        view.addSubview(textField)
        textField.becomeFirstResponder()
        
        topLabel.center.x = view.center.x
        topLabel.frame.origin.y = 86
        view.addSubview(topLabel)
        
        cancelButton.addTarget(self, action: #selector(tapCancelButton), for: .touchUpInside)
        view.addSubview(cancelButton)
    }
    
    @objc private func tapCancelButton() {
        textField.resignFirstResponder()
        dismiss(animated: true)
    }

}

extension NewRowVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if !textField.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            let value = textField.text!
            let type = table.columns[rowItems.count].type
            let item = Item(value: value, type: type)
            rowItems.append(item)
        
            if rowItems.count == table.columnsCount {
                let row = Row(items: rowItems)
                textField.resignFirstResponder()
                delegate?.newRowCreated(row: row)
                dismiss(animated: true)
                return true
            }
            textField.text = ""
            textField.placeholder = table.columns[rowItems.count].name
        }
        return true
    }
}

protocol NewRowDelegate: class {
    
    func newRowCreated(row: Row)
}


