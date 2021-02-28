//
//  TextTableViewCell.swift
//  TestPryaniky
//
//  Created by Oleg on 22.02.2021.
//

import UIKit

class TextTableViewCell: UITableViewCell {
    let label = UILabel()
    
    static let identifier = "TextTableViewCell"
    
    func createLabel(){
        self.contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        label.textAlignment = .center
        label.numberOfLines = 0
    }
    
    func configure(element: Content) {
        createLabel()
        label.text = element.text
    }
    
}
