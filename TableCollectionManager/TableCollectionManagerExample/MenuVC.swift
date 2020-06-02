//
//  ViewController.swift
//  TableCollectionManagerExample
//
//  Created by Dima Mishchenko on 25.02.2020.
//  Copyright © 2020 Dmytro Mishchenko. All rights reserved.
//

import UIKit
import TableCollectionManager

class MenuVC: UIViewController {
  
  let manager = TableManager()
  var tableView = UITableView(frame: .zero, style: .plain)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "TableCollectionManager"
    
    setupTableView()
  
    manager.storage.append([
      TableRow<TitleCell>("TableView").didSelect { [weak self] _ in
        self?.navigationController?.pushViewController(TableViewExampleVC(), animated: true)
      },
      TableRow<TitleCell>("TableView Reordering").didSelect { [weak self] _ in
        self?.navigationController?.pushViewController(TableViewReorderingVC(), animated: true)
      },
      TableRow<TitleCell>("CollectionView").didSelect { [weak self] _ in
        self?.navigationController?.pushViewController(CollectionViewExampleVC(), animated: true)
      }
    ])
    
    manager.storage.setHeader(TableHeaderFooter<TitleHeaderFooter>("Examples"), to: .zero)
  }
  
  // MARK: - Private
  
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
