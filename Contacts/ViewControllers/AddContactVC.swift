import UIKit

protocol AddContactProtocol {
    func save(name: String, phone: String)
}

class AddContactVC: UIViewController {
    
    var delegate: AddContactProtocol?
    var contactImageData: Data? // Optional data for the contact image
    
    var timer: Timer!
    
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
        let button = CustomButton(backgroundColor: .systemBlue, title: "Save")
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(handleSave(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var errorLabel: UILabel = {
        let label = UILabel()
        label.text = "Please fill in all text fields!!!"
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        nameTextField.delegate = self
        phoneTextField.delegate = self
        setupView()
        
        // Display the contact image if available
        if let imageData = contactImageData {
            let image = UIImage(data: imageData)
            // Here, you can display 'image' in your UI
        }
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(stopTimer), userInfo: nil, repeats: true)
    }
    
    @objc func stopTimer() {
        errorLabel.textColor = .white
        timer.invalidate()
    }
}

extension AddContactVC {
    func setupView() {
        view.addSubview(nameTextField)
        view.addSubview(phoneTextField)
        view.addSubview(errorLabel)
        view.addSubview(saveButton)
        setupConstraints()
    }
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 57),
            nameTextField.heightAnchor.constraint(equalToConstant: 44),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            phoneTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20),
            phoneTextField.heightAnchor.constraint(equalToConstant: 44),
            phoneTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            phoneTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            errorLabel.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor, constant: 20),
            errorLabel.heightAnchor.constraint(equalToConstant: 44),
            errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            saveButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    @objc func handleSave(_ sender: UIButton) {
        if nameTextField.text != "" && phoneTextField.text != "" {
            delegate?.save(name: nameTextField.text!, phone: phoneTextField.text!)
            dismiss(animated: true, completion: nil)
        } else {
            errorLabel.textColor = .systemRed
        }
        
        startTimer()
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
            textField.becomeFirstResponder()
        }
        return true
    }
}
