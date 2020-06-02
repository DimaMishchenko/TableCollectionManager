//
//  TableManager+UITableViewDelegate.swift
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

extension TableManager: UITableViewDelegate {
  
  // MARK: - Height
  
  public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    storage.row(at: indexPath)?.height ?? .zero
  }
  
  public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    storage.row(at: indexPath)?.estimatedHeight ?? .zero
  }
  
  public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    storage.section(at: section)?.header?.height ?? .zero
  }
  
  public func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
    storage.section(at: section)?.header?.estimatedHeight ?? .zero
  }
  
  public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    storage.section(at: section)?.footer?.height ?? .zero
  }
  
  public func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
    storage.section(at: section)?.footer?.estimatedHeight ?? .zero
  }
  
  // MARK: - Header Footer View
  
  public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    guard let item = storage.section(at: section)?.header else {
      return nil
    }
    
    return headerFooterView(for: item, tableView: tableView)
  }
  
  public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    guard let item = storage.section(at: section)?.footer else {
      return nil
    }
    
    return headerFooterView(for: item, tableView: tableView)
  }
  
  private func headerFooterView(for item: TableHeaderFooterItem, tableView: UITableView) -> UIView? {
    
    registerer.register(headerFooter: item.headerFooterType, for: item.reuseIdentifier)
    
    guard let headerFooterView = tableView.dequeueReusableHeaderFooterView(withIdentifier: item.reuseIdentifier) else {
      return nil
    }
    
    item.configure(headerFooterView)
    
    return headerFooterView
  }
  
  // MARK: - Display
  
  public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    storage.row(at: indexPath)?.actionsHandler.willDisplay?(cell, indexPath)
  }
  
  public func tableView(
    _ tableView: UITableView,
    didEndDisplaying cell: UITableViewCell,
    forRowAt indexPath: IndexPath
  ) {
    storage.row(at: indexPath)?.actionsHandler.didEndDisplaying?(cell, indexPath)
  }
  
  // MARK: - Highlight
  
  public func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
    storage.row(at: indexPath)?.actionsHandler.shouldHighlight?(tableView.cellForRow(at: indexPath), indexPath) ?? true
  }
  
  // MARK: - Selection
  
  public func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    storage.row(at: indexPath)?.actionsHandler.willSelect?(tableView.cellForRow(at: indexPath), indexPath)
    return indexPath
  }
  
  public func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
    storage.row(at: indexPath)?.actionsHandler.willDeselect?(tableView.cellForRow(at: indexPath), indexPath)
    return indexPath
  }
  
  public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let action = storage.row(at: indexPath)?.actionsHandler.didSelect else {
      return
    }
    
    action(tableView.cellForRow(at: indexPath), indexPath)
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    storage.row(at: indexPath)?.actionsHandler.didDeselect?(tableView.cellForRow(at: indexPath), indexPath)
  }
  
  // MARK: - Movement
  
  public func tableView(
    _ tableView: UITableView,
    targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath,
    toProposedIndexPath proposedDestinationIndexPath: IndexPath
  ) -> IndexPath {
    storage.row(at: sourceIndexPath)?.actionsHandler.moveTo?(
      sourceIndexPath,
      proposedDestinationIndexPath
    ) ?? proposedDestinationIndexPath
  }
  
  // MARK: - Editing Style
  
  public func tableView(
    _ tableView: UITableView,
    editingStyleForRowAt indexPath: IndexPath
  ) -> UITableViewCell.EditingStyle {
    storage.row(at: indexPath)?.actionsHandler.editingStyle?(tableView.cellForRow(at: indexPath), indexPath) ?? .none
  }
  
  // MARK: - Swipe Actions
  
  public func tableView(
    _ tableView: UITableView,
    leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath
  ) -> UISwipeActionsConfiguration? {
    storage.row(at: indexPath)?.actionsHandler.leadingSwipeActions?(
      tableView.cellForRow(at: indexPath),
      indexPath
    ) ?? nil
  }
  
  public func tableView(
    _ tableView: UITableView,
    trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
  ) -> UISwipeActionsConfiguration? {
    storage.row(at: indexPath)?.actionsHandler.trailingSwipeActions?(
      tableView.cellForRow(at: indexPath),
      indexPath
    ) ?? nil
  }
  
  // MARK: - Default
  
  public func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
    false
  }
}
