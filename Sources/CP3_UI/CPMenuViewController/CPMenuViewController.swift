//
//  CPMenuViewController.swift
//  CP3_UI
//
//  Created by Corné on 29/04/2020.
//  Copyright © 2020 cp3.io. All rights reserved.
//

import UIKit
import MessageUI

open class CPMenuViewController: UIViewController, ShowErrorAlert {
    
    public typealias MenuItems = [(String, [CPTableViewItem])]
    
    // MARK: - Static properties
    
    public static let width: CGFloat = 280
    
    // MARK: - Private properties
    
    public lazy var menuBarButtonItem: UIBarButtonItem = {
        
        let bundle = Bundle(for: CPMenuViewController.self)
        let menuImage = UIImage(named: "menu", in: bundle, compatibleWith: nil)
        let menuBarButtonItem = UIBarButtonItem(
            image: menuImage,
            style: .plain,
            target: self,
            action: #selector(menuButtonTapped))
        
        return menuBarButtonItem
    }()
    
    private lazy var blurEffect = UIBlurEffect(style: .dark)
    private lazy var blurView: UIVisualEffectView = {
        
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()

    private lazy var tableView: UITableView = {
        
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.indicatorStyle = .white
        
        tableView.register(
            CPTableViewCell.self,
            forCellReuseIdentifier: String(describing: CPTableViewCell.self))
        
        return tableView
    }()
    
    private lazy var hideKeyboardTapGestureRecognizer = UITapGestureRecognizer(
        target: self,
        action: #selector(hideKeyboard))
    
    open var items: MenuItems
    
    // MARK: - Initialization
    
    public init(items: MenuItems) {
        self.items = items
        
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        
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
        
        configureNavigationBar()
        
        navigationController?.delegate = self
        
        // add notifications
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
        
        view.addGestureRecognizer(hideKeyboardTapGestureRecognizer)
        hideKeyboardTapGestureRecognizer.isEnabled = false
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    // MARK: - Configuration
    
    private func configureNavigationBar() {
        
        navigationItem.leftBarButtonItems = [menuBarButtonItem]
        
        // remove 'back' text on navigation bar back button
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    // MARK: - Selectors
    
    @objc private func keyboardWillShow(_ sender: Notification) {
        hideKeyboardTapGestureRecognizer.isEnabled = true
    }
    
    @objc private func keyboardWillHide(_ sender: Notification) {
        hideKeyboardTapGestureRecognizer.isEnabled = false
    }
    
    @objc private func hideKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc open func menuButtonTapped(_ sender: UIBarButtonItem) { }
    
    #if AUv3
    @objc private func inputModeChanged(_ sender: UISegmentedControl) {
        
        if let inputMode = MidiInputMode(rawValue: sender.selectedSegmentIndex) {
            delegate?.inputModeChanged(inputMode)
        }
    }
    #endif
    
    // MARK: - Helpers
    
    public func reloadData() {
        tableView.reloadData()
    }
    
    public func openUrlInHost(url: URL?) {
        let selector = sel_registerName("openURL:")
        var responder = self as UIResponder?
        while let r = responder, !r.responds(to: selector) {
            responder = r.next
        }
        _ = responder?.perform(selector, with: url)
    }
    
    open func didSelectItem(_ item: CPTableViewItem) {}
}

extension CPMenuViewController: UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Array(items)[section].0
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Array(items)[section].1.count
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = Array(items)[indexPath.section].1[indexPath.row]
//        let cell = item.cell(with: ColorTheme.red.uiColor)
        let cell = UITableViewCell()
        cell.accessoryType = item.accessoryType
        return cell
        
        //        switch item {
        //        case .name:
        //            let cell = CPTextFieldTableViewCell()
        //            cell.backgroundColor = .clear
        //            cell.configure(
        //                withText: pattern.title,
        //                callback: { [weak self] text in
        //                    self?.delegate?.setPatternTitle(text)
        //            })
        //
        //            return cell
        //
        //        #if !AUv3
        //        case .link:
        //            let cell = CPTableViewCell(style: .value1, reuseIdentifier: nil)
        //            cell.textLabel?.text = item.description
        //            cell.accessoryType = item.accessoryType
        //            cell.backgroundColor = .clear
        //            cell.imageView?.image = item.image
        //            cell.detailTextLabel?.text = CKAudioController.shared().isLinkEnabled ? "on" : "off"
        //
        //            return cell
        //        #else
        //        case .swing:
        //            let cell = CPSliderTableViewCell()
        //            cell.backgroundColor = .clear
        //
        //            let viewModel = CPSliderTableViewCell.ViewModel(
        //                title: item.description,
        //                range: (minimum: 0, maximum: 100),
        //                value: Double(selectedSnapshot.swing),
        //                unitString: "%")
        //            cell.configure(
        //                viewModel: viewModel,
        //                callback: { [weak self] value in
        //                    self?.delegate?.setSwingValue(Int(value))
        //            })
        //            return cell
        //
        //        case .scale:
        //            let cell = CPTableViewCell(style: .value1, reuseIdentifier: nil)
        //            cell.backgroundColor = .clear
        //            cell.textLabel?.text = item.description
        //            cell.detailTextLabel?.text = selectedSnapshot.scale.description.capitalized
        //            cell.accessoryType = .disclosureIndicator
        //            return cell
        //
        //        case .key:
        //            let cell = CPTableViewCell(style: .value1, reuseIdentifier: nil)
        //            cell.backgroundColor = .clear
        //            cell.textLabel?.text = item.description
        //            cell.detailTextLabel?.text = selectedSnapshot.key.description.capitalized
        //            cell.accessoryType = .disclosureIndicator
        //            return cell
        //
        //        case .inputMode:
        //            let cell = CPTableViewCell(style: .value1, reuseIdentifier: nil)
        //            cell.textLabel?.text = "Input"
        //            cell.backgroundColor = .clear
        //
        //            let items = MidiInputMode.allCases.map { $0.description }
//                    let segmentedControl = UISegmentedControl(items: items)
//                    if #available(iOS 13.0, *) {
//                        segmentedControl.selectedSegmentTintColor = Color.red
//                    } else {
//                        segmentedControl.tintColor = Color.red
//                    }
        //            segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        //            cell.addSubview(segmentedControl)
        //            segmentedControl.rightAnchor.constraint(equalTo: cell.rightAnchor, constant: -15).isActive = true
        //            segmentedControl.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
        //            segmentedControl.selectedSegmentIndex = selectedSnapshot.channels[0].inputMode.rawValue
        //            segmentedControl.addTarget(self, action: #selector(inputModeChanged), for: .valueChanged)
        //
        //            return cell
        //
        //        case .midiOutputChannel:
        //            let cell = CPTableViewCell()
        //            cell.textLabel?.text = "Output channel"
        //            cell.backgroundColor = .clear
        //
        //            let valueControl = CPValueControl()
        //            valueControl.minimumValue = 1
        //            valueControl.maximumValue = 16
        //            cell.addSubview(valueControl)
        //            valueControl.rightAnchor.constraint(equalTo: cell.rightAnchor).isActive = true
        //            valueControl.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
        //
        //            valueControl.value = selectedSnapshot.channels[0].midiOutputChannel + 1
        //            valueControl.actionCallback = { [weak self] in
        //                self?.selectedSnapshot.channels[0].midiOutputChannel = $0 - 1
        //            }
        //
        //            return cell
        //
        //        case .copy:
        //            let cell = CPTableViewCell(style: .subtitle, reuseIdentifier: nil)
        //            cell.textLabel?.text = item.description
        //            cell.detailTextLabel?.text = "Copy current pattern to clipboard"
        //            cell.accessoryType = item.accessoryType
        //            cell.backgroundColor = .clear
        //            cell.imageView?.image = item.image
        //
        //            return cell
        //
        //        case .paste:
        //            let cell = CPTableViewCell(style: .subtitle, reuseIdentifier: nil)
        //            cell.textLabel?.text = item.description
        //            cell.detailTextLabel?.text = "Paste pattern into to this cykle instance"
        //            cell.accessoryType = item.accessoryType
        //            cell.backgroundColor = .clear
        //            cell.imageView?.image = item.image
        //
        //            return cell
        //        #endif
        //
        //        default:
        //            let cell = CPTableViewCell()
        //            cell.textLabel?.text = item.description
        //            cell.accessoryType = item.accessoryType
        //            cell.backgroundColor = .clear
        //            cell.imageView?.image = item.image
        //
        //            return cell
        //        }
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

extension CPMenuViewController: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = Array(items)[indexPath.section].1[indexPath.row]
        didSelectItem(item)
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let item = Array(items)[indexPath.section].1[indexPath.row]
        return item.cellHeight
    }
    
    public func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = Font.fontBold(ofSize: 14)
        header.textLabel?.textColor = ColorTheme.red.uiColor
    }
    
    public func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = Font.font(ofSize: 10)
    }
}

extension CPMenuViewController: UINavigationControllerDelegate {
    
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
        if viewController == self {
            self.view.alpha = 1
        } else {
            UIView.animate(withDuration: 0.4) {
                self.view.alpha = 0
            }
        }
    }
}

extension CPMenuViewController: MFMailComposeViewControllerDelegate {
    
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
        
        switch result {
        case .sent:
            let text = "Email sent! Thanks for your feedback."
            let alert = UIAlertController(title: nil, message: text, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                alert.dismiss(animated: true)
            }
            alert.addAction(okAction)
            present(alert, animated: true)
            
        case .failed:
            let text = "An error occurred while trying to send your email. Please try again."
            let alert = UIAlertController(title: nil, message: text, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                alert.dismiss(animated: true)
            }
            alert.addAction(okAction)
            present(alert, animated: true)
            
        default:
            break
        }
    }
}
