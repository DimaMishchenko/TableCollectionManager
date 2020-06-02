//
//  CollectionManager+UICollectionViewDelegateFlowLayout.swift
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

extension CollectionManager: UICollectionViewDelegateFlowLayout {
  
  // MARK: - Size
  
  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    layoutHandler.sizeForItem?(indexPath) ??
    storage.row(at: indexPath)?.size ??
    (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize ??
    .zero
  }
  
  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    referenceSizeForHeaderInSection section: Int
  ) -> CGSize {
    layoutHandler.sizeForHeader?(section) ??
    storage.section(at: section)?.header?.size ??
    (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.headerReferenceSize ??
    .zero
  }

  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    referenceSizeForFooterInSection section: Int
  ) -> CGSize {
    layoutHandler.sizeForHeader?(section) ??
    storage.section(at: section)?.footer?.size ??
    (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.footerReferenceSize ??
    .zero
  }

  // MARK: - Spacing
  
  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    insetForSectionAt section: Int
  ) -> UIEdgeInsets {
    layoutHandler.insetForSection?(section) ??
    (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.sectionInset ??
    .zero
  }

  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumLineSpacingForSectionAt section: Int
  ) -> CGFloat {
    layoutHandler.minimumLineSpacing?(section) ??
    (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.minimumLineSpacing ??
    .zero
  }

  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumInteritemSpacingForSectionAt section: Int
  ) -> CGFloat {
    layoutHandler.minimumInteritemSpacing?(section) ??
    (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.minimumInteritemSpacing ??
    .zero
  }
}
