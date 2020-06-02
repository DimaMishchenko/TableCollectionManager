//
//  TableActions.swift
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

public protocol TableRowActions: TableDataSourceActions, TableDelegateActions {}

// MARK: - TableDataSourceActionsHandler

public protocol TableDataSourceActions {
  
  typealias BoolAction = (IndexPath) -> Bool
  typealias CommitAction = (UITableViewCell.EditingStyle, IndexPath) -> Void
  typealias MoveAction = (IndexPath, IndexPath) -> Void
  
  var canEdit: BoolAction? { get }
  var canMove: BoolAction? { get }
  
  var commitStyle: CommitAction? { get }
  var move: MoveAction? { get }
}

// MARK: - TableDelegateActionsHandler

public protocol TableDelegateActions {
  
  typealias VoidAction = (UITableViewCell?, IndexPath) -> Void
  typealias ShouldHighlightAction = (UITableViewCell?, IndexPath) -> Bool
  typealias MoveToAction = (IndexPath, IndexPath) -> IndexPath
  typealias EditingStyleAction = (UITableViewCell?, IndexPath) -> UITableViewCell.EditingStyle
  typealias SwipeConfigurationAction = (UITableViewCell?, IndexPath) -> UISwipeActionsConfiguration?
  
  var didSelect: VoidAction? { get }
  var didDeselect: VoidAction? { get }
  
  var willSelect: VoidAction? { get }
  var willDeselect: VoidAction? { get }
  
  var willDisplay: VoidAction? { get }
  var didEndDisplaying: VoidAction? { get }
  
  var moveTo: MoveToAction? { get }
  
  var shouldHighlight: ShouldHighlightAction? { get }
  
  var editingStyle: EditingStyleAction? { get }
  
  var leadingSwipeActions: SwipeConfigurationAction? { get }
  var trailingSwipeActions: SwipeConfigurationAction? { get }
}
