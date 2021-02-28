//
//  ViewController.swift
//  TestPryaniky
//
//  Created by Oleg on 22.02.2021.

import UIKit

enum Elements: String {
    case hz, picture, selector
}

class ViewController: UIViewController {
    
    var object: ModelData? = nil
    var myTableView = UITableView()
    var label: UILabel?
    var viewForInfoLabel: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createTV()
        NetworkService.fetch { [weak self] json in
            self?.object = json
            self?.myTableView.reloadData()
        }
    }
    
    func createTV() {
        view.addSubview(myTableView)
        myTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            myTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            myTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            myTableView.topAnchor.constraint(equalTo: view.topAnchor),
            myTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.register(TextTableViewCell.self, forCellReuseIdentifier: TextTableViewCell.identifier)
        myTableView.register(UINib(nibName: String(describing: SelectorTableViewCell.self), bundle: nil), forCellReuseIdentifier: SelectorTableViewCell.identifier)
        myTableView.register(UINib(nibName: String(describing: PictureTableViewCell.self), bundle: nil), forCellReuseIdentifier: PictureTableViewCell.identifier)
        myTableView.tableFooterView = UIView()
    }
    
    func informView(text: String) {
        viewForInfoLabel = UIView()
        guard let temporarilyView = viewForInfoLabel else {return}
        view.addSubview(temporarilyView)
        temporarilyView.translatesAutoresizingMaskIntoConstraints = false
        label = UILabel()
        guard let lab = label else {return}
        temporarilyView.addSubview(lab)
        lab.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            temporarilyView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            temporarilyView.topAnchor.constraint(equalTo: view.topAnchor),
            temporarilyView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            temporarilyView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            lab.centerXAnchor.constraint(equalTo: temporarilyView.centerXAnchor),
            lab.bottomAnchor.constraint(equalTo: temporarilyView.bottomAnchor, constant: -50),
        ])
        lab.numberOfLines = 0
        lab.textAlignment = .center
        lab.textColor = .systemBlue
        lab.text = text
        lab.layer.borderWidth = 1
        lab.layer.borderColor = UIColor.gray.cgColor
        lab.layer.cornerRadius = 5
        lab.clipsToBounds = true
        UIView.transition(with: lab,
                          duration: 2,
                          options: [.autoreverse]) {
            self.label!.layoutIfNeeded()
        } completion: { (_) in
            temporarilyView.removeFromSuperview()
            self.viewForInfoLabel = nil
            self.label = nil
        }
    }
}

//MARK: extension UITableViewDelegate, UITableViewDataSource
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let number = object?.view.count else {return 0}
        return number
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let name = object?.view[indexPath.row]
        object?.data.forEach({ (element) in
            if element.name == name{
                if let text = element.data.text {
                    let textStr = "element: \(element.name)\ncontent: \(text) "
                    informView(text: textStr)
                } else {
                    let textStr = "element: \(element.name)\ncontent: no description"
                    informView(text: textStr)
                }
                
            }
        })
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let element = object?.view[indexPath.row]
        switch element {
            case Elements.hz.rawValue:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: TextTableViewCell.identifier, for: indexPath) as? TextTableViewCell else {return UITableViewCell()}
                if let element = object?.data.first(where: {$0.name == Elements.hz.rawValue}){
                    cell.configure(element: element.data)
                }
                return cell                
            case Elements.picture.rawValue:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: PictureTableViewCell.identifier, for: indexPath) as? PictureTableViewCell else {return UITableViewCell()}
                if let element = object?.data.first(where: {$0.name == Elements.picture.rawValue}) {
                    cell.configure(element: element.data)
                }
                return cell
            case Elements.selector.rawValue:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: SelectorTableViewCell.identifier, for: indexPath) as? SelectorTableViewCell else {return UITableViewCell()}
                if let element = object?.data.first(where: {$0.name == Elements.selector.rawValue}) {
                    cell.configure(elements: element.data)
                }
                cell.delegat = self
                return cell
            default:
                return UITableViewCell()
        }
    }
    
}

//MARK: extension SelectorTableViewCellProtocol
extension ViewController: SelectorTableViewCellProtocol {
    func setSelectedId(id: Int) {
        if self.object != nil {
            var index = 0
            for i in object!.data {
                if i.name == Elements.selector.rawValue {
                    object?.data[index].data.selectedId = id
                    break
                }
                index += 1
            }
        }
    }
    
    func transitionText(text: String){
        self.informView(text: text)
    }
}

