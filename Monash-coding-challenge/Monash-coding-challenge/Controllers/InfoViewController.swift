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
        static let rowHeight: CGFloat = 100 // act as the default height of our tableView
        static let navigationButtonSize: CGFloat = 24
        static let tableOffset: CGFloat = 20
    }
    
    /// Main "manager" for the controller. think of it as the "ViewModel" which links data and ViewController together.
    let manager: InfoManager
    // The view being displayed in replacement of the left bar button on the navigation controller. This displays a title and subtitle
    let infoView = InfoView()

    lazy var leftBarButton: UIBarButtonItem = {
        return UIBarButtonItem(customView: infoView)
    }()
    
    lazy var rightBarButtons: [UIBarButtonItem] = {
        // fetch the image from system as its not in the assets that was given
        let bell = UIImageView(image: UIImage(systemName: "bell", withConfiguration: UIImage.SymbolConfiguration(pointSize: Constant.navigationButtonSize, weight: .semibold))?.withTintColor(.black, renderingMode: .alwaysOriginal))
        let profileImage = UIImageView(image: UIImage(named: "profile"))
        return [UIBarButtonItem(customView: profileImage), UIBarButtonItem(customView: bell)]
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundView = nil
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.estimatedRowHeight = Constant.rowHeight
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.identifier)
        tableView.register(TimeAndInfoTableViewCell.self, forCellReuseIdentifier: TimeAndInfoTableViewCell.identifier)
        tableView.register(TableViewSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: TableViewSectionHeaderView.identifier)
        tableView.contentInset = UIEdgeInsets(top: Constant.tableOffset, left: 0, bottom: 0, right: 0)
        tableView.scrollIndicatorInsets = UIEdgeInsets(top: Constant.tableOffset, left: 0, bottom: 0, right: 0)
        tableView.setContentOffset(CGPoint(x: 0, y: -Constant.tableOffset), animated: false)
        tableView.separatorStyle = .none
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
    
    /// This method sets up the constraints of the view. Adding all the needed element and with the use of VFL we add those constraints accordingly
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
    /// Method that updates the navigation color.
    ///
    /// Since we don't have root that sets things up. The first instance of a controller should be controlling the overview appearance of a navigationbar.
    private func setupNavColor() {
        UINavigationBar.appearance().barTintColor = .backgroundColor
    }
}

// TableViews Delegate methods
extension InfoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section == 0 else { return nil }
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: TableViewSectionHeaderView.identifier) else { return nil }
        return header
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? TimeAndInfoTableViewCell else { return }
         cell.addShadow(tableView, indexPath: indexPath)
    }
}
// TableView's DataSource methods
extension InfoViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return manager.totalItems()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return manager.numberOfItems(forSection: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TimeAndInfoTableViewCell.identifier, for: indexPath) as? TimeAndInfoTableViewCell else { return tableView.dequeueReusableCell(withIdentifier: UITableViewCell.identifier, for: indexPath) }
        cell.updateCellDistribution(width: self.view.frame.width - 40)
        return cell
    }
}
