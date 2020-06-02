//
//  CollectionSection.swift
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

public final class CollectionSection: Section {
  
  // MARK: - Properties

  public var rows: [CollectionRowItem]
  
  public var header: CollectionHeaderFooterItem?
  public var footer: CollectionHeaderFooterItem?

  // MARK: - Init

  public init(rows: [CollectionRowItem] = []) {
    self.rows = rows
  }

  public convenience init(
    header: CollectionHeaderFooterItem? = nil,
    footer: CollectionHeaderFooterItem? = nil,
    rows: [CollectionRowItem] = []
  ) {
    self.init(rows: rows)

    self.header = header
    self.footer = footer
  }
  
  // MARK: - Public
  
  public func index(for row: CollectionRowItem) -> Int? {
    guard let index = rows.firstIndex(where: { $0.hashValue == row.hashValue }) else {
      return nil
    }
    
    return index
  }
  
  public func contains(_ row: CollectionRowItem) -> Bool {
    rows.contains(where: { row.hashValue == $0.hashValue })
  }
}
