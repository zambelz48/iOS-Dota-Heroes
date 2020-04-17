//
//  HttpHandler+Extension.swift
//  Dota Hero
//
//  Created by Nanda Julianda Akbar on 16/04/20.
//  Copyright © 2020 Nanda. All rights reserved.
//

import Foundation
import RxSwift

extension HttpHandler {
	
	func jsonRequest<T>(
		spec: HttpRequestSpec,
		onSuccess: @escaping (T?) -> (),
		onFailed: @escaping (CommonError) -> () = { _ in }
	) where T: Codable {
		
		var requestSpec = spec
		requestSpec.appendHeader(key: "Content-Type", value: "application/json")
		
		return request(spec: requestSpec, onSuccess: onSuccess, onFailed: onFailed)
	}
	
	func requestObservable(spec: HttpRequestSpec) -> Observable<Data?> {
		
		return Observable
			.create({ [weak self] (observer: AnyObserver<Data?>) -> Disposable in
				
				let disposable = Disposables.create()
				
				guard let self = self else {
					observer.onError(ErrorFactory.unknown)
					return disposable
				}
				
				self.request(
					spec: spec,
					onSuccess: { (result: Data?) in
						observer.onNext(result)
						observer.onCompleted()
					},
					onFailed: { (error: CommonError) in
						observer.onError(error)
						observer.onCompleted()
					}
				)
				
				return disposable
			})
	}
	
	func requestObservable<T>(spec: HttpRequestSpec) -> Observable<T> where T: Codable {
		
		return Observable
			.create({ [weak self] (observer: AnyObserver<T?>) -> Disposable in
				
				let disposable = Disposables.create()
				
				guard let self = self else {
					observer.onError(ErrorFactory.unknown)
					return disposable
				}
				
				self.request(
					spec: spec,
					onSuccess: { (result: T?) in
						observer.onNext(result)
						observer.onCompleted()
					},
					onFailed: { (error: CommonError) in
						observer.onError(error)
						observer.onCompleted()
					}
				)
				
				return disposable
			})
			.filter({ (result: T?) -> Bool in
				return result != nil
			})
			.map({ (result: T?) -> T in
				
				guard let validResult = result else {
					return (T.self as! T)
				}
				
				return validResult
			})
	}
	
	func jsonRequestObservable<T>(spec: HttpRequestSpec) -> Observable<T> where T: Codable {
		
		var requestSpec = spec
		requestSpec.appendHeader(key: "Content-Type", value: "application/json")
		
		return requestObservable(spec: requestSpec)
	}
	
}
