//
//  UITableView+Extensions.swift
//  Dota Hero
//
//  Created by Nanda Julianda Akbar on 16/04/20.
//  Copyright © 2020 Nanda. All rights reserved.
//

import UIKit

extension UITableView  {
	
	func registerCell(identifier: String) {
		
		let cellNib = UINib(nibName: identifier, bundle: nil)
		
		self.register(cellNib, forCellReuseIdentifier: identifier)
	}
	
}
