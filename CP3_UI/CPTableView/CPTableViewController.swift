//
//  CPTableViewController.swift
//  CP3_UI
//
//  Created by Corné on 17/04/2020.
//  Copyright © 2020 cp3.io. All rights reserved.
//

import UIKit

public protocol CPTableViewItem: CustomStringConvertible {
    var image: UIImage? { get }
    var accessoryType: UITableViewCell.AccessoryType { get }
    var cellHeight: CGFloat { get }
    
    func cell(with color: UIColor) -> CPTableViewCell
}

public final class CPTableViewDataSourceDelegate: NSObject {
    
    private lazy var blurEffect = UIBlurEffect(style: .dark)
    private lazy var blurView: UIVisualEffectView = {
        
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let tableView: UITableView
    private var items = [(String, [CPTableViewItem])]()
    
    public var color: UIColor = Color.red {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - Initialization
    
    public init(tableView: UITableView, items: [(String, [CPTableViewItem])]) {
        self.tableView = tableView
        self.items = items
        
        super.init()
        
        configureTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure
    
    private func configureTableView() {
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.indicatorStyle = .white
        
        tableView.register(
            CPTableViewCell.self,
            forCellReuseIdentifier: CPTableViewCell.reuseIdentifier)
    }
}

extension CPTableViewDataSourceDelegate: UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Array(items)[section].0
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Array(items)[section].1.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = Array(items)[indexPath.section].1[indexPath.row]
        return item.cell(with: color)
    }
}

extension CPTableViewDataSourceDelegate: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = Array(items)[indexPath.section].1[indexPath.row]
        // TODO: implement?
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let item = Array(items)[indexPath.section].1[indexPath.row]
        return item.cellHeight
    }
    
    public func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = Font.fontBold(ofSize: 14)
        header.textLabel?.textColor = color
    }
    
    public func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = Font.font(ofSize: 10)
    }
}

