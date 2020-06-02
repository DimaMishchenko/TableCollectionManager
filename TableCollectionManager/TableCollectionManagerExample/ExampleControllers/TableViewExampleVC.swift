//
//  TableViewExampleVC.swift
//  TableCollectionManagerExample
//
//  Created by Dima Mishchenko on 28.02.2020.
//  Copyright © 2020 Dmytro Mishchenko. All rights reserved.
//

import UIKit
import TableCollectionManager

class TableViewExampleVC: UIViewController {
  
  let manager = TableManager()
  var tableView = UITableView(frame: .zero, style: .plain)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
 
  // MARK: - Actions
  
  @objc private func addSection() {
    addSectionAlert { [weak self] headerTitle, footerTitle, numberOfItems in
      
      guard numberOfItems > 0 else { return }
      
      let section = TableSection(rows: (1...numberOfItems).map {
        TableRow<TitleCell>("Row #\($0)")
      })
      
      if let title = headerTitle, !title.isEmpty {
        section.header = TableHeaderFooter<TitleHeaderFooter>(title)
      }
      
      if let title = footerTitle, !title.isEmpty {
        section.footer = TableHeaderFooter<TitleHeaderFooter>(title)
      }
      
      self?.manager.storage.append(section)
    }
  }
  
  @objc private func deleteSection() {
    indexAlert("Delete section") { [weak self] sectionIndex in
      guard let section = self?.manager.storage.section(at: sectionIndex) else { return }
      self?.manager.storage.delete(section)
    }
  }
  
  @objc private func addRow() {
    indexAlert("Add row to section") { [weak self] sectionIndex in
      guard let section = self?.manager.storage.section(at: sectionIndex) else { return }
      
      let row = TableRow<TitleCell>("Row #\(section.numberOfRows + 1)")
      self?.manager.storage.append(row, to: sectionIndex)
    }
  }
  
  @objc private func deleteRow() {
    indexAlert("Delete last row at section") { [weak self] sectionIndex in
      guard let section = self?.manager.storage.section(at: sectionIndex) else { return }
      guard let row = section.rows.last else { return }
      self?.manager.storage.delete(row)
    }
  }
  
  // MARK: - Private
  
  private func setupUI() {
    
    navigationItem.rightBarButtonItems = [
      UIBarButtonItem(title: "➕Section", style: .plain, target: self, action: #selector(addSection)),
      UIBarButtonItem(title: "❌Section", style: .plain, target: self, action: #selector(deleteSection)),
      UIBarButtonItem(title: "➕Row", style: .plain, target: self, action: #selector(addRow)),
      UIBarButtonItem(title: "❌Row", style: .plain, target: self, action: #selector(deleteRow))
    ]
    
    setupTableView()
  }
  
  private func setupTableView() {
    view.addSubview(tableView)
    
    tableView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: view.topAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])
    
    manager.tableView = tableView
  }
  
  private func addSectionAlert(_ completion: @escaping (String?, String?, Int) -> Void) {
    let alert = UIAlertController(title: "Add Section", message: "", preferredStyle: .alert)
    
    alert.addTextField { $0.placeholder = "Header text" }
    alert.addTextField { $0.placeholder = "Footer text" }
    alert.addTextField { $0.placeholder = "Number of rows" }
    
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] _ in
      completion(
        alert?.textFields?[0].text,
        alert?.textFields?[1].text,
        Int(alert?.textFields?[2].text ?? "0") ?? 0
      )
    }))
    
    present(alert, animated: true, completion: nil)
  }
  
  private func indexAlert(_ title: String, _ completion: @escaping (Int) -> Void) {
    let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
    
    alert.addTextField { $0.placeholder = "At index" }
    
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] _ in
      completion(Int(alert?.textFields?[0].text ?? "0") ?? 0)
    }))
    
    present(alert, animated: true, completion: nil)
  }
}
