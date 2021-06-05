//
//  ViewController.swift
//  CryptoTracker
//
//  Created by Abhishek Kumar on 05/06/21.
//

import UIKit

class ViewController: UIViewController {
    
    private let tableView: UITableView = {
        $0.register(CryptoTableViewCell.self,
                    forCellReuseIdentifier: CryptoTableViewCell.identifer)
        return $0
    }(UITableView(frame: .zero, style: .grouped))
    
    static let numberFormatter: NumberFormatter = {
        $0.locale = .current
        $0.numberStyle = .currency
        $0.formatterBehavior = .default
        $0.allowsFloats = true
        $0.roundingMode = .ceiling
        return $0
    }(NumberFormatter())
    
    var viewModels = [CryptoTableViewCellViewModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "CryptoTracker"
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        APICaller.shared.getCryptoData { [weak self] (result) in
            switch result {
            case .success(let models):
                self?.viewModels = models.compactMap { model in
                    let iconURL = URL(string: APICaller.shared.icon.filter({ icon  in
                        icon.assetID == model.assetID
                    }).first?.url ?? "")
                    return CryptoTableViewCellViewModel(name: model.name ?? "N/A",
                                                 symbol: model.assetID,
                                                 price: Self.numberFormatter.string(from: NSNumber(value: Double(model.priceUsd ?? 0))) ?? "N/A",
                                                 icon_url: iconURL)
                }
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
}

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CryptoTableViewCell.identifer,
                                                       for: indexPath) as? CryptoTableViewCell else{
            fatalError()
        }
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

}

