//
//  CocoaTextField.swift
//  Nakri
//
//  Created by max on 2021/2/13.
//

#if canImport(UIKit) && canImport(SwiftUI)

import UIKit
import SwiftUI

struct CocoaTextField: View {
  
  struct CharactersChange {
    let range: NSRange
    let replacement: String
  }
  
  struct Configuration {
    var onEditingChanged: (Bool) -> Void
    var onCommit: () -> Void
    var onChangeCharacters: (CharactersChange) -> Bool = { _ in true }
    
    var isInitialFirstResponder: Bool?
    var isFirstResponder: Bool?
    
    var foregroundColor: UIColor?
    var font: UIFont?
    
    var autocapitalizationType: UITextAutocapitalizationType = .sentences
    var autocorrectionType: UITextAutocorrectionType = .default
    var keyboardType: UIKeyboardType = .default
    var returnKeyType: UIReturnKeyType = .default
    var isSecureTextEntry: Bool = false
    var textContentType: UITextContentType? = nil
  }
  
  private var text: Binding<String>
  private var configuration: Configuration
  
  var body: some View {
    return _CocoaTextField(text: self.text, configuration: self.configuration)
  }
}

struct _CocoaTextField: UIViewRepresentable {
    
  class Coordinator: NSObject, UITextFieldDelegate {
    
    var text: Binding<String>
    var configuration: CocoaTextField.Configuration
    
    init(text: Binding<String>, configuration: CocoaTextField.Configuration) {
      self.text = text
      self.configuration = configuration
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
      self.configuration.onEditingChanged(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
      self.configuration.onEditingChanged(false)
      self.configuration.onCommit()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
      return self.configuration.onChangeCharacters(CocoaTextField.CharactersChange(range: range, replacement: string))
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
      guard textField.markedTextRange == nil else { return }
      
      self.text.wrappedValue = textField.text ?? ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      textField.resignFirstResponder()
      return true
    }
  }
  
  var text: Binding<String>
  var configuration: CocoaTextField.Configuration
  
  func makeUIView(context: Context) -> UITextField {
    let uiView = UITextField()
    
    uiView.delegate = context.coordinator

    if let isInitialFirstResponder = self.configuration.isInitialFirstResponder, isInitialFirstResponder, context.environment.isEnabled {
      DispatchQueue.main.async {
        uiView.becomeFirstResponder()
      }
    }
    
    return uiView
  }
  
  func updateUIView(_ uiView: UITextField, context: Context) {
    context.coordinator.text = self.text
    context.coordinator.configuration = self.configuration
    
    uiView.setContentHuggingPriority(.defaultHigh, for: .vertical)
    
    uiView.isUserInteractionEnabled = context.environment.isEnabled
    
    uiView.textAlignment = NSTextAlignment(context.environment.multilineTextAlignment)
    
    uiView.autocapitalizationType = self.configuration.autocapitalizationType
    uiView.autocorrectionType = self.configuration.autocorrectionType
    uiView.keyboardType = self.configuration.keyboardType
    uiView.returnKeyType = self.configuration.returnKeyType
    uiView.isSecureTextEntry = self.configuration.isSecureTextEntry
    uiView.textContentType = self.configuration.textContentType
    
    uiView.text = self.text.wrappedValue
    uiView.textColor = self.configuration.foregroundColor
    uiView.font = self.configuration.font
    
    DispatchQueue.main.async {
      if let isFirstResponder = self.configuration.isFirstResponder, uiView.window != nil {
        if isFirstResponder && !uiView.isFirstResponder && context.environment.isEnabled {
          uiView.becomeFirstResponder()
        }
        else if !isFirstResponder && uiView.isFirstResponder {
          uiView.resignFirstResponder()
        }
      }
    }
  }
  
  func makeCoordinator() -> Coordinator {
    return Coordinator(text: self.text, configuration: self.configuration)
  }
}

extension CocoaTextField {
  
  init(_ text: Binding<String>, onEditingChanged: @escaping (Bool) -> Void = { _ in }, onCommit: @escaping () -> Void = {  }) {
    self.text = text
    self.configuration = Configuration(onEditingChanged: onEditingChanged, onCommit: onCommit)
  }
}

extension CocoaTextField {
  
  func isInitialFirstResponder(_ isInitialFirstResponder: Bool) -> Self {
    return self.then { $0.configuration.isInitialFirstResponder = isInitialFirstResponder }
  }
  
  func isFirstResponder(_ isFirstResponder: Bool) -> Self {
    return self.then { $0.configuration.isFirstResponder = isFirstResponder }
  }
}

extension CocoaTextField {
  
  func foregroundUIColor(_ foregroundUIColor: UIColor) -> Self {
    return self.then { $0.configuration.foregroundColor = foregroundUIColor }
  }
  
  func uiFont(_ uiFont: UIFont) -> Self {
    return self.then { $0.configuration.font = uiFont }
  }
}

extension CocoaTextField {
  
  func autocapitalizationType(_ autocapitalizationType: UITextAutocapitalizationType) -> Self {
    return self.then { $0.configuration.autocapitalizationType = autocapitalizationType }
  }
  
  func autocorrectionType(_ autocorrectionType: UITextAutocorrectionType) -> Self {
    return self.then { $0.configuration.autocorrectionType = autocorrectionType }
  }
  
  func keyboardType(_ keyboardType: UIKeyboardType) -> Self {
    return self.then { $0.configuration.keyboardType = keyboardType }
  }
  
  func returnKeyType(_ returnKeyType: UIReturnKeyType) -> Self {
    return self.then { $0.configuration.returnKeyType = returnKeyType }
  }
  
  func isSecureTextEntry(_ isSecureTextEntry: Bool) -> Self {
    return self.then { $0.configuration.isSecureTextEntry = isSecureTextEntry }
  }
  
  func textContentType(_ textContentType: UITextContentType) -> Self {
    return self.then { $0.configuration.textContentType = textContentType }
  }
}

#endif
