//
//  CPTableViewController.swift
//  CP3_UI
//
//  Created by Corné on 17/04/2020.
//  Copyright © 2020 cp3.io. All rights reserved.
//

import UIKit

public final class CPTableViewController: UIViewController {
    
    // MARK: - Private properties
    
    private (set) lazy var tableView: UITableView = {
        
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.backgroundColor = .clear
        tableView.indicatorStyle = .white
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.allowsSelection = true
        
        tableView.register(
            CPTableViewCell.self,
            forCellReuseIdentifier: String(describing: CPTableViewCell.self))
        
        return tableView
    }()
    
    private lazy var blurEffect = UIBlurEffect(style: .dark)
    private lazy var blurView: UIVisualEffectView = {
        
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let items: [CustomStringConvertible]
    private let selectedIndex: Int?
    private let callback: ((Int) -> Void)?
    
    // MARK: - Initialization
    
    public init(
        title: String,
        items: [CustomStringConvertible],
        selectedIndex: Int? = nil,
        callback: @escaping (Int) -> Void) {
        
        self.items = items
        self.selectedIndex = selectedIndex
        self.callback = callback
        
        super.init(nibName: nil, bundle: nil)
        
        self.title = title
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = title
        
        view.addSubview(blurView)
        blurView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        blurView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        blurView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        tableView.register(
            CPTableViewCell.self,
            forCellReuseIdentifier: String(describing: CPTableViewCell.self))
        
        tableView.allowsSelection = true
        tableView.backgroundColor = .clear
        tableView.indicatorStyle = .white
        
        // remove 'back' text on navigation bar back button
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let index = selectedIndex else { return }
        
        let selectedRow = IndexPath(row: index, section: 0)
        tableView.scrollToRow(at: selectedRow, at: .top, animated: true)
    }
}

extension CPTableViewController: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: CPTableViewCell.self),
            for: indexPath)
        
        let item = items[indexPath.row]
        cell.textLabel?.text = item.description
        cell.accessoryType = selectedIndex == indexPath.row ? .checkmark : .none
        cell.backgroundColor = .clear
        
        return cell
    }
}

extension CPTableViewController: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        callback?(indexPath.row)
        
        dismiss(animated: true)
        navigationController?.popViewController(animated: true)
    }
}
