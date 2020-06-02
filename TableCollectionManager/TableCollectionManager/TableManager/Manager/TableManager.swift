//
//  TableManager.swift
//
//  Copyright (c) 2020 Dmytro Mishchenko (https://github.com/DimaMishchenko)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import UIKit

public final class TableManager: NSObject {
  
  // MARK: - Properties
  
  public var storage: TableStorage {
    didSet {
      subscribeOnStorage()
    }
  }
  
  public weak var tableView: UITableView? {
    didSet {
      registerer = TableCellRegisterer(tableView: tableView)
      subscribeOnTableView()
    }
  }
  
  public var scrollHandler = ScrollDelegateActionsHandler()
  private(set) var registerer: TableCellRegisterer
  
  // MARK: - Init
  
  public init(tableView: UITableView? = nil, storage: TableStorage? = nil) {
    self.tableView = tableView
    self.storage = storage ?? TableStorage()
    registerer = TableCellRegisterer(tableView: tableView)
    super.init()
    
    subscribeOnStorage()
    subscribeOnTableView()
  }
  
  // MARK: - Private
  
  private func subscribeOnStorage() {
    storage.delegate = self
  }
  
  private func subscribeOnTableView() {
    tableView?.dataSource = self
    tableView?.delegate = self
  }
  
  private func performUpdate(_ update: StorageUpdate, style: UITableView.RowAnimation) {
    switch update {
    case .reloadData:
      tableView?.reloadData()
    case .reloadSections(let indices):
      tableView?.reloadSections(IndexSet(indices), with: style)
    case .reloadRows(let indexPaths):
      tableView?.reloadRows(at: indexPaths, with: style)
    case .insertSections(let indices):
      tableView?.insertSections(IndexSet(indices), with: style)
    case .insertRows(let indexPaths):
      tableView?.insertRows(at: indexPaths, with: style)
    case .deleteSections(let indices):
      tableView?.deleteSections(IndexSet(indices), with: style)
    case .deleteRows(let indexPaths):
      tableView?.deleteRows(at: indexPaths, with: style)
    case .moveSection(let source, let destination):
      tableView?.moveSection(source, toSection: destination)
    case .moveRow(let source, let destination):
      tableView?.moveRow(at: source, to: destination)
    }
  }
}

// MARK: - StorageDelegate

extension TableManager: StorageDelegate {
  
  internal func performUpdates(_ updates: [StorageUpdate], animated: Bool, completion: @escaping (Bool) -> Void) {
    tableView?.performBatchUpdates({
      updates.forEach {
        performUpdate($0, animated: animated)
      }
    }, completion: {
      completion($0)
    })
  }
  
  internal func performUpdate(_ update: StorageUpdate, animated: Bool) {
    let style: UITableView.RowAnimation = animated ? .automatic : .none
    if animated {
      performUpdate(update, style: style)
    } else {
      UIView.performWithoutAnimation {
        performUpdate(update, style: style)
      }
    }
  }
}
