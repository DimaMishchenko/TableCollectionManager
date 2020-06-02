//
//  TableRow.swift
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

public final class TableRow<Cell: UITableViewCell & TableConfigurable>: TableRowItem {

  // MARK: - Properties
  
  public var model: Cell.Model
  private let rowActionsHandler = TableRowActionsHandler()
  
  // MARK: - Init
  
  public init(_ model: Cell.Model) {
    self.model = model
  }
  
  // MARK: - TableRowItem
  
  public var reuseIdentifier: String {
    Cell.identifier
  }
  
  public var height: CGFloat {
    Cell.height
  }
  
  public var estimatedHeight: CGFloat {
    Cell.estimatedHeight
  }
  
  public var cellType: AnyClass {
    Cell.self
  }
  
  public var actionsHandler: TableRowActions {
    rowActionsHandler
  }
  
  public func configure(_ cell: UITableViewCell) {
    (cell as? Cell)?.update(with: model)
  }
}

// MARK: - TableDataSourceActions

public extension TableRow {
  
  @discardableResult func canEdit(_ handler: @escaping TableRowActions.BoolAction) -> Self {
    rowActionsHandler.canEdit = handler
    return self
  }
  
  @discardableResult func canMove(_ handler: @escaping TableRowActions.BoolAction) -> Self {
    rowActionsHandler.canMove = handler
    return self
  }
  
  @discardableResult func commitStyle(_ handler: @escaping TableRowActions.CommitAction) -> Self {
    rowActionsHandler.commitStyle = handler
    return self
  }
  
  @discardableResult func move(_ handler: @escaping TableRowActions.MoveAction) -> Self {
    rowActionsHandler.move = handler
    return self
  }
}

// MARK: - TableDelegateActions

public extension TableRow {
  
  typealias VoidAction = (TableRowActionResult<Cell>?) -> Void
  typealias ResultAction<T> = (TableRowActionResult<Cell>?) -> T
  
  @discardableResult func didSelect(_ handler: @escaping VoidAction) -> Self {
    rowActionsHandler.didSelect = { [weak self] in handler(self?.actionResult(for: $0, at: $1)) }
    return self
  }
  
  @discardableResult func didDeselect(_ handler: @escaping VoidAction) -> Self {
    rowActionsHandler.didDeselect = { [weak self] in handler(self?.actionResult(for: $0, at: $1)) }
    return self
  }
  
  @discardableResult func willSelect(_ handler: @escaping VoidAction) -> Self {
    rowActionsHandler.willSelect = { [weak self] in handler(self?.actionResult(for: $0, at: $1)) }
    return self
  }
  
  @discardableResult func willDeselect(_ handler: @escaping VoidAction) -> Self {
    rowActionsHandler.willDeselect = { [weak self] in handler(self?.actionResult(for: $0, at: $1)) }
    return self
  }
  
  @discardableResult func willDisplay(_ handler: @escaping VoidAction) -> Self {
    rowActionsHandler.willDisplay = { [weak self] in handler(self?.actionResult(for: $0, at: $1)) }
    return self
  }
  
  @discardableResult func didEndDisplaying(_ handler: @escaping VoidAction) -> Self {
    rowActionsHandler.didEndDisplaying = { [weak self] in handler(self?.actionResult(for: $0, at: $1)) }
    return self
  }
  
  @discardableResult func moveTo(_ handler: @escaping TableRowActions.MoveToAction) -> Self {
    rowActionsHandler.moveTo = handler
    return self
  }
  
  @discardableResult func shouldHighlight(_ handler: @escaping ResultAction<Bool>) -> Self {
    rowActionsHandler.shouldHighlight = { [weak self] in handler(self?.actionResult(for: $0, at: $1)) }
    return self
  }
  
  @discardableResult func editingStyle(_ handler: @escaping ResultAction<UITableViewCell.EditingStyle>) -> Self {
    rowActionsHandler.editingStyle = { [weak self] in return handler(self?.actionResult(for: $0, at: $1)) }
    return self
  }
  
  @discardableResult func leadingSwipeActions(_ handler: @escaping ResultAction<UISwipeActionsConfiguration?>) -> Self {
    rowActionsHandler.leadingSwipeActions = { [weak self] in return handler(self?.actionResult(for: $0, at: $1)) }
    return self
  }
  
  @discardableResult func trailingSwipeActions(_ handler: @escaping ResultAction<UISwipeActionsConfiguration?>) -> Self {
    rowActionsHandler.trailingSwipeActions = { [weak self] in return handler(self?.actionResult(for: $0, at: $1)) }
    return self
  }
}

// MARK: - Private

extension TableRow {
  
  private func actionResult(for cell: UITableViewCell?, at indexPath: IndexPath) -> TableRowActionResult<Cell> {
    TableRowActionResult<Cell>(model: model, cell: cell as? Cell, indexPath: indexPath)
  }
}
