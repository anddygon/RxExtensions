//
//  Rx+AlertController.swift
//  RxExtensions
//
//  Created by xiaoP on 2017/12/5.
//

import RxSwift
import RxOptional

// MARK: - life time
extension Reactive where Base: UIViewController {
    var viewWillAppear: Observable<Bool> {
        return base.rx.methodInvoked(#selector(UIViewController.viewWillAppear(_:)))
            .map({ (params) -> Bool in
                return params[0] as! Bool
            })
    }
    
    var viewDidAppear: Observable<Bool> {
        return base.rx.methodInvoked(#selector(UIViewController.viewDidAppear(_:)))
            .map({ (params) -> Bool in
                return params[0] as! Bool
            })
    }
    
    var viewWillDisappear: Observable<Bool> {
        return base.rx.methodInvoked(#selector(UIViewController.viewWillDisappear(_:)))
            .map({ (params) -> Bool in
                return params[0] as! Bool
            })
    }
    
    var viewDidDisappear: Observable<Bool> {
        return base.rx.methodInvoked(#selector(UIViewController.viewDidDisappear(_:)))
            .map({ (params) -> Bool in
                return params[0] as! Bool
            })
    }
}

// MARK: - alert controller
extension Reactive where Base: UIViewController {
    /// 快速展示一个alertview
    ///
    /// - Parameters:
    ///   - title: 标题
    ///   - message: 消息
    ///   - yesTitle: 右侧按钮标题 使用defaultStyle
    ///   - noTitle: 左侧按钮标题 使用cancelStyle
    /// - Returns: 如果点击了yes会发送next
    public func showAlert(title: String?, message: String? = nil, yesTitle: String = "YES", noTitle: String = "NO") -> Observable<Void> {
        return Observable.create({ [weak vc = self.base] (observer) -> Disposable in
            let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let yesAction = UIAlertAction(title: yesTitle, style: .default, handler: { (_) in
                observer.onNext(())
                observer.onCompleted()
            })
            let noAction = UIAlertAction(title: noTitle, style: .cancel, handler: { (_) in
                observer.onCompleted()
            })
            [yesAction, noAction].forEach(alertVC.addAction(_:))
            vc?.present(alertVC, animated: true, completion: nil)
            return Disposables.create()
        })
    }

    /// 快速展示一个actionSheet
    ///
    /// - Parameters:
    ///   - title: 标题
    ///   - message: 消息
    ///   - optionTitles: 选项标题数组 从上至下
    ///   - cancelTitle: 取消按钮标题
    /// - Returns: 如果点击了选项会发送next为选项索引
    public func showActionSheet(title: String?, message: String? = nil, optionTitles: [String], cancelTitle: String = "Cancel") -> Observable<Int> {
        return Observable.create({ [weak vc = self.base] (observer) -> Disposable in
            let alertVC = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            let optionActions = optionTitles.enumerated().map({ (index, title) -> UIAlertAction in
                return UIAlertAction(title: title, style: .default, handler: { (_) in
                    observer.onNext(index)
                    observer.onCompleted()
                })
            })
            let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: { (_) in
                observer.onCompleted()
            })
            (optionActions + [cancelAction]).forEach(alertVC.addAction(_:))
            vc?.present(alertVC, animated: true, completion: nil)
            return Disposables.create()
        })
    }
}

// MARK: - image picker
extension Reactive where Base: UIViewController {
    /// 快速展示image picker
    ///
    /// - Parameters:
    ///   - sourceType: sourceType
    ///   - isAllowEdit: 图片是否允许编辑
    /// - Returns: 选择或拍摄的图片
    public func showImagePicker(sourceType: UIImagePickerControllerSourceType, isAllowEdit: Bool = true) -> Observable<UIImage> {
        guard UIImagePickerController.isSourceTypeAvailable(sourceType) else {
            return .error(NSError.deviceCannotSupport(sourceType: sourceType))
        }
        return Observable.create({ [weak vc = self.base] (observer) -> Disposable in
            let ipc = UIImagePickerController()
            ipc.sourceType = sourceType
            ipc.allowsEditing = isAllowEdit
            vc?.present(ipc, animated: true, completion: nil)
            
            let imageSeq = isAllowEdit ? ipc.rx.selectedEditedImage : ipc.rx.selectedOriginalImage
            let dispose = Observable<UIImage?>.merge([
                ipc.rx.cancel.map({ _ in nil }),
                imageSeq.map({ $0 })
            ])
                .do(onNext: { (_) in
                    ipc.dismiss(animated: true, completion: nil)
                })
                .filterNil()
                .bind(to: observer)
            
            return Disposables.create([dispose])
        })
    }
}

extension NSError {
    static func deviceCannotSupport(sourceType: UIImagePickerControllerSourceType) -> NSError {
        return NSError.init(domain: "Rx+UIViewController", code: 1, userInfo: [
                NSLocalizedDescriptionKey: "Your device can't support \(sourceType)"
            ])
    }
}
