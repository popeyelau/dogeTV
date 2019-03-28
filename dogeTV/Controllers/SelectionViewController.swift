//
//  SelectionViewController.swift
//  dogeTV
//
//  Created by Popeye Lau on 2019/3/28.
//  Copyright © 2019 Popeye Lau. All rights reserved.
//

import UIKit


class PopoverPresentation: NSObject, UIPopoverPresentationControllerDelegate {
    
    static let sharedInstance = PopoverPresentation()
    
    override init() {
        super.init()
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    static func configurePresentation(forController controller : UIViewController) -> UIPopoverPresentationController {
        controller.modalPresentationStyle = .popover
        let presentationController = controller.presentationController as! UIPopoverPresentationController
        presentationController.backgroundColor = .white
        presentationController.delegate = PopoverPresentation.sharedInstance
        return presentationController
    }
    
}


class SelectionViewController<Element> : UITableViewController {
    
    typealias SelectionHandler = (Element) -> Void
    typealias LabelProvider = (Element) -> String
    
    private let values : [Element]
    private let labels : LabelProvider
    private let onSelect : SelectionHandler?
    
    init(_ values : [Element], labels : @escaping LabelProvider = String.init(describing:), onSelect : SelectionHandler? = nil) {
        self.values = values
        self.onSelect = onSelect
        self.labels = labels
        super.init(style: .plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorColor = .groupTableViewBackground
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorInset = .zero
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return values.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = labels(values[indexPath.row])
        cell.textLabel?.textColor = .darkGray
        cell.textLabel?.font = .systemFont(ofSize: 13)
        cell.imageView?.image = UIImage(named: "line")
        cell.imageView?.tintColor = .darkGray
        cell.textLabel?.textAlignment = .center
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true)
        onSelect?(values[indexPath.row])
    }
    
}

