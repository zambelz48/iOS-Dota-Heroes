//
//  UIView+Extensions.swift
//  Dota Hero
//
//  Created by Nanda Julianda Akbar on 16/04/20.
//  Copyright © 2020 Nanda. All rights reserved.
//

import UIKit

extension UIView {
	
	class func fromNib<T: UIView>() -> T? {
		
		let bundle = Bundle(for: T.self)
		let nibName = String(describing: T.self)
		
		guard let loadedNib = bundle.loadNibNamed(nibName, owner: nil, options: nil)?.first as? T else {
			return  nil
		}
		
		return loadedNib
	}
	
}
