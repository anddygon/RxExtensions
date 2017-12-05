//
//  Rx+JSONMapping.swift
//  RxExtensions
//
//  Created by xiaoP on 2017/12/5.
//

import Foundation
import RxSwift
import ObjectMapper

public extension PrimitiveSequence where TraitType == SingleTrait, ElementType == [String: Any] {
    func mapObject<T: BaseMappable>(_ type: T.Type, keyPath: String? = nil) -> Single<T> {
        return flatMap({ (json) -> Single<T> in
            let waitingMappingObject: Any? = (keyPath == nil) ? json : json[keyPath!]
            if let t = Mapper<T>().map(JSONObject: waitingMappingObject) {
                return Single.just(t)
            } else {
                return Single.error(NSError.jsonMapping(json, keyPath: keyPath, type: type))
            }
        })
    }
    
    func mapArray<T: BaseMappable>(_ type: T.Type, keyPath: String? = nil) -> Single<[T]> {
        return flatMap({ (json) -> Single<[T]> in
            let waitingMappingObject: Any? = (keyPath == nil) ? json : json[keyPath!]
            if let arr = Mapper<T>().mapArray(JSONObject: waitingMappingObject) {
                return Single.just(arr)
            } else {
                return Single.error(NSError.jsonMapping(json, keyPath: keyPath, type: type))
            }
        })
    }
}

extension NSError {
    static func jsonMapping<T>(_ json: Any?, keyPath: String?, type: T.Type) -> NSError {
        let keyPathText = keyPath != nil ? " with keyPath \(keyPath!). " : ""
        let debugInfo = "Could map json to \(type)" + keyPathText + String(describing: json)
        return NSError(domain: "Rx+JSONMapping", code: 1, userInfo: [
                NSLocalizedDescriptionKey: "Invalid Data",
                "DebugInfo": debugInfo
            ])
    }
}
