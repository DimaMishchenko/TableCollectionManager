//
//  TableViewReorderingVC.swift
//  TableCollectionManagerExample
//
//  Created by Dima Mishchenko on 04.03.2020.
//  Copyright © 2020 Dmytro Mishchenko. All rights reserved.
//

import UIKit
import TableCollectionManager

class TableViewReorderingVC: UIViewController {
  
  let manager = TableManager()
  var tableView = UITableView(frame: .zero, style: .plain)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Reordering"
    
    setupTableView()
    
    let items = [
      ["Section #1 Row #1", "Section #1 Row #2"],
      ["Section #2 Row #1"],
      ["Section #3 Row #1", "Section #3 Row #2", "Section #3 Row #3", "Section #3 Row #4"]
    ]
    
    manager.storage.append(
      items.map {
        TableSection(rows: $0.map {
          row(for: $0)
        })
      }
    )
    
    navigationItem.rightBarButtonItem = editButtonItem
  }
  
  override func setEditing(_ editing: Bool, animated: Bool) {
    super.setEditing(editing, animated: animated)
    tableView.setEditing(editing, animated: animated)
  }
  
  // MARK: - Private
  
  private func row(for title: String) -> TableRow<TitleCell> {
    TableRow<TitleCell>(title).canEdit { _ in true }.canMove { _ in true }.editingStyle { _ in .delete }.move { [weak self] in
      self?.manager.storage.moveRowWithoutUpdate(from: $0, to: $1)
    }.commitStyle { [weak self] in
      guard $0 == .delete, let rowToDelete = self?.manager.storage.row(at: $1) else { return }
      self?.manager.storage.delete(rowToDelete)
    }
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
}
