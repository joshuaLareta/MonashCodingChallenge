//
//  InfoViewController.swift
//  Monash-coding-challenge
//
//  Created by Joshua on 22/7/20.
//  Copyright © 2020 Joshua. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {
    private struct Constant {
        static let rowHeight: CGFloat = 44 // act as the default height of our tableView
    }
    
    /// Main "manager" for the controller. think of it as the "ViewModel" which links data and ViewController together.
    let manager: InfoManager
    
    let infoView = InfoView()

    lazy var leftBarButton: UIBarButtonItem = {
        return UIBarButtonItem(customView: infoView)
    }()
    
    lazy var rightBarButtons: [UIBarButtonItem] = {
        let searchImage = UIImageView(image: UIImage(named: "search"))
        let profileImage = UIImageView(image: UIImage(named: "profile"))
        return [UIBarButtonItem(customView: profileImage), UIBarButtonItem(customView: searchImage)]
    }()
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundView = nil
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.estimatedRowHeight = Constant.rowHeight
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    override func loadView() {
        let mainView = UIView(frame: UIScreen.main.bounds)
        mainView.backgroundColor = .backgroundColor
        mainView.addSubview(tableView)
        self.view = mainView
        setupConstraints()
    }
    
    private func setupConstraints() {
        // Setting up horizontal constraints for the tableview
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[tableView]|",
                                                                options: [],
                                                                metrics: nil,
                                                                views: ["tableView": tableView]))
        // Setting up the vertical constraints
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[tableView]|",
                                                                options: [],
                                                                metrics: nil,
                                                                views: ["tableView": tableView]))
        
    }
    
    init(manager: InfoManager){
        self.manager = manager
        super.init(nibName: nil, bundle: nil)
        setupNavColor()
    }
    
    required init?(coder: NSCoder) {
       fatalError("Does not conform to NSCoding")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        infoView.update(title: "Title", subTitle: "subtitle")
        self.navigationItem.leftBarButtonItem = leftBarButton
        self.navigationItem.rightBarButtonItems = rightBarButtons
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.hideHairline()
    }
}

extension InfoViewController {
    private func setupNavColor() {
        UINavigationBar.appearance().barTintColor = .backgroundColor
    }
}

extension InfoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let v = UIView()
            v.backgroundColor = .blue
            return v
        }
        return nil
    }
}
extension InfoViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return manager.totalItems()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return manager.numberOfItems(forSection: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.identifier, for: indexPath)
        return cell
    }
}
