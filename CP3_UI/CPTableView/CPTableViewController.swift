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
    
    func cell() -> CPTableViewCell
    func didSelect()
}

public final class CPTableViewController: UIViewController {
    
    private lazy var blurEffect = UIBlurEffect(style: .dark)
    private lazy var blurView: UIVisualEffectView = {
        
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private (set) lazy var tableView: UITableView = {
        
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(
            CPTableViewCell.self,
            forCellReuseIdentifier: CPTableViewCell.reuseIdentifier)
        
        return tableView
    }()
    
    private var items = [(String, [CPTableViewItem])]()
//        #if AUv3
//        return [
//            ("tempo and key", [.swing, .key, .scale]),
//            ("pattern", [.clear, .copy, .paste]),
//            ("MIDI", [.inputMode, .midiOutputChannel]),
//            ("settings", [.settings]),
//            ("help", [.manual, .about]),
//            ("contact", [.contact, .www])
//        ]
//        #else
//        return [
//            ("file", [.name, .save, .clear, .patterns]),
//            ("settings", [.link, .settings]),
//            ("help", [.manual, .about]),
//            ("contact", [.contact, .www, .rate])
//        ]
//        #endif
//    }
    
    // MARK: - Life cycle
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(blurView)
        blurView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        blurView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        blurView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -1).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
}

extension CPTableViewController: UITableViewDataSource {
    
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
        return item.cell()
    }
    
    public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        
        // display version information underneath last section
        if section == items.count - 1 {
            return "VERSION \(Bundle.main.infoDictionary!["CFBundleShortVersionString"]!), BUILD \(Bundle.main.infoDictionary!["CFBundleVersion"]!)"
        } else {
            return nil
        }
    }
}

extension CPTableViewController: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = Array(items)[indexPath.section].1[indexPath.row]
        item.didSelect()
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let item = Array(items)[indexPath.section].1[indexPath.row]
        return item.cellHeight
    }
    
    public func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = Font.fontBold(ofSize: 14)
        header.textLabel?.textColor = Color.red
    }
    
    public func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = Font.font(ofSize: 10)
    }
}

