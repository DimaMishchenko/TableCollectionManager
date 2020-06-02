//
//  CollectionManager+UICollectionViewDataSource.swift
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

extension CollectionManager: UICollectionViewDataSource {
  
  // MARK: - Number of items
  
  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    storage.section(at: section)?.rows.count ?? .zero
  }
  
  public func numberOfSections(in collectionView: UICollectionView) -> Int {
    storage.numberOfSections
  }
  
  // MARK: - Cell/view for item
  
  public func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    guard let row = storage.row(at: indexPath) else {
      return UICollectionViewCell()
    }
    
    registerer.register(cell: row.cellType, for: row.reuseIdentifier)
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: row.reuseIdentifier, for: indexPath)
    row.configure(cell)
    
    return cell
  }
  
  public func collectionView(
    _ collectionView: UICollectionView,
    viewForSupplementaryElementOfKind kind: String,
    at indexPath: IndexPath
  ) -> UICollectionReusableView {
    guard let item = headerFooterItem(for: kind, at: indexPath.section) else {
      return UICollectionReusableView()
    }
    
    registerer.register(headerFooter: item.headerFooterType, kind: kind, for: item.reuseIdentifier)
    
    let view = collectionView.dequeueReusableSupplementaryView(
      ofKind: kind,
      withReuseIdentifier: item.reuseIdentifier,
      for: indexPath
    )
    
    item.configure(view)
    
    return view
  }
  
  private func headerFooterItem(for kind: String, at index: Int) -> CollectionHeaderFooterItem? {
    switch kind {
    case UICollectionView.elementKindSectionHeader:
      return storage.section(at: index)?.header
    case UICollectionView.elementKindSectionFooter:
      return storage.section(at: index)?.footer
    default:
      return nil
    }
  }
  
  // MARK: - Movement
  
  public func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
    storage.row(at: indexPath)?.actionsHandler.canMove?(indexPath) ?? false
  }
  
  public func collectionView(
    _ collectionView: UICollectionView,
    moveItemAt sourceIndexPath: IndexPath,
    to destinationIndexPath: IndexPath
  ) {
    storage.row(at: sourceIndexPath)?.actionsHandler.move?(sourceIndexPath, destinationIndexPath)
  }
}
