//
//  View+Nakri.swift
//  Nakri
//
//  Created by max on 2021/2/21.
//

#if canImport(SwiftUI)

import SwiftUI

extension View {
  
  func then(_ body: (inout Self) -> Void) -> Self {
    var dynamicSelf = self
    
    body(&dynamicSelf)
    
    return dynamicSelf
  }
}

#endif
