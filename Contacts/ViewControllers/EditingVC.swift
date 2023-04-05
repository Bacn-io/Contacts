import UIKit
import Contacts
import ContactsUI

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
    let addPhotoButton = CustomButton(backgroundColor: .systemGreen, title: "Add Photo")
    
    var changed_name: String = ""
    var changed_phone: String = ""
    var index: Int?
    var profileImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Editing"
        
        nameTF.delegate = self
        phoneTF.delegate = self
        
        configureSaveButton()
        configureNameTF()
        configurePhoneTF()
        configureDeleteButton()
        configureAddPhotoButton()
        
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
            
            delegateChange?.change(changed_name, changed_phone, index!, profileImage ?? UIImage())
            
            navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func addPhotoButtonTapped() {
        let newContact = CNMutableContact() // Create a new instance of CNMutableContact
        let contactPicker = CNContactViewController(forUnknownContact: newContact)
        contactPicker.delegate = self
        contactPicker.allowsEditing = true
        contactPicker.view.backgroundColor = UIColor.white
        navigationController?.pushViewController(contactPicker, animated: true)
    }
    
    func configureNameTF() {
        view.addSubview(nameTF)
        nameTF.placeholder = "Enter name"
        nameTF.borderStyle = .roundedRect
        nameTF.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameTF.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            nameTF.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            nameTF.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20), // Anchor to safe area top
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
            phoneTF.topAnchor.constraint(equalTo: nameTF.bottomAnchor, constant: 20), // Anchor to nameTF bottom
            phoneTF.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func configureSaveButton() {
        // Configuration code
    }
    
    func configureDeleteButton() {
        // Configuration code
    }
    
    func configureAddPhotoButton() {
        view.addSubview(addPhotoButton)
        addPhotoButton.addTarget(self, action: #selector(addPhotoButtonTapped), for: .touchUpInside)
        addPhotoButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            addPhotoButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            addPhotoButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            addPhotoButton.topAnchor.constraint(equalTo: phoneTF.bottomAnchor, constant: 20), // Anchor to phoneTF bottom
            addPhotoButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

extension EditingVC: UITextFieldDelegate {
    // TextField Delegate methods
}

extension EditingVC: CNContactViewControllerDelegate {
    func contactViewController(_ viewController: CNContactViewController, didCompleteWith contact: CNContact?) {
        guard let contact = contact else {
            navigationController?.popViewController(animated: true)
            return
        }
        if let imageData = contact.thumbnailImageData, let image = UIImage(data: imageData) {
            profileImage = image
        }
        navigationController?.popViewController(animated: true)
    }
}
