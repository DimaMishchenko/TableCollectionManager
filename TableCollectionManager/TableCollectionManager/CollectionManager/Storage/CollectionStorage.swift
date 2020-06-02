//
//  CollectionStorage.swift
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

public final class CollectionStorage: Storage {
  
  // MARK: - Properties
  
  public let sectionsHandler: CollectionSectionsHandler
  
  // MARK: - Init
  
  public init() {
    sectionsHandler = CollectionSectionsHandler(sections: [])
  }
  
  public init(sections: [CollectionSection] = []) {
    sectionsHandler = CollectionSectionsHandler(sections: sections)
  }
  
  public init(rows: [CollectionRowItem] = []) {
    sectionsHandler = CollectionSectionsHandler(sections: [CollectionSection(rows: rows)])
  }
  
  // MARK: - Public
  
  // to fix UICollectionView bug. Crash when inserting first section.
  public func append(_ rows: [CollectionSectionsHandler.SectionItem.RowItem]) {
    let section = lastSection()
    check(rows, in: section)
    section.append(rows)
    
    if section.numberOfRows == rows.count {
      performUpdate(.reloadData)
    } else {
      performUpdate(.insertRows(at: indexPaths(for: rows)))
    }
  }
  
  // to fix UICollectionView bug. Crash when inserting first section.
  public func append(_ sections: [CollectionSectionsHandler.SectionItem]) {
    check(sections)
    sectionsHandler.append(sections)
    
    if numberOfSections == sections.count {
      performUpdate(.reloadData)
    } else {
      performUpdate(.insertSections(at: indices(for: sections)))
    }
  }
  
  // to fix UICollectionView bug. Crash when inserting first section.
  public func insert(_ section: CollectionSectionsHandler.SectionItem, at index: Int) {
    check([section])
    sectionsHandler.insert(section, at: index)
    
    if numberOfSections == 1 {
      performUpdate(.reloadData)
    } else {
      performUpdate(.insertSections(at: [index]))
    }
  }
}
