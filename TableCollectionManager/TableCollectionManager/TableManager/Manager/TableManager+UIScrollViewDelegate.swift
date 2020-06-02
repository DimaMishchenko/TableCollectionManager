//
//  TableManager+UIScrollViewDelegate.swift
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

extension TableManager: UIScrollViewDelegate {
  
  public func scrollViewDidScroll(_ scrollView: UIScrollView) {
    scrollHandler.didScroll?()
  }
  
  public func scrollViewDidZoom(_ scrollView: UIScrollView) {
    scrollHandler.didZoom?()
  }
  
  public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    scrollHandler.willBeginDragging?()
  }
  
  public func scrollViewWillEndDragging(
    _ scrollView: UIScrollView,
    withVelocity velocity: CGPoint,
    targetContentOffset: UnsafeMutablePointer<CGPoint>
  ) {
    scrollHandler.willEndDragging?(velocity, targetContentOffset)
  }
  
  public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    scrollHandler.didEndDragging?(decelerate)
  }
  
  public func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
    scrollHandler.willBeginDecelerating?()
  }
  
  public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    scrollHandler.didEndDecelerating?()
  }
  
  public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
    scrollHandler.didEndScrollingAnimation?()
  }
  
  public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    scrollHandler.viewForZooming?() ?? nil
  }
  
  public func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
    scrollHandler.willBeginZooming?(view)
  }
  
  public func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
    scrollHandler.didEndZooming?(view, scale)
  }
  
  public func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
    scrollHandler.shouldScrollToTop?() ?? true
  }
  
  public func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
    scrollHandler.didScrollToTop?()
  }
  
  public func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) {
    scrollHandler.didChangeAdjustedContentInset?()
  }
}
