//
//  UIImageView+Extension.swift
//  Dota Hero
//
//  Created by Nanda Julianda Akbar on 16/04/20.
//  Copyright © 2020 Nanda. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
	
	func load(from url: EndpointType) {
		
		let loadingViewTag: Int = 100
		
		DispatchQueue.global(qos: .background).async { [weak self] in
			
			guard let self = self else {
				return
			}
			
			let imageHandler = ImageCacheHandler.shared
			
			if let cachedImage = imageHandler.getCachedImage(for: url.description) {
				
				DispatchQueue.main.async { [weak self] in
					self?.contentMode = .scaleToFill
					self?.image = cachedImage
				}
				
				return
			}
			
			DispatchQueue.main.async { [weak self] in
				
				guard let self = self else {
					return
				}
				
				let loadingView = UIActivityIndicatorView(style: .whiteLarge)
				loadingView.tag = loadingViewTag
				loadingView.startAnimating()
				
				self.addSubview(loadingView)
				
				loadingView.translatesAutoresizingMaskIntoConstraints = false
				
				NSLayoutConstraint.activate([
					loadingView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
					loadingView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
				])
			}
			
			let httpHandler = HttpHandler()
			let spec = HttpRequestSpec(url: url)
			
			httpHandler.request(
				spec: spec,
				onSuccess: { [weak self] (data: Data?) in
					
					guard let data = data,
						let image = UIImage(data: data) else {
							return
					}
					
					imageHandler.storeToCache(with: spec.url.description, image: image)
					
					DispatchQueue.main.async {
						
						self?.subviews.filter({ $0.tag == loadingViewTag })
							.first?.removeFromSuperview()
						
						if let cachedImage = imageHandler.getCachedImage(for: url.description) {
							self?.contentMode = .scaleToFill
							self?.image = cachedImage
						}
					}
				},
				onFailed: { [weak self] (error: Error) in
					
					DispatchQueue.main.async {
						
						self?.subviews.filter({ $0.tag == loadingViewTag })
							.first?.removeFromSuperview()
					}
				}
			)
		}
	}
	
}
