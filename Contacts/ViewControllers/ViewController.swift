import UIKit
import Contacts

class ViewController: UIViewController {
    
    var contacts: [Contact] = []
    
    var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.barStyle = .default
        searchBar.placeholder = "Search"
        searchBar.backgroundColor = .white
        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = UIColor.white.cgColor
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "CustomTableViewCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchContacts()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! CustomTableViewCell
        if let imageData = contacts[indexPath.row].image {
            cell.configureCell(name: contacts[indexPath.row].name, phone: contacts[indexPath.row].phone, image: UIImage(data: imageData))
        } else {
            cell.configureCell(name: contacts[indexPath.row].name, phone: contacts[indexPath.row].phone, image: nil)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailVC = EditingVC()
        detailVC.index = indexPath.row
        detailVC.changed_name = contacts[indexPath.row].name
        detailVC.changed_phone = contacts[indexPath.row].phone
        detailVC.delegate = self
        detailVC.delegateChange = self
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            contacts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

extension ViewController {
    func setupView() {
        navigationItem.title = "Contacts"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(handlePlus))
        
        view.backgroundColor = .white
        view.addSubview(searchBar)
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchBar.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32)
        ])
    }
    
    @objc func handlePlus() {
        let vc = AddContactVC()
        vc.delegate = self
        self.present(vc, animated: true)
    }
}

extension ViewController: AddContactProtocol, DeleteContactProtocol, ChangeDataProtocol {
    func change(_ name: String, _ phone: String, _ index: Int, _ image: UIImage) {
        if let imageData = image.pngData() { // Convert UIImage to Data
            contacts[index] = Contact(name: name, phone: phone, image: imageData, identifier: "")
            tableView.reloadData()
        } else {
            print("Failed to convert image to data")
        }
    }
    
    func save(name: String, phone: String) {
        contacts.append(Contact(name: name, phone: phone, image: nil, identifier: ""))
        tableView.reloadData()
    }
    
    func delete(_ index: Int) {
        contacts.remove(at: index)
        tableView.reloadData()
    }
    
    func change(_ name: String, _ phone: String, _ index: Int) {
        contacts[index] = Contact(name: name, phone: phone, image: nil, identifier: "")
        tableView.reloadData()
    }
}

extension ViewController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    func fetchContacts() {
        let store = CNContactStore()
        let keys = [CNContactGivenNameKey, CNContactPhoneNumbersKey, CNContactImageDataKey, CNContactIdentifierKey] as [CNKeyDescriptor] // Include CNContactIdentifierKey
        let request = CNContactFetchRequest(keysToFetch: keys)

        do {
            try store.enumerateContacts(with: request) { (contact, stop) in
                let name = contact.givenName
                let phone = contact.phoneNumbers.first?.value.stringValue ?? ""
                let identifier = contact.identifier
                if let imageData = contact.imageData {
                    let contactModel = Contact(name: name, phone: phone, image: imageData, identifier: identifier)
                    self.contacts.append(contactModel)
                } else {
                    let contactModel = Contact(name: name, phone: phone, image: nil, identifier: identifier)
                    self.contacts.append(contactModel)
                }
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print("Failed to fetch contacts:", error)
        }
    }
}
