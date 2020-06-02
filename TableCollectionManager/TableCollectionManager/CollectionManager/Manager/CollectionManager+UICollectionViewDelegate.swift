//
//  CollectionManager+UICollectionViewDelegate.swift
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

extension CollectionManager: UICollectionViewDelegate {
  
  // MARK: - Display
  
  public func collectionView(
    _ collectionView: UICollectionView,
    willDisplay cell: UICollectionViewCell,
    forItemAt indexPath: IndexPath
  ) {
    storage.row(at: indexPath)?.actionsHandler.willDisplay?(cell, indexPath)
  }
  
  public func collectionView(
    _ collectionView: UICollectionView,
    didEndDisplaying cell: UICollectionViewCell,
    forItemAt indexPath: IndexPath
  ) {
    storage.row(at: indexPath)?.actionsHandler.didEndDisplaying?(cell, indexPath)
  }
  
  // MARK: - Highlight
  
  public func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
    storage.row(at: indexPath)?.actionsHandler.shouldHighlight?(
      collectionView.cellForItem(at: indexPath),
      indexPath
    ) ?? true
  }
  
  // MARK: - Selection
  
  public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let action = storage.row(at: indexPath)?.actionsHandler.didSelect else {
      return
    }
    
    action(collectionView.cellForItem(at: indexPath), indexPath)
    collectionView.deselectItem(at: indexPath, animated: true)
  }
  
  public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    storage.row(at: indexPath)?.actionsHandler.didDeselect?(collectionView.cellForItem(at: indexPath), indexPath)
  }
  
  // MARK: - Movement
  
  public func collectionView(
    _ collectionView: UICollectionView,
    targetIndexPathForMoveFromItemAt originalIndexPath: IndexPath,
    toProposedIndexPath proposedIndexPath: IndexPath
  ) -> IndexPath {
    storage.row(at: originalIndexPath)?.actionsHandler.moveTo?(
      originalIndexPath,
      proposedIndexPath
    ) ?? proposedIndexPath
  }
  
  // MARK: - Layout
  
  public func collectionView(
    _ collectionView: UICollectionView,
    transitionLayoutForOldLayout fromLayout: UICollectionViewLayout,
    newLayout toLayout: UICollectionViewLayout
  ) -> UICollectionViewTransitionLayout {
    layoutHandler.transitionLayout?(fromLayout, toLayout) ?? UICollectionViewTransitionLayout(
      currentLayout: fromLayout,
      nextLayout: toLayout
    )
  }
}
