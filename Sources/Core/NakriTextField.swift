//
//  NakriTextField.swift
//  Nakri
//
//  Created by max on 2021/2/21.
//

#if canImport(SwiftUI)

import SwiftUI

class NakriTextFieldNotifier: ObservableObject {
  
  @Published var leftView: AnyView?
  @Published var rightView: AnyView?
  
  @Published var textAlignment: NSTextAlignment = .left
  @Published var isSecureTextEntry: Bool = false
  
  @Published var textColor: UIColor = .black
  @Published var font: UIFont = .systemFont(ofSize: 15.0)
  
  @Published var placeholderTextColor: UIColor = .gray
  @Published var focusedPlaceholderTextColor: UIColor = .gray
  @Published var placeholderFont: UIFont = .systemFont(ofSize: 12.0)
  
  @Published var lineHeight: CGFloat = 1.0
  @Published var focusedLineHeight: CGFloat = 1.0
  @Published var lineColor: UIColor = .black
  @Published var focusedLineColor: UIColor = .black
  
  @Published var insertSpacing: CGFloat = 8.0
}

public protocol NakriTextFieldStyle {
  
  func body(content: NakriTextField) -> NakriTextField
}

public struct NakriTextField: View {
  
  public typealias EditingChangeHandler = (Bool) -> Void
  public typealias CommitHandler = () -> Void
  
  @Binding private var text: String
  
  @State fileprivate var isFocused = false
  
  @ObservedObject private var notifier = NakriTextFieldNotifier()
  
  var placeholderLabel: some View {
    Text(self.placeholderText)
      .frame(minWidth: 0.0, maxWidth: .infinity, minHeight: 0.0, maxHeight: .infinity, alignment: self.notifier.textAlignment.alignment)
      .foregroundColor(Color(self.isFocused ? self.notifier.focusedPlaceholderTextColor : self.notifier.placeholderTextColor))
      .font(Font(self.notifier.placeholderFont))
      .padding(.bottom, self.text.isEmpty ? 0.0 : self.notifier.insertSpacing)
      .opacity(self.isFocused || !self.text.isEmpty ? 1.0 : 0.0)
  }
  
  var cocoaTextField: some View {
    ZStack(alignment: self.notifier.textAlignment.alignment) {
      if self.text.isEmpty && !self.isFocused {
        Text(self.placeholderText)
          .multilineTextAlignment(self.notifier.textAlignment.textAlignment)
          .foregroundColor(Color(self.isFocused ? self.notifier.focusedPlaceholderTextColor : self.notifier.placeholderTextColor))
          .font(Font(self.notifier.placeholderFont))
      }
      
      CocoaTextField(self.$text.animation(), onEditingChanged: { (changed) in
        self.isFocused = changed
        
        self.editingChanged(changed)
      }, onCommit: {
        self.commit()
      })
      .isSecureTextEntry(self.notifier.isSecureTextEntry)
      .foregroundUIColor(self.notifier.textColor)
      .uiFont(self.notifier.font)
      .multilineTextAlignment(self.notifier.textAlignment.textAlignment)
    }
  }
  
  var lineView: some View {
    Rectangle()
      .fill(Color(self.isFocused ? self.notifier.focusedLineColor : self.notifier.lineColor))
      .frame(height: self.isFocused ? self.notifier.focusedLineHeight : self.notifier.lineHeight, alignment: .leading)
  }
  
  private let placeholderText: String
  private let editingChanged: EditingChangeHandler
  private let commit: CommitHandler
  
  public init(_ text: Binding<String>, placeholderText: String = "", editingChanged: @escaping EditingChangeHandler = { _ in }, commit: @escaping CommitHandler = {  }) {
    self._text = text
    
    self.placeholderText = placeholderText
    self.editingChanged = editingChanged
    self.commit = commit
  }
  
  public var body: some View {
    VStack(spacing: 8.0) {
      self.placeholderLabel
      
      HStack {
        self.notifier.leftView
        self.cocoaTextField
        self.notifier.rightView
      }
      
      self.lineView
    }
    .frame(minWidth: 0.0, maxWidth: .infinity, minHeight: 0.0, maxHeight: .infinity, alignment: .bottomLeading)
  }
}

extension NakriTextField {
  
  public func nakriStyle<S>(_ style: S) -> some View where S: NakriTextFieldStyle {
    return style.body(content: self)
  }
}

extension NakriTextField {
  
  public func leftView<L: View>(@ViewBuilder _ view: @escaping () -> L) -> Self {
    return self.then { $0.notifier.leftView = AnyView(view()) }
  }
  
  public func rightView<R: View>(@ViewBuilder _ view: @escaping () -> R) -> Self {
    return self.then { $0.notifier.rightView = AnyView(view()) }
  }
}

extension NakriTextField {
  
  public func textAlignment(_ textAlignment: NSTextAlignment) -> Self {
    return self.then { $0.notifier.textAlignment = textAlignment }
  }
  
  public func isSecureTextEntry(_ isSecureTextEntry: Bool) -> Self {
    return self.then { $0.notifier.isSecureTextEntry = isSecureTextEntry }
  }
}

extension NakriTextField {
  
  public func textUIColor(_ textColor: UIColor) -> Self {
    return self.then { $0.notifier.textColor = textColor }
  }
  
  public func uiFont(_ font: UIFont) -> Self {
    return self.then { $0.notifier.font = font }
  }
}

extension NakriTextField {
  
  public func placeholderTextUIColor(_ placeholderTextColor: UIColor) -> Self {
    return self.then { $0.notifier.placeholderTextColor = placeholderTextColor }
  }
  
  public func focusedPlaceholderTextUIColor(_ focusedPlaceholderTextColor: UIColor) -> Self {
    return self.then { $0.notifier.focusedPlaceholderTextColor = focusedPlaceholderTextColor }
  }
  
  public func placeholderUIFont(_ placeholderFont: UIFont) -> Self {
    return self.then { $0.notifier.placeholderFont = placeholderFont }
  }
}

extension NakriTextField {
  
  public func lineHeight(_ lineHeight: CGFloat) -> Self {
    return self.then { $0.notifier.lineHeight = lineHeight }
  }
  
  public func focusedLineHeight(_ focusedLineHeight: CGFloat) -> Self {
    return self.then { $0.notifier.focusedLineHeight = focusedLineHeight }
  }
  
  public func lineUIColor(_ lineColor: UIColor) -> Self {
    return self.then { $0.notifier.lineColor = lineColor }
  }
  
  public func focusedLineUIColor(_ focusedLineColor: UIColor) -> Self {
    return self.then { $0.notifier.focusedLineColor = focusedLineColor }
  }
}

extension NakriTextField {
  
  func insertSpacing(_ insertSpacing: CGFloat) -> Self {
    return self.then { $0.notifier.insertSpacing = insertSpacing }
  }
}

struct NakriTextField_Previews: PreviewProvider {
  
  @State private static var text: String = "test"
  
  static var previews: some View {
    NakriTextField(self.$text, placeholderText: "test placeholder", editingChanged: { (_) in
      
    }, commit: {
      
    })
    .uiFont(.systemFont(ofSize: 15.0))
    .textUIColor(.red)
    .frame(width: 320.0, height: 55.0)
  }
}

#endif
