//
//  ViewController.swift
//  RxExtensions
//
//  Created by snmgxp@126.com on 12/05/2017.
//  Copyright (c) 2017 snmgxp@126.com. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxExtensions

class ViewController: UIViewController {
    @IBOutlet weak var showAlert: UIButton!
    @IBOutlet weak var showActionSheet: UIButton!
    @IBOutlet weak var showImagePicker: UIButton!
    
    private let bag = DisposeBag()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let showAlertBySelf = rx.showAlert(title: "Hello World")
        showAlert.rx.tap.asObservable()
            .flatMap { (_) -> Observable<Void> in
                return showAlertBySelf
            }
            .bind { (_) in
                print("点击了yes")
            }
            .disposed(by: bag)
        
        let titles = ["选项一", "选项二", "选项三"]
        let showActionSheetBySelf = rx.showActionSheet(title: "Hello World", optionTitles: titles)
        showActionSheet.rx.tap.asObservable()
            .flatMap({ _ in
                return showActionSheetBySelf
            })
            .bind { (i) in
                print("点击了\(titles[i])")
            }
            .disposed(by: bag)
        
        let showImagePickerFromSelf = rx.showImagePicker(sourceType: .camera, isAllowEdit: true)
        showImagePicker.rx.tap.asObservable()
            .flatMap { (_) in
                return showImagePickerFromSelf
            }
            .bind { [weak self] (imag) in
                self?.view.backgroundColor = UIColor.init(patternImage: imag)
            }
            .disposed(by: bag)
        
        
    }

}

import ObjectMapper
struct Product: Mappable {
    private(set) var id = ""
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        id <- map["product_id"]
    }
}
