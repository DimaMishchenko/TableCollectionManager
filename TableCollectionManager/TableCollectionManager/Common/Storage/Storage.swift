//
//  Storage.swift
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

internal protocol StorageDelegate: class {
  
  func performUpdates(_ updates: [StorageUpdate], animated: Bool, completion: @escaping (Bool) -> Void)
  func performUpdate(_ update: StorageUpdate, animated: Bool)
}

public protocol Storage: class {

  associatedtype SectionsHandlerItem: SectionsHandler
  var sectionsHandler: SectionsHandlerItem { get }
  
  var isEmpty: Bool { get }
  var numberOfSections: Int { get }
  var numberOfAllRows: Int { get }

  func index(for section: SectionsHandlerItem.SectionItem) -> Int?
  func indexPath(for row: SectionsHandlerItem.SectionItem.RowItem) -> IndexPath?
  
  func section(at index: Int) -> SectionsHandlerItem.SectionItem?
  func row(at indexPath: IndexPath) -> SectionsHandlerItem.SectionItem.RowItem?
  
  func performWithoutAnimation(_ block: () -> Void)
  func performBatchUpdate(_ block: () -> Void, completion: @escaping (Bool) -> Void)
  
  func reload()
  func reload(_ row: SectionsHandlerItem.SectionItem.RowItem)
  func reload(_ rows: [SectionsHandlerItem.SectionItem.RowItem])
  func reload(_ section: SectionsHandlerItem.SectionItem)
  func reload(_ sections: [SectionsHandlerItem.SectionItem])
  
  func append(_ row: SectionsHandlerItem.SectionItem.RowItem)
  func append(_ rows: [SectionsHandlerItem.SectionItem.RowItem])
  func append(_ row: SectionsHandlerItem.SectionItem.RowItem, to sectionIndex: Int)
  func append(_ rows: [SectionsHandlerItem.SectionItem.RowItem], to sectionIndex: Int)
  func append(_ section: SectionsHandlerItem.SectionItem)
  func append(_ sections: [SectionsHandlerItem.SectionItem])
  
  func insert(_ row: SectionsHandlerItem.SectionItem.RowItem, at indexPath: IndexPath)
  func insert(_ section: SectionsHandlerItem.SectionItem, at index: Int)

  func delete(_ row: SectionsHandlerItem.SectionItem.RowItem)
  func delete(_ rows: [SectionsHandlerItem.SectionItem.RowItem])
  func delete(_ section: SectionsHandlerItem.SectionItem)
  func delete(_ sections: [SectionsHandlerItem.SectionItem])
  func deleteAllItems()
  
  func moveRowWithoutUpdate(from source: IndexPath, to destination: IndexPath)
  func moveRow(from source: IndexPath, to destination: IndexPath)
  func moveSection(from source: Int, to destination: Int)
}

// MARK: - Internal

internal struct StorageAssociatedKeys {
  
  static var delegate: UInt8 = 0
  static var animated: UInt8 = 1
  static var batchUpdate: UInt8 = 2
  static var batchUpdates: UInt8 = 3
  static var checkUniqueItems: UInt8 = 4
}

internal extension Storage {
  
  weak var delegate: StorageDelegate? {
    get { objc_getAssociatedObject(self, &StorageAssociatedKeys.delegate) as? StorageDelegate }
    set { objc_setAssociatedObject(self, &StorageAssociatedKeys.delegate, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
  }
  
  private var animated: Bool {
    get { objc_getAssociatedObject(self, &StorageAssociatedKeys.animated) as? Bool ?? true }
    set { objc_setAssociatedObject(self, &StorageAssociatedKeys.animated, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
  }
  
  private var batchUpdate: Bool {
    get { objc_getAssociatedObject(self, &StorageAssociatedKeys.batchUpdate) as? Bool ?? false }
    set { objc_setAssociatedObject(self, &StorageAssociatedKeys.batchUpdate, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
  }
  
  private var batchUpdates: [StorageUpdate] {
    get { objc_getAssociatedObject(self, &StorageAssociatedKeys.batchUpdates) as? [StorageUpdate] ?? [] }
    set { objc_setAssociatedObject(self, &StorageAssociatedKeys.batchUpdates, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
  }
  
  #if DEBUG
  private var _checkUniqueItems: Bool {
    get { objc_getAssociatedObject(self, &StorageAssociatedKeys.checkUniqueItems) as? Bool ?? true }
    set { objc_setAssociatedObject(self, &StorageAssociatedKeys.checkUniqueItems, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
  }
  #endif
}

// MARK: - Public

public extension Storage {
  
  #if DEBUG
  /// You can only use unique rows/sections inside storage. Storage has unique items check to make sure you don't append/insert same item multiple times. But it can cause small performance issues since Storage should iterate through items. This only works in DEBUG mode but if you want so turn of it just call storage.checkUniqueItems = false
  var checkUniqueItems: Bool {
    get { _checkUniqueItems }
    set { _checkUniqueItems = newValue }
  }
  #endif

  var isEmpty: Bool {
    sectionsHandler.isEmpty
  }

  var numberOfSections: Int {
    sectionsHandler.sections.count
  }

  var numberOfAllRows: Int {
    sectionsHandler.sections.reduce(0) { sum, section in
      sum + section.rows.count
    }
  }

  func index(for section: SectionsHandlerItem.SectionItem) -> Int? {
    sectionsHandler.index(for: section)
  }

  func indexPath(for row: SectionsHandlerItem.SectionItem.RowItem) -> IndexPath? {
    sectionsHandler.indexPath(for: row)
  }

  func section(at index: Int) -> SectionsHandlerItem.SectionItem? {
    sectionsHandler.section(at: index)
  }

  func row(at indexPath: IndexPath) -> SectionsHandlerItem.SectionItem.RowItem? {
    sectionsHandler.row(at: indexPath)
  }

  // MARK: - Updates

  func performWithoutAnimation(_ block: () -> Void) {
    animated = false
    block()
    animated = true
  }

  func performBatchUpdate(_ block: () -> Void, completion: @escaping (Bool) -> Void = { _ in }) {
    batchUpdate = true
    block()
    batchUpdate = false
    delegate?.performUpdates(batchUpdates, animated: animated) {
      completion($0)
    }
    batchUpdates = []
  }

  // MARK: - Reloading

  func reload() {
    performUpdate(.reloadData)
  }

  func reload(_ row: SectionsHandlerItem.SectionItem.RowItem) {
    reload([row])
  }

  func reload(_ rows: [SectionsHandlerItem.SectionItem.RowItem]) {
    performUpdate(.reloadRows(at: indexPaths(for: rows)))
  }

  func reload(_ section: SectionsHandlerItem.SectionItem) {
    reload([section])
  }

  func reload(_ sections: [SectionsHandlerItem.SectionItem]) {
    performUpdate(.reloadSections(at: indices(for: sections)))
  }

  // MARK: - Append

  func append(_ row: SectionsHandlerItem.SectionItem.RowItem) {
    append([row])
  }

  func append(_ rows: [SectionsHandlerItem.SectionItem.RowItem]) {
    let section = lastSection()
    check(rows, in: section)
    section.append(rows)
    performUpdate(.insertRows(at: indexPaths(for: rows)))
  }

  func append(_ row: SectionsHandlerItem.SectionItem.RowItem, to sectionIndex: Int) {
    append([row], to: sectionIndex)
  }

  func append(_ rows: [SectionsHandlerItem.SectionItem.RowItem], to sectionIndex: Int) {
    guard let section = section(at: sectionIndex) else {
      logError("Failed to append. Invalid section index \(sectionIndex)")
      return
    }
    check(rows, in: section)
    section.append(rows)
    performUpdate(.insertRows(at: indexPaths(for: rows)))
  }

  func append(_ section: SectionsHandlerItem.SectionItem) {
    append([section])
  }

  func append(_ sections: [SectionsHandlerItem.SectionItem]) {
    check(sections)
    sectionsHandler.append(sections)
    performUpdate(.insertSections(at: indices(for: sections)))
  }

  // MARK: - Insertion

  func insert(_ row: SectionsHandlerItem.SectionItem.RowItem, at indexPath: IndexPath) {
    guard let section = self.section(at: indexPath.section) else {
      if numberOfSections == .zero && indexPath.section == .zero && indexPath.row == .zero {
        append(row)
      } else {
        logError("Failed to insert. Invalid indexPath \(indexPath) to insert row \(row)")
      }
      return
    }
    check([row], in: section)
    section.insert(row, at: indexPath.row)
    performUpdate(.insertRows(at: [indexPath]))
  }

  func insert(_ section: SectionsHandlerItem.SectionItem, at index: Int) {
    check([section])
    sectionsHandler.insert(section, at: index)
    performUpdate(.insertSections(at: [index]))
  }

  // MARK: - Deleting

  func delete(_ row: SectionsHandlerItem.SectionItem.RowItem) {
    delete([row])
  }

  func delete(_ rows: [SectionsHandlerItem.SectionItem.RowItem]) {
    let indexPaths = self.indexPaths(for: rows)
    indexPaths.forEach { section(at: $0.section)?.delete(at: $0.row) }
    performUpdate(.deleteRows(at: indexPaths))
    
    let emptySections = sectionsHandler.sections.filter { $0.isEmpty }
    delete(emptySections)
  }

  func delete(_ section: SectionsHandlerItem.SectionItem) {
    delete([section])
  }

  func delete(_ sections: [SectionsHandlerItem.SectionItem]) {
    let indices = self.indices(for: sections)
    indices.forEach { sectionsHandler.delete(at: $0) }
    performUpdate(.deleteSections(at: indices))
  }

  func deleteAllItems() {
    sectionsHandler.clear()
    performUpdate(.reloadData)
  }

  // MARK: - Reordering
  
  func moveRowWithoutUpdate(from source: IndexPath, to destination: IndexPath) {
    guard let row = row(at: source) else {
      logError("Failed to move. Invalid source row at \(source)")
      return
    }
    section(at: source.section)?.delete(at: source.row)
    section(at: destination.section)?.insert(row, at: destination.row)
  }

  func moveRow(from source: IndexPath, to destination: IndexPath) {
    guard let row = row(at: source) else {
      logError("Failed to move. Invalid source row at \(source)")
      return
    }
    section(at: source.section)?.delete(at: source.row)
    section(at: destination.section)?.insert(row, at: destination.row)
    performUpdate(.moveRow(from: source, to: destination))
  }

  func moveSection(from source: Int, to destination: Int) {
    guard let section = section(at: source) else {
      logError("Failed to move. Invalid source section at \(source)")
      return
    }
    sectionsHandler.delete(at: source)
    sectionsHandler.insert(section, at: destination)
    performUpdate(.moveSection(from: source, to: destination))
  }
}
  
// MARK: - Internal

internal extension Storage {
  
  func check(_ rows: [SectionsHandlerItem.SectionItem.RowItem], in section: SectionsHandlerItem.SectionItem) {
    #if DEBUG
    guard checkUniqueItems else { return }
    
    
    guard rows.count == (rows as [AnyObject]).unique.count else {
      fatalError("Rows \(rows) contains same objects, please create unique instance for each row")
    }
    
    rows.forEach {
      if section.contains($0) {
        fatalError("Section already contains \($0) row, please create new instance")
      }
    }
    #endif
  }
  
  func check(_ sections: [SectionsHandlerItem.SectionItem]) {
    #if DEBUG
    guard checkUniqueItems else { return }
    
    guard sections.count == sections.unique.count else {
      fatalError("Sections \(sections) contains same objects, please create unique instance for each section")
    }
    
    sections.forEach {
      if sectionsHandler.contains($0) {
        fatalError("Storage already contains \($0) section, please create new instance")
      }
    }
    #endif
  }
  
  func performUpdate(_ update: StorageUpdate) {
    guard !batchUpdate else {
      batchUpdates.append(update)
      return
    }
    
    delegate?.performUpdate(update, animated: animated)
  }
  
  func indices(for sections: [SectionsHandlerItem.SectionItem]) -> [Int] {
    sections.compactMap { index(for: $0) }
  }
  
  func indexPaths(for rows: [SectionsHandlerItem.SectionItem.RowItem]) -> [IndexPath] {
    rows.compactMap { indexPath(for: $0) }
  }
  
  func lastSection() -> SectionsHandlerItem.SectionItem {
    guard let section = sectionsHandler.sections.last else {
      let section = sectionsHandler.emptySection()
      sectionsHandler.append(section)
      return section
    }
    
    return section
  }
  
  func logError(_ text: String, line: Int = #line) {
    print("TableCollectionManager error: \(text). In \(Self.self) line \(line)")
  }
}

fileprivate extension Sequence where Iterator.Element: AnyObject {
  
  var unique: [Element] {
    var uniqueValues: [Element] = []
    forEach { item in
      if !uniqueValues.contains(where: { ObjectIdentifier($0) == ObjectIdentifier(item) }) {
        uniqueValues += [item]
      }
    }
    return uniqueValues
  }
}
