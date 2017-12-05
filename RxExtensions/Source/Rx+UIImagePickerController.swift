//
//  Rx+UIImagePickerViewController.swift
//  RxExtensions
//
//  Created by xiaoP on 2017/12/5.
//

import RxSwift
import RxCocoa

extension Reactive where Base: UIImagePickerController {
    private var _delegate: DelegateProxy<UIImagePickerController, UIImagePickerControllerDelegate & UINavigationControllerDelegate> {
        return RxImagePickerControllerDelegateProxy.proxy(for: base)
    }
    
    private var _selected: Observable<[String: Any]> {
        let selector = #selector(UIImagePickerControllerDelegate.imagePickerController(_:didFinishPickingMediaWithInfo:))
        return _delegate.methodInvoked(selector)
            .map({ (params) -> [String: Any] in
                return params[1] as! [String: Any]
            })
    }
    
    var cancel: Observable<Void> {
        return _delegate.methodInvoked(#selector(UIImagePickerControllerDelegate.imagePickerControllerDidCancel(_:)))
            .map({ _ in })
    }
    
    var selectedEditedImage: Observable<UIImage> {
        return _selected
            .map({ $0[UIImagePickerControllerEditedImage] as! UIImage })
    }
    
    var selectedOriginalImage: Observable<UIImage> {
        return _selected
            .map({ $0[UIImagePickerControllerOriginalImage] as! UIImage })
    }
}
