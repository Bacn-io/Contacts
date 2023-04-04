//
//  ViewController.swift
//  Contacts
//
//  Created by Bekzhan on 06.01.2023.
//


import UIKit


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
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as? CustomTableViewCell
        cell?.configureCell(name: contacts[indexPath.row].name, phone: contacts[indexPath.row].phone, image: contacts[indexPath.row].image)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailVC = EditingVC()
        detailVC.index = indexPath.row
        detailVC.gender = contacts[indexPath.row].image
        detailVC.changed_name = contacts[indexPath.row].name
        detailVC.changed_phone = contacts[indexPath.row].phone
        detailVC.delegate = self
        detailVC.delegateChange = self
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    //    delete with swipe
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            contacts.remove(at: indexPath.row)
            self.tableView.reloadData()
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
//        tableView.pin(to: view)
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
        print("plus pressed")
    }
}

extension ViewController: AddContactProtocol, DeleteContactProtocol, ChangeDataProtocol {
    
    func save(name: String, phone: String, image: UIImage) {
        contacts.append(Contact.init(image: image, name: name, phone: phone))
        self.tableView.reloadData()
    }
    
    func delete(_ index: Int) {
        contacts.remove(at: index)
        self.tableView.reloadData()
    }
    
    func change(_ name: String, _ phone: String, _ index: Int, _ image: UIImage) {
        contacts[index] = Contact.init(image: image, name: name, phone: phone)
        self.tableView.reloadData()
    }
}

extension ViewController: UITextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        if textField == searchBar {
//            searchBar.becomeFirstResponder()
//        } else if textField == phoneTextField {
//            textField.becomeFirstResponder()
//        }
//        return true
//    }
}
