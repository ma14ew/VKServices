//
//  ServicesTableViewController
//  VK2023
//
//  Created by Матвей Матюшко on 19.02.2023.
//


import UIKit

class ServicesTableViewController: UIViewController {
    
    private let service = Service()
    
    private let cellIdentifier = "ServicesCellViewController"
    
    private var model: [AboutServicesModel] = []
    
    private lazy var tableView: UITableView = {
        var tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.separatorInset = UIEdgeInsets(top: 0 , left: 82, bottom: 0, right: 16)
        tableView.rowHeight = 70
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        tableView.register(ServicesCellViewController.self, forCellReuseIdentifier: cellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        servicesLoading()
    }
    
    private func setupViews() {
        self.view.backgroundColor = .systemBackground
        self.navigationItem.title = "Проекты ВК"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        view.addSubview(tableView)
    }
    
    
    private func setupConstraints() {
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    }
    
    private func servicesLoading() {
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        DispatchQueue.main.async {
            self.service.getDataURL() { array, error in
                guard let array = array else {
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        let alert = self.createAlert()
                        self.present(
                            alert,
                            animated: true,
                            completion: nil
                        )
                    }
                    return
                }
                
                for i in 0..<array.count {
                    self.model.append(AboutServicesModel(name: array[i]["name"] ?? "error",
                                                         description: array[i]["description"] ?? "error",
                                                         icon_url: array[i]["icon_url"] ?? "error",
                                                         service_url: array[i]["service_url"] ?? "error"))
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: DispatchQueue.main) { [weak self] in
            guard let self = self else {return}
            self.tableView.reloadData()
        }
    }
    
    private func createAlert() -> UIAlertController {
        let alert = UIAlertController(
            title: "Ошибка",
            message: "Не удалось загрузить данные",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Попробовать еще раз", style: .default, handler: {(action:UIAlertAction!) in
            self.servicesLoading()
        }))
        return alert
    }
}

extension ServicesTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? ServicesCellViewController
        let viewModel = model[indexPath.row]
        cell?.configureText(viewModel)
        cell?.configurePhoto(viewModel)
        return cell ?? UITableViewCell()
    }
}

extension ServicesTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = AboutServiceViewController(services: model[indexPath.row])
        navigationController?.pushViewController(vc, animated: true)
        tableView.reloadData()
    }
}



