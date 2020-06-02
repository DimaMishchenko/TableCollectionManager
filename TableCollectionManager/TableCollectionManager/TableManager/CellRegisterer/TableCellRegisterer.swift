//
//  TableCellRegisterer.swift
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

internal final class TableCellRegisterer {
  
  // MARK: - Constants
  
  private static let nib = "nib"
  
  // MARK: - Properties
  
  private var registeredCellIds = Set<String>()
  private var registeredHeaderFooterIds = Set<String>()
  private weak var tableView: UITableView?
  
  // MARK: - Init
  
  internal init(tableView: UITableView?) {
    self.tableView = tableView
  }
  
  // MARK: - Public
  
  internal func register(cell type: AnyClass, for reuseIdentifier: String) {
    guard !registeredCellIds.contains(reuseIdentifier) else {
      return
    }
    
    guard tableView?.dequeueReusableCell(withIdentifier: reuseIdentifier) == nil else {
      registeredCellIds.insert(reuseIdentifier)
      return
    }
    
    let bundle = Bundle(for: type)
    
    if bundle.path(forResource: reuseIdentifier, ofType: Self.nib) != nil {
      tableView?.register(UINib(nibName: reuseIdentifier, bundle: bundle), forCellReuseIdentifier: reuseIdentifier)
    } else {
      tableView?.register(type, forCellReuseIdentifier: reuseIdentifier)
    }
    
    registeredCellIds.insert(reuseIdentifier)
  }
  
  internal func register(headerFooter type: AnyClass, for reuseIdentifier: String) {
    guard !registeredHeaderFooterIds.contains(reuseIdentifier) else {
      return
    }
    
    guard tableView?.dequeueReusableHeaderFooterView(withIdentifier: reuseIdentifier) == nil else {
      registeredHeaderFooterIds.insert(reuseIdentifier)
      return
    }
    
    let bundle = Bundle(for: type)
    
    if bundle.path(forResource: reuseIdentifier, ofType: Self.nib) != nil {
      tableView?.register(
        UINib(nibName: reuseIdentifier, bundle: bundle),
        forHeaderFooterViewReuseIdentifier: reuseIdentifier
      )
    } else {
      tableView?.register(type, forHeaderFooterViewReuseIdentifier: reuseIdentifier)
    }
    
    registeredHeaderFooterIds.insert(reuseIdentifier)
  }
}
