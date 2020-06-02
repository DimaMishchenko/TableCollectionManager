//
//  CollectionLayoutHandler.swift
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

public final class CollectionLayoutHandler {

  // MARK: - Typealias
  
  public typealias TransitionLayoutAction = (UICollectionViewLayout, UICollectionViewLayout) -> UICollectionViewTransitionLayout
  
  public typealias ItemSizeAction = (IndexPath) -> CGSize
  public typealias ViewSizeAction = (Int) -> CGSize
  public typealias InsetAction = (Int) -> UIEdgeInsets
  public typealias SpacingAction = (Int) -> CGFloat
  
  // MARK: - Properties
  
  // common
  
  internal var transitionLayout: TransitionLayoutAction?
  
  // flow layout
  
  internal var sizeForItem: ItemSizeAction?
  internal var sizeForHeader: ViewSizeAction?
  internal var sizeForFooter: ViewSizeAction?
  internal var insetForSection: InsetAction?
  internal var minimumLineSpacing: SpacingAction?
  internal var minimumInteritemSpacing: SpacingAction?
  
  // MARK: - Public

  // common
  
  @discardableResult public func transitionLayout(_ handler: @escaping TransitionLayoutAction) -> Self {
    transitionLayout = handler
    return self
  }
  
  // flow layout
  
  @discardableResult public func sizeForItem(_ handler: @escaping ItemSizeAction) -> Self {
    sizeForItem = handler
    return self
  }
  @discardableResult public func sizeForHeader(_ handler: @escaping ViewSizeAction) -> Self {
    sizeForHeader = handler
    return self
  }
  @discardableResult public func sizeForFooter(_ handler: @escaping ViewSizeAction) -> Self {
    sizeForFooter = handler
    return self
  }
  @discardableResult public func insetForSection(_ handler: @escaping InsetAction) -> Self {
    insetForSection = handler
    return self
  }
  @discardableResult public func minimumLineSpacing(_ handler: @escaping SpacingAction) -> Self {
    minimumLineSpacing = handler
    return self
  }
  @discardableResult public func minimumInteritemSpacing(_ handler: @escaping SpacingAction) -> Self {
    minimumInteritemSpacing = handler
    return self
  }
}
