//
//  TableRowActionsHandler.swift
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

import Foundation

public final class TableRowActionsHandler: TableRowActions {
  
  // MARK: - TableDataSourceActionsHandler
  
  public var canEdit: TableRowActions.BoolAction?
  public var canMove: TableRowActions.BoolAction?
  public var commitStyle: TableRowActions.CommitAction?
  public var move: TableRowActions.MoveAction?
  
  // MARK: - TableDelegateActionsHandler
  
  public var didSelect: TableRowActions.VoidAction?
  public var didDeselect: TableRowActions.VoidAction?
  public var willSelect: TableRowActions.VoidAction?
  public var willDeselect: TableRowActions.VoidAction?
  public var willDisplay: TableRowActions.VoidAction?
  public var didEndDisplaying: TableRowActions.VoidAction?
  public var shouldHighlight: TableRowActions.ShouldHighlightAction?
  public var moveTo: TableRowActions.MoveToAction?
  public var editingStyle: TableRowActions.EditingStyleAction?
  public var leadingSwipeActions: TableRowActions.SwipeConfigurationAction?
  public var trailingSwipeActions: TableRowActions.SwipeConfigurationAction?
}
