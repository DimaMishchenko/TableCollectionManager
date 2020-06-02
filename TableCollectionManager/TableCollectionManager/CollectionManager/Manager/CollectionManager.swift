//
//  CollectionManager.swift
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

public final class CollectionManager: NSObject {
  
  // MARK: - Properties
  
  public var storage: CollectionStorage {
    didSet {
      subscribeOnStorage()
    }
  }
  
  public weak var collectionView: UICollectionView? {
    didSet {
      registerer = CollectionCellRegisterer(collectionView: collectionView)
      subscribeOnCollectionView()
    }
  }
  
  public let scrollHandler = ScrollDelegateActionsHandler()
  public let layoutHandler = CollectionLayoutHandler()
  
  private(set) var registerer: CollectionCellRegisterer
  
  // MARK: - Init
  
  public init(collectionView: UICollectionView? = nil, storage: CollectionStorage? = nil) {
    self.collectionView = collectionView
    self.storage = storage ?? CollectionStorage()
    registerer = CollectionCellRegisterer(collectionView: collectionView)
    super.init()
    
    subscribeOnStorage()
    subscribeOnCollectionView()
  }
  
  // MARK: - Private
  
  private func subscribeOnStorage() {
    storage.delegate = self
  }
  
  private func subscribeOnCollectionView() {
    collectionView?.dataSource = self
    collectionView?.delegate = self
  }
  
  private func performUpdate(_ update: StorageUpdate) {
    switch update {
    case .reloadData:
      collectionView?.reloadData()
    case .reloadSections(let indices):
      collectionView?.reloadSections(IndexSet(indices))
    case .reloadRows(let indexPaths):
      collectionView?.reloadItems(at: indexPaths)
    case .insertSections(let indices):
      collectionView?.insertSections(IndexSet(indices))
    case .insertRows(let indexPaths):
      collectionView?.insertItems(at: indexPaths)
    case .deleteSections(let indices):
      collectionView?.deleteSections(IndexSet(indices))
    case .deleteRows(let indexPaths):
      collectionView?.deleteItems(at: indexPaths)
    case .moveSection(let source, let destination):
      collectionView?.moveSection(source, toSection: destination)
    case .moveRow(let source, let destination):
      collectionView?.moveItem(at: source, to: destination)
    }
  }
}

// MARK: - StorageDelegate

extension CollectionManager: StorageDelegate {
  
  internal func performUpdates(_ updates: [StorageUpdate], animated: Bool, completion: @escaping (Bool) -> Void) {
    collectionView?.performBatchUpdates({
      updates.forEach {
        performUpdate($0, animated: animated)
      }
    }, completion: {
      completion($0)
    })
  }
  
  internal func performUpdate(_ update: StorageUpdate, animated: Bool) {
    if animated {
      performUpdate(update)
    } else {
      UIView.performWithoutAnimation {
        performUpdate(update)
      }
    }
  }
}
