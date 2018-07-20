//
//  C.swift
//  DynamicDataSource
//
//  Created by L on 2018/7/19.
//  Copyright © 2018年 L. All rights reserved.
//

import UIKit

class C: UIViewController {
    
    let tableView = UITableView()
    let tableViewWidth = UIScreen.main.bounds.size.width
    let tableViewHeight = UIScreen.main.bounds.size.height
    
    static let cellIdentifier = "DynamicCell"
    
    var dataSource = [M]() {
        didSet {
            if oldValue.count > dataSource.count { // remove model and cancel it
                _ = oldValue.filter { !dataSource.contains($0) }.map { $0.cancel() }
            } else { // add model start it
                dataSource.last?.start()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.frame = CGRect(x: 0, y: 0, width: tableViewWidth, height: tableViewHeight/2)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(V.self, forCellReuseIdentifier: C.cellIdentifier)
        view.addSubview(tableView)
        
        view.backgroundColor = .cyan
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertDataSource))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dataSource.removeAll()
    }
    
    deinit {
        print("C deinit")
    }
    
}

extension C: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: C.cellIdentifier) as? V ?? V()
        
        let model = dataSource[indexPath.row]
        cell.m = model
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        guard editingStyle == .delete else { return }
        
        dataSource.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        
    }
    
}

extension C: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let m = dataSource[indexPath.row]
        if m.status == .failed {
            cell.detailTextLabel?.text = "Failed"
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.detailTextLabel?.text = nil
    }
    
}

extension C: MStatusDidChangeDelegate {
    
    func m(_ m: M, progressDidChange progress: Float) {
        
        guard let mIndex = dataSource.index(of: m) else { print("unfind m"); return }
        let indexPath = IndexPath(row: mIndex, section: 0)
        guard let cell = tableView.cellForRow(at: indexPath) as? V else { return }
        
        cell.textLabel?.text = "Level~~\(m.growthLevel) progress~~\(m.progress)"
    }
    
    func m(_ m: M, finishWithResult result: Result<Any, Any>) {
        
        guard let mIndex = dataSource.index(of: m) else { print("unfind m"); return }
        let indexPath = IndexPath(row: mIndex, section: 0)
        
        switch result {
            case .successed(let successInfo):
                print("\(successInfo)")
                dataSource.remove(at: mIndex)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            case .failed(let failReason):
                print("\(failReason)")
                if let cell = tableView.cellForRow(at: indexPath) as? V {
                    cell.detailTextLabel?.text = "Failed"
                }
        }
        
    }
    
}

private extension C {
    
    @objc func insertDataSource() {
        let model = M()
        model.delegate = self
        dataSource.append(model)
        let indexPath = IndexPath(row: dataSource.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
}

extension Array where Element: Equatable {
    mutating func remove(_ object: Element) {
        if let index = index(of: object) {
            remove(at: index)
        }
    }
}
