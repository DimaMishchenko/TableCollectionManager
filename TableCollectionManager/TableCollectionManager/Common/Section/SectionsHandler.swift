//
//  SectionsHandler.swift
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

public protocol SectionsHandler: class, HashableItem {
  
  associatedtype SectionItem: Section
  
  var sections: [SectionItem] { get set }
  
  var isEmpty: Bool { get }
  
  func index(for section: SectionItem) -> Int?
  func indexPath(for row: SectionItem.RowItem) -> IndexPath?
  
  func section(at index: Int) -> SectionItem?
  func row(at indexPath: IndexPath) -> SectionItem.RowItem?
  
  func contains(_ section: SectionItem) -> Bool
  
  @discardableResult func append(_ section: SectionItem) -> Self
  @discardableResult func append(_ sections: [SectionItem]) -> Self
  
  @discardableResult func insert(_ section: SectionItem, at index: Int) -> Self
  
  @discardableResult func replaceSection(at index: Int, with section: SectionItem) -> Self
  @discardableResult func swap(from: Int, to: Int) -> Self
  
  @discardableResult func delete(at index: Int) -> Self
  
  @discardableResult func clear() -> Self
  
  func emptySection() -> SectionItem
}

// MARK: - Public

public extension SectionsHandler {
  
  var isEmpty: Bool {
    sections.isEmpty
  }
  
  func index(for section: SectionItem) -> Int? {
    sections.firstIndex { $0.hashValue == section.hashValue }
  }
  
  func contains(_ section: SectionItem) -> Bool {
    sections.contains(where: { section.hashValue == $0.hashValue })
  }
  
  func section(at index: Int) -> SectionItem? {
    guard sections.indices.contains(index) else {
      return nil
    }
    
    return sections[index]
  }
  
  func indexPath(for row: SectionItem.RowItem) -> IndexPath? {
    for (sectionIndex, section) in sections.enumerated() {
      guard let rowIndex = section.index(for: row) else {
        continue
      }
      
      return IndexPath(item: rowIndex, section: sectionIndex)
    }
    
    return nil
  }
  
  func row(at indexPath: IndexPath) -> SectionItem.RowItem? {
    section(at: indexPath.section)?.row(at: indexPath.row)
  }
  
  @discardableResult func append(_ section: SectionItem) -> Self {
    sections.append(section)
    return self
  }
  
  @discardableResult func append(_ sections: [SectionItem]) -> Self {
    self.sections.append(contentsOf: sections)
    return self
  }
  
  @discardableResult func insert(_ section: SectionItem, at index: Int) -> Self {
    sections.insert(section, at: index)
    return self
  }
  
  @discardableResult func replaceSection(at index: Int, with section: SectionItem) -> Self {
    if index < sections.count {
      sections[index] = section
    }
    return self
  }
  
  @discardableResult func swap(from: Int, to: Int) -> Self {
    sections.swapAt(from, to)
    return self
  }
  
  @discardableResult func delete(at index: Int) -> Self {
    sections.remove(at: index)
    return self
  }
  
  @discardableResult func clear() -> Self {
    sections.removeAll()
    return self
  }
}
