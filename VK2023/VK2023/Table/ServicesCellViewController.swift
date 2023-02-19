//
//  ServicesCellViewController.swift
//  VK2023
//
//  Created by Матвей Матюшко on 19.02.2023.
//

import UIKit

class ServicesCellViewController: UITableViewCell{
    
    private let service = Service()
    
    private lazy var headerText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 30)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var photoImage: UIImageView = {
        let photo = UIImageView()
        photo.translatesAutoresizingMaskIntoConstraints = false
        photo.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        photo.layer.cornerRadius = 20
        photo.layer.backgroundColor = UIColor(red: 0.965, green: 0.965, blue: 0.965, alpha: 1).cgColor
        photo.contentMode = .scaleAspectFit
        return photo
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(headerText)
        contentView.addSubview(photoImage)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configureText(_ viewModel: AboutServicesModel) {
        headerText.text = viewModel.name
    }
    
    func configurePhoto(_ viewModel: AboutServicesModel){
        service.loadImage(urlString: viewModel.icon_url) { image, error in
            guard let image = image else {
                return
            }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.photoImage.image = image
            }
        }
    }
    
    private func setupConstraints() {
        headerText.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        headerText.leftAnchor.constraint(equalTo: photoImage.rightAnchor, constant: 10).isActive = true
        headerText.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        
        photoImage.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
        photoImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        photoImage.widthAnchor.constraint(equalToConstant: 50).isActive = true
        photoImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
}


