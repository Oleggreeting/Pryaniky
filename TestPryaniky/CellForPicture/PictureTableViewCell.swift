//
//  PictureTableViewCell.swift
//  TestPryaniky
//
//  Created by Oleg on 22.02.2021.
//

import UIKit
import Kingfisher

class PictureTableViewCell: UITableViewCell {
    
    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var myImage: UIImageView!
    static let identifier = "PictureTableViewCell"
    
    func configure(element: Content) {
        guard let url = element.url else {return}
        let urlString = URL(string: url)
        self.myImage.kf.setImage(with: urlString)
        guard let text = element.text else {return}
        self.myLabel.text = text
    }
    
}
