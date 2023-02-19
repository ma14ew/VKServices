//
//  AboutServiceViewController
//  VK2023
//
//  Created by Матвей Матюшко on 19.02.2023.
//
//


import Foundation
import UIKit
import SafariServices

class AboutServiceViewController: UIViewController, SFSafariViewControllerDelegate {
    
    private let service = Service()
    
    private var services: AboutServicesModel?
    
    init(services: AboutServicesModel){
        self.services = services
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private  lazy var photoImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.sizeToFit()
        return image
    }()
    
    private  lazy var titleText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 40)
        return label
    }()
    
    private lazy var descriptionText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 5
        label.font = .systemFont(ofSize: 25)
        return label
    }()
    
    private lazy var webButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.blue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 25)
        button.layer.cornerRadius = 19
        button.clipsToBounds = true
        button.tintColor = .blue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(webButtonTaped), for: .touchUpInside)
        return button
    }()
    
    @objc private func webButtonTaped() {
        guard let url = URL(string: self.services!.service_url) else { return }
        let safariVC = SFSafariViewController(url: url)
        safariVC.delegate = self
        present(safariVC, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        if let services = services {
            titleText.text = services.name
            descriptionText.text = services.description
            webButton.setTitle(services.service_url, for: .normal)
            service.loadImage(urlString: services.icon_url) { image, error in
                guard let image = image else {
                    return
                }
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.photoImage.image = image
                }
            }
        }
    }
    
    private func setupViews(){
        view.backgroundColor = .systemBackground
        view.addSubview(photoImage)
        view.addSubview(titleText)
        view.addSubview(descriptionText)
        view.addSubview(webButton)
    }
    
    private func setupConstraints(){
        photoImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        photoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        photoImage.widthAnchor.constraint(equalToConstant: 200 ).isActive = true
        photoImage.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        titleText.topAnchor.constraint(equalTo: photoImage.bottomAnchor, constant: 10).isActive = true
        titleText.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        descriptionText.topAnchor.constraint(equalTo: titleText.bottomAnchor, constant: 10).isActive = true
        descriptionText.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        descriptionText.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant:-10).isActive = true
        descriptionText.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        webButton.topAnchor.constraint(equalTo: descriptionText.bottomAnchor, constant: 10).isActive = true
        webButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
    }
    
    
}
