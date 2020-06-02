//
//  CollectionHeaderFooter.swift
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

public final class CollectionHeaderFooter<View: UICollectionReusableView & CollectionConfigurable>: CollectionHeaderFooterItem {
  
  // MARK: - Properties
  
  public var model: View.Model
  
  // MARK: - Init
  
  public init(_ model: View.Model) {
    self.model = model
  }
  
  // MARK: - TableHeaderFooterItem
  
  public var reuseIdentifier: String {
    View.identifier
  }
  
  public var size: CGSize? {
    View.size
  }
  
  public var headerFooterType: AnyClass {
    View.self
  }
  
  public func configure(_ view: UICollectionReusableView) {
    (view as? View)?.update(with: model)
  }
}

