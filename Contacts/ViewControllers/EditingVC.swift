//
//  EditingVC.swift
//  Contacts
//
//  Created by Bekzhan on 07.01.2023.
//

import UIKit

protocol DeleteContactProtocol {
    func delete(_ index: Int)
}

protocol ChangeDataProtocol {
    func change(_ name: String, _ phone: String, _ index: Int, _ image: UIImage)
}

class EditingVC: UIViewController {
    
    var delegate: DeleteContactProtocol?
    var delegateChange: ChangeDataProtocol?
    
    let nameTF = UITextField()
    let phoneTF = UITextField()
    
    let deleteButton = CustomButton(backgroundColor: .systemRed, title: "Delete")
    let changeButton = CustomButton(backgroundColor: .systemBlue, title: "Change")
    
    var changed_name: String = ""
    var changed_phone: String = ""
    var index: Int?
    var gender: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Editing"
        
        nameTF.delegate = self
        phoneTF.delegate = self
        
        configureSaveButton()
        configureNameTF()
        configurePhoneTF()
        configureDeleteButton()
        
        self.view.backgroundColor = .white
        
        nameTF.text = changed_name
        phoneTF.text = changed_phone
    }
    
    
    @objc func deleteData() {
        delegate?.delete(index!)
        navigationController?.popViewController(animated: true)
    }
    
    
    @objc func changeButtonTapped() {
        
        if nameTF.text != "" && phoneTF.text != "" {
            changed_name = nameTF.text ?? ""
            changed_phone = phoneTF.text ?? ""
            
            delegateChange?.change(changed_name, changed_phone, index!, gender!)
            
            navigationController?.popViewController(animated: true)
        }
    }
    
    func configureNameTF() {
        view.addSubview(nameTF)
        nameTF.placeholder = "Enter name"
        nameTF.borderStyle = .roundedRect
        nameTF.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameTF.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            nameTF.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            nameTF.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
            nameTF.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func configurePhoneTF() {
        view.addSubview(phoneTF)
        phoneTF.placeholder = "Enter phone"
        phoneTF.borderStyle = .roundedRect
        phoneTF.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            phoneTF.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            phoneTF.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            phoneTF.topAnchor.constraint(equalTo: nameTF.bottomAnchor, constant: 10),
            phoneTF.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func configureSaveButton() {
        view.addSubview(changeButton)
        changeButton.addTarget(self, action: #selector(changeButtonTapped), for: .touchUpInside)
        changeButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            changeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            changeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            changeButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),
            changeButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func configureDeleteButton() {
        view.addSubview(deleteButton)
        deleteButton.addTarget(self, action: #selector(deleteData), for: .touchUpInside)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            (deleteButton).leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            (deleteButton).trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            (deleteButton).bottomAnchor.constraint(equalTo: changeButton.topAnchor, constant: -10),
            (deleteButton).heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

extension EditingVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTF {
            phoneTF.becomeFirstResponder()
        } else if textField == phoneTF {
            textField.becomeFirstResponder()
        }
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
