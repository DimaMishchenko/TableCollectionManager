//
//  ScrollDelegateActionsHandler.swift
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

public final class ScrollDelegateActionsHandler {
  
  // MARK: - Typealias
  
  public typealias VoidAction = () -> Void
  public typealias BoolAction = () -> Bool
  public typealias WillEndDraggingAction = (CGPoint, UnsafeMutablePointer<CGPoint>) -> Void
  public typealias DidEndDraggingAction = (Bool) -> Void
  public typealias ViewForZoomingAction = () -> UIView?
  public typealias WillBeginZooming = (UIView?) -> Void
  public typealias DidEndZooming = (UIView?, CGFloat) -> Void
  
  // MARK: - Properties
  
  internal var didScroll: VoidAction?
  internal var didZoom: VoidAction?
  internal var willBeginDragging: VoidAction?
  internal var willEndDragging: WillEndDraggingAction?
  internal var didEndDragging: DidEndDraggingAction?
  internal var willBeginDecelerating: VoidAction?
  internal var didEndDecelerating: VoidAction?
  internal var didEndScrollingAnimation: VoidAction?
  internal var viewForZooming: ViewForZoomingAction?
  internal var willBeginZooming: WillBeginZooming?
  internal var didEndZooming: DidEndZooming?
  internal var shouldScrollToTop: BoolAction?
  internal var didScrollToTop: VoidAction?
  internal var didChangeAdjustedContentInset: VoidAction?
  
  // MARK: - Public
  
  @discardableResult public func didScroll(_ handler: @escaping VoidAction) -> Self {
    didScroll = handler
    return self
  }
  
  @discardableResult public func didZoom(_ handler: @escaping VoidAction) -> Self {
    didZoom = handler
    return self
  }
  
  @discardableResult public func willBeginDragging(_ handler: @escaping VoidAction) -> Self {
    willBeginDragging = handler
    return self
  }
  
  @discardableResult public func willEndDragging(_ handler: @escaping WillEndDraggingAction) -> Self {
    willEndDragging = handler
    return self
  }
  
  @discardableResult public func didEndDragging(_ handler: @escaping DidEndDraggingAction) -> Self {
    didEndDragging = handler
    return self
  }
  
  @discardableResult public func willBeginDecelerating(_ handler: @escaping VoidAction) -> Self {
    willBeginDecelerating = handler
    return self
  }
  
  @discardableResult public func didEndDecelerating(_ handler: @escaping VoidAction) -> Self {
    didEndDecelerating = handler
    return self
  }
  
  @discardableResult public func didEndScrollingAnimation(_ handler: @escaping VoidAction) -> Self {
    didEndScrollingAnimation = handler
    return self
  }
  
  @discardableResult public func viewForZooming(_ handler: @escaping ViewForZoomingAction) -> Self {
    viewForZooming = handler
    return self
  }
  
  @discardableResult public func willBeginZooming(_ handler: @escaping WillBeginZooming) -> Self {
    willBeginZooming = handler
    return self
  }
  
  @discardableResult public func didEndZooming(_ handler: @escaping DidEndZooming) -> Self {
    didEndZooming = handler
    return self
  }
  
  @discardableResult public func shouldScrollToTop(_ handler: @escaping BoolAction) -> Self {
    shouldScrollToTop = handler
    return self
  }
  
  @discardableResult public func didScrollToTop(_ handler: @escaping VoidAction) -> Self {
    didScrollToTop = handler
    return self
  }
  
  @discardableResult public func didChangeAdjustedContentInset(_ handler: @escaping VoidAction) -> Self {
    didChangeAdjustedContentInset = handler
    return self
  }
}
