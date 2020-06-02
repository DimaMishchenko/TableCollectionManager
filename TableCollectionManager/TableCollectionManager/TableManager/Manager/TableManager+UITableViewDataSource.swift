//
//  TableManager+UITableViewDataSource.swift
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

extension TableManager: UITableViewDataSource {
  
  // MARK: - Number of items
  
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    storage.section(at: section)?.rows.count ?? .zero
  }
  
  public func numberOfSections(in tableView: UITableView) -> Int {
    storage.numberOfSections
  }
  
  // MARK: - Cell for row
  
  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let row = storage.row(at: indexPath) else {
      return UITableViewCell()
    }
    
    registerer.register(cell: row.cellType, for: row.reuseIdentifier)
    
    let cell = tableView.dequeueReusableCell(withIdentifier: row.reuseIdentifier, for: indexPath)
    row.configure(cell)
    
    return cell
  }
  
  // MARK: - Editing
  
  public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    storage.row(at: indexPath)?.actionsHandler.canEdit?(indexPath) ?? false
  }
  
  public func tableView(
    _ tableView: UITableView,
    commit editingStyle: UITableViewCell.EditingStyle,
    forRowAt indexPath: IndexPath
  ) {
    storage.row(at: indexPath)?.actionsHandler.commitStyle?(editingStyle, indexPath)
  }
  
  // MARK: - Movement
  
  public func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
    storage.row(at: indexPath)?.actionsHandler.canMove?(indexPath) ?? false
  }
  
  public func tableView(
    _ tableView: UITableView,
    moveRowAt sourceIndexPath: IndexPath,
    to destinationIndexPath: IndexPath
  ) {
    storage.row(at: sourceIndexPath)?.actionsHandler.move?(sourceIndexPath, destinationIndexPath)
  }
}
