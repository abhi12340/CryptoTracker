//
//  CyptoTableViewCell.swift
//  CryptoTracker
//
//  Created by Abhishek Kumar on 05/06/21.
//

import Foundation
import UIKit

class CryptoTableViewCellViewModel {
    let name: String
    let symbol: String
    let price: String
    let icon_url: URL?
    var icon_data: Data?
    
    init(name: String,
         symbol: String,
         price: String,
         icon_url: URL?) {
        self.name = name
        self.symbol = symbol
        self.price = price
        self.icon_url = icon_url
    }
}

class CryptoTableViewCell: UITableViewCell {
    static let identifer = "CyptoTableViewCell"
    
    let name: UILabel = {
        $0.font = .systemFont(ofSize: 20, weight: .medium)
        return $0
    }(UILabel())
    
    let symbol: UILabel = {
        $0.font = .systemFont(ofSize: 17, weight: .regular)
        return $0
    }(UILabel())
    
    let price: UILabel = {
        $0.textColor = .systemGreen
        $0.textAlignment = .right
        $0.font = .systemFont(ofSize: 20, weight: .semibold)
        return $0
    }(UILabel())
    
    let currenyimageView: UIImageView = {
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(name)
        contentView.addSubview(symbol)
        contentView.addSubview(price)
        contentView.addSubview(currenyimageView)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let size: CGFloat = contentView.frame.size.height/1.1
        currenyimageView.frame = CGRect(x: 20,
                                        y: (contentView.frame.size.height - size)/2,
                                        width: size,
                                        height: size)
        
        name.sizeToFit()
        symbol.sizeToFit()
        price.sizeToFit()
        
        name.frame = CGRect(x: 30 + size,
                            y: 0,
                            width: contentView.frame.size.width / 2,
                            height: contentView.frame.size.height / 2)
        
        symbol.frame = CGRect(x: 30 + size,
                             y: contentView.frame.size.height / 2,
                             width: contentView.frame.size.width / 2,
                             height: contentView.frame.size.height / 2)
        
        price.frame = CGRect(x: contentView.frame.size.width / 2,
                             y: 0,
                             width: (contentView.frame.size.width / 2) - 15,
                             height: contentView.frame.size.height)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        name.text = nil
        symbol.text = nil
        price.text = nil
        currenyimageView.image = nil
    }
    
    func configure(with viewModel: CryptoTableViewCellViewModel) {
        name.text = viewModel.name
        symbol.text = viewModel.symbol
        price.text = viewModel.price
        
        if let  imageData = viewModel.icon_data  {
            currenyimageView.image = UIImage(data: imageData)
        } else {
            if let url = viewModel.icon_url {
                let task = URLSession.shared.dataTask(with: url) { [weak self] (data, _, _) in
                    if let data = data {
                        viewModel.icon_data = data
                        DispatchQueue.main.async {
                            self?.currenyimageView.image = UIImage(data: data)
                        }
                    }
                }
                task.resume()
            }
        }
    }
}
