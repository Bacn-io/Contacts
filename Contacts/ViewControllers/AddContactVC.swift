import UIKit
import Contacts

protocol AddContactProtocol {
    func save(name: String, phone: String, addToDeviceContacts: Bool)
}

class AddContactVC: UIViewController {
    
    var delegate: AddContactProtocol?
    
    var nameTextField: UITextField = {
        let textfield = UITextField()
        textfield.textColor = .black
        textfield.font = UIFont.systemFont(ofSize: 16)
        textfield.placeholder = "Enter name"
        textfield.borderStyle = .roundedRect
        textfield.layer.borderColor = UIColor.lightGray.cgColor
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    var phoneTextField: UITextField = {
        let textfield = UITextField()
        textfield.textColor = .black
        textfield.font = UIFont.systemFont(ofSize: 16)
        textfield.placeholder = "Enter phone"
        textfield.borderStyle = .roundedRect
        textfield.layer.borderColor = UIColor.lightGray.cgColor
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(handleSave(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var addToDeviceContactsSwitch: UISwitch = {
        let uiSwitch = UISwitch()
        uiSwitch.isOn = true // Default to saving to device contacts
        uiSwitch.translatesAutoresizingMaskIntoConstraints = false
        return uiSwitch
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        nameTextField.delegate = self
        phoneTextField.delegate = self
        setupView()
    }
    
    func setupView() {
        view.addSubview(nameTextField)
        view.addSubview(phoneTextField)
        view.addSubview(saveButton)
        view.addSubview(addToDeviceContactsSwitch)
        setupConstraints()
    }
    
    func setupConstraints() {
        // Constraints for nameTextField
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        // Constraints for phoneTextField
        NSLayoutConstraint.activate([
            phoneTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 10),
            phoneTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            phoneTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        // Constraints for addToDeviceContactsSwitch
        NSLayoutConstraint.activate([
            addToDeviceContactsSwitch.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor, constant: 10),
            addToDeviceContactsSwitch.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        // Constraints for saveButton
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: addToDeviceContactsSwitch.bottomAnchor, constant: 20),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            saveButton.heightAnchor.constraint(equalToConstant: 50) // Set the height of the save button
        ])
    }
    
    @objc func handleSave(_ sender: UIButton) {
        guard let name = nameTextField.text, let phone = phoneTextField.text else { return }
        
        let addToDeviceContacts = addToDeviceContactsSwitch.isOn
        delegate?.save(name: name, phone: phone, addToDeviceContacts: addToDeviceContacts)
        dismiss(animated: true, completion: nil)
    }
}

// Handle dismissing keyboard
extension AddContactVC: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            phoneTextField.becomeFirstResponder()
        } else if textField == phoneTextField {
            textField.resignFirstResponder()
        }
        return true
    }
}
