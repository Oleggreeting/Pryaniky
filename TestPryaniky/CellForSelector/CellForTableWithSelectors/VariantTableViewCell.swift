//
//  VariantTableViewCell.swift
//  TestPryaniky
//
//  Created by Oleg on 22.02.2021.
//

import UIKit

class VariantTableViewCell: UITableViewCell {

    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var myButton: UIButton!
    
    static let identifier = "VariantTableViewCell"

    func configuration(element: Variant) {
        myLabel.text = element.text
    }
    
}
