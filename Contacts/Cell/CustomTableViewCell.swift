//
//  CustomTableViewCell.swift
//  Contacts
//
//  Created by Bekzhan on 06.01.2023.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    var imgView: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var phoneLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var vStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CustomTableViewCell {
    func setupView() {
        selectionStyle = .none
        backgroundColor = .white
        setupStackView()
    }
    
    func setupStackView() {
        vStackView.addArrangedSubview(nameLabel)
        vStackView.addArrangedSubview(phoneLabel)
        
        addSubview(imgView)
        addSubview(vStackView)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            imgView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            imgView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            imgView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            imgView.widthAnchor.constraint(equalToConstant: 50),
            imgView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            vStackView.leadingAnchor.constraint(equalTo: imgView.trailingAnchor, constant: 10),
            vStackView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            vStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            vStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
    }
    
    func configureCell(name: String?, phone: String?, image: UIImage?) {
        nameLabel.text = name
        phoneLabel.text = phone
        imgView.image = image
    }
}
