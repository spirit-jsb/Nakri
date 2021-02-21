//
//  NSTextAlignment+Nakri.swift
//  Nakri
//
//  Created by max on 2021/2/21.
//

#if canImport(UIKit) && canImport(SwiftUI)

import UIKit
import SwiftUI

extension NSTextAlignment {
  
  var alignment: Alignment {
    switch self {
    case .left:
      return .leading
    case .right:
      return .trailing
    case .center:
      return .center
    default:
      return .leading
    }
  }
  
  var textAlignment: TextAlignment {
    switch self {
    case .left:
      return .leading
    case .right:
      return .trailing
    case .center:
      return .center
    default:
      return .leading
    }
  }
  
  init(_ alignment: TextAlignment) {
    switch alignment {
    case .leading:
      self = .left
    case .center:
      self = .center
    case .trailing:
      self = .right
    }
  }
}

#endif
