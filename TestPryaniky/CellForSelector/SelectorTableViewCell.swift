//
//  SelectorTableViewCell.swift
//  TestPryaniky
//
//  Created by Oleg on 22.02.2021.
//

import UIKit
protocol SelectorTableViewCellProtocol {
    func setSelectedId(id: Int)
    func transitionText(text: String)
}

class SelectorTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tableViewForSelector: UITableView!
    @IBOutlet weak var constraintHeightAllCell: NSLayoutConstraint!
    
    var elements: [Variant] = []
    var selectedId = 0
    static let identifier = "SelectorTableViewCell"
    var delegat: SelectorTableViewCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTV()
    }
    
    func setupTV() {
        tableViewForSelector.delegate = self
        tableViewForSelector.dataSource = self
        tableViewForSelector.register(UINib(nibName: String(describing: VariantTableViewCell.self),
                                            bundle: nil),
                                      forCellReuseIdentifier: VariantTableViewCell.identifier)
        tableViewForSelector.tableFooterView = UIView()
    }
    
    func configure(elements: Content) {
        guard let element = elements.variants else {return}
        self.elements = element
        guard let sId = elements.selectedId else {return}
        self.selectedId = sId
        self.constraintHeightAllCell.priority = UILayoutPriority(999)
        self.constraintHeightAllCell.constant = tableViewForSelector.rowHeight * CGFloat(self.elements.count)
        self.tableViewForSelector.reloadData()
    }
    
    @objc func selectedButton(_ sender: UIButton){        
        let oldSelected = tableViewForSelector.visibleCells[selectedId] as! VariantTableViewCell
        oldSelected.myButton.isSelected = false
        let newSelected = tableViewForSelector.visibleCells[sender.tag] as! VariantTableViewCell
        newSelected.myButton.isSelected = true
        self.selectedId = sender.tag
        delegat?.setSelectedId(id: sender.tag)
    }
}

extension SelectorTableViewCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: VariantTableViewCell.identifier, for: indexPath) as? VariantTableViewCell else {return UITableViewCell()}
        let element = elements[indexPath.row]
        cell.configuration(element: element)
        cell.myButton.tag = indexPath.row
        cell.myButton.addTarget(self, action: #selector(selectedButton(_:)), for: .touchUpInside)
        cell.myButton.isSelected = indexPath.row == selectedId

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let oldSelectedCell = tableView.visibleCells[selectedId] as! VariantTableViewCell
            oldSelectedCell.myButton.isSelected = false
            let cell = tableView.cellForRow(at: indexPath) as! VariantTableViewCell
            cell.myButton.isSelected = true
            let textStr = "element: selector\nselectedId: \(elements[indexPath.row].id)\ncontent: \(elements[indexPath.row].text)"
            self.delegat?.transitionText(text: textStr)
            self.selectedId = indexPath.row
            tableView.deselectRow(at: indexPath, animated: true)
            self.delegat?.setSelectedId(id: indexPath.row)
    }
}
