//
//  Section.swift
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

public protocol Section: class, HashableItem {
  
  associatedtype RowItem
  associatedtype HeaderItem
  associatedtype FooterItem
  
  var rows: [RowItem] { get set }
  
  var header: HeaderItem? { get set }
  var footer: FooterItem? { get set }
  
  var numberOfRows: Int { get }
  var isEmpty: Bool { get }
  
  func row(at index: Int) -> RowItem?
  func index(for row: RowItem) -> Int?
  func contains(_ row: RowItem) -> Bool
  
  func clear() -> Self
  
  @discardableResult func append(_ row: RowItem) -> Self
  @discardableResult func append(_ rows: [RowItem]) -> Self
  
  @discardableResult func insert(_ row: RowItem, at index: Int) -> Self
  @discardableResult func insert(_ rows: [RowItem], at index: Int) -> Self
  
  @discardableResult func replace(at index: Int, with row: RowItem) -> Self
  @discardableResult func swap(from: Int, to: Int) -> Self
  
  @discardableResult func delete(at index: Int) -> Self
  
  @discardableResult func add(header: HeaderItem) -> Self
  @discardableResult func deleteHeader() -> Self
  
  @discardableResult func add(footer: FooterItem) -> Self
  @discardableResult func deleteFooter() -> Self
}

// MARK: - Public
 
public extension Section {
  
  var numberOfRows: Int {
    rows.count
  }
  
  var isEmpty: Bool {
    rows.isEmpty
  }
  
  func row(at index: Int) -> RowItem? {
    guard rows.indices.contains(index) else {
      return nil
    }
    
    return rows[index]
  }
  
  @discardableResult func clear() -> Self {
    rows.removeAll()
    return self
  }
  
  @discardableResult func append(_ row: RowItem) -> Self {
    rows.append(row)
    return self
  }
  
  @discardableResult func append(_ rows: [RowItem]) -> Self {
    self.rows.append(contentsOf: rows)
    return self
  }
  
  @discardableResult func insert(_ row: RowItem, at index: Int) -> Self {
    rows.insert(row, at: index)
    return self
  }
  
  @discardableResult func insert(_ rows: [RowItem], at index: Int) -> Self {
    self.rows.insert(contentsOf: rows, at: index)
    return self
  }

  @discardableResult func replace(at index: Int, with row: RowItem) -> Self {
    rows[index] = row
    return self
  }

  @discardableResult func swap(from: Int, to: Int) -> Self {
    rows.swapAt(from, to)
    return self
  }
  
  @discardableResult func delete(at index: Int) -> Self {
    rows.remove(at: index)
    return self
  }
  
  @discardableResult func add(header: HeaderItem) -> Self {
    self.header = header
    return self
  }
  
  @discardableResult func deleteHeader() -> Self {
    header = nil
    return self
  }
  
  @discardableResult func add(footer: FooterItem) -> Self {
    self.footer = footer
    return self
  }

  @discardableResult func deleteFooter() -> Self {
    footer = nil
    return self
  }
}
