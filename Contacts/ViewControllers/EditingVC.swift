import UIKit
import Contacts
import ContactsUI

class EditingVC: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var delegate: DeleteContactProtocol?
    var delegateChange: ChangeDataProtocol?
    var contacts: [Contact] = [] // Define the contacts array
    
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
        
        configureNameTF()
        configurePhoneTF()
        configureAddPhotoButton()
        configureChangeButton()
        configureDeleteButton()
        
        self.view.backgroundColor = .white
        
        nameTF.text = changed_name
        phoneTF.text = changed_phone
    }
    
    func configureNameTF() {
        view.addSubview(nameTF)
        nameTF.placeholder = "Enter name"
        nameTF.borderStyle = .roundedRect
        nameTF.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameTF.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            nameTF.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            nameTF.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
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
            phoneTF.topAnchor.constraint(equalTo: nameTF.bottomAnchor, constant: 20),
            phoneTF.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func configureDeleteButton() {
        view.addSubview(deleteButton)
        deleteButton.addTarget(self, action: #selector(deleteData), for: .touchUpInside)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            deleteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            deleteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            deleteButton.topAnchor.constraint(equalTo: changeButton.bottomAnchor, constant: 20),
            deleteButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func configureChangeButton() {
        view.addSubview(changeButton)
        changeButton.addTarget(self, action: #selector(changeButtonTapped), for: .touchUpInside)
        changeButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            changeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            changeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            changeButton.topAnchor.constraint(equalTo: addPhotoButton.bottomAnchor, constant: 20),
            changeButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func configureAddPhotoButton() {
        view.addSubview(addPhotoButton)
        addPhotoButton.addTarget(self, action: #selector(addPhotoButtonTapped), for: .touchUpInside)
        addPhotoButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            addPhotoButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            addPhotoButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            addPhotoButton.topAnchor.constraint(equalTo: phoneTF.bottomAnchor, constant: 20),
            addPhotoButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func deleteData() {
        guard let index = index else { return }
        delegate?.delete(index)
        navigationController?.popViewController(animated: true)
    }
    
    @objc func changeButtonTapped() {
        guard let name = nameTF.text, !name.isEmpty,
              let phone = phoneTF.text, !phone.isEmpty,
              let index = index else {
            let alert = UIAlertController(title: "Error", message: "Name and phone cannot be empty.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true)
            return
        }
        
        // Check for permission and then attempt to update the contact
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { [weak self] granted, error in
            if granted {
                guard let identifier = self?.contacts[index].identifier else { return }
                self?.updateContactInStore(name: name, phone: phone, image: self?.profileImage, identifier: identifier)
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Success", message: "Your changes have been saved.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self?.present(alert, animated: true)
                    self?.navigationController?.popViewController(animated: true)
                }
            } else {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Error", message: "Contact access denied. Please enable it in settings.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self?.present(alert, animated: true)
                }
            }
        }
    }
    
    func updateContactInStore(name: String, phone: String, image: UIImage?, identifier: String) {
        let store = CNContactStore()
        let keys = [CNContactGivenNameKey, CNContactPhoneNumbersKey, CNContactImageDataKey] as [CNKeyDescriptor]
        let request = CNSaveRequest()
        do {
            let predicate = CNContact.predicateForContacts(withIdentifiers: [identifier])
            let contacts = try store.unifiedContacts(matching: predicate, keysToFetch: keys)
            if let contact = contacts.first?.mutableCopy() as? CNMutableContact {
                contact.givenName = name
                contact.phoneNumbers = [CNLabeledValue(label: CNLabelPhoneNumberMain, value: CNPhoneNumber(stringValue: phone))]
                if let imageData = image?.jpegData(compressionQuality: 1.0) {
                    contact.imageData = imageData
                }
                request.update(contact)
                try store.execute(request)
                print("Contact updated successfully")
            }
        } catch {
            print("Failed to update contact: \(error)")
        }
    }
    
    @objc func addPhotoButtonTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary // Use .camera to allow taking a new photo
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            profileImage = editedImage
        }
        dismiss(animated: true, completion: nil)
    }
}
