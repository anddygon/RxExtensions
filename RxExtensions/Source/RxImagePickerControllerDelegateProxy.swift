//
//  RxImagePickerViewControllerDelegateProxy.swift
//  RxExtensions
//
//  Created by xiaoP on 2017/12/5.
//

import RxSwift
import RxCocoa

class RxImagePickerControllerDelegateProxy: DelegateProxy<UIImagePickerController, UIImagePickerControllerDelegate & UINavigationControllerDelegate>, DelegateProxyType, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    weak private(set) var imagePicker: UIImagePickerController?
    
    init(imagePicker: UIImagePickerController) {
        self.imagePicker = imagePicker
        super.init(parentObject: imagePicker, delegateProxy: RxImagePickerControllerDelegateProxy.self)
    }
    
    static func registerKnownImplementations() {
        self.register(make: { RxImagePickerControllerDelegateProxy(imagePicker: $0) })
    }
    
    static func currentDelegate(for object: UIImagePickerController) -> (UIImagePickerControllerDelegate & UINavigationControllerDelegate)? {
        return object.delegate
    }
    
    static func setCurrentDelegate(_ delegate: (UIImagePickerControllerDelegate & UINavigationControllerDelegate)?, to object: UIImagePickerController) {
        object.delegate = delegate
    }
}
