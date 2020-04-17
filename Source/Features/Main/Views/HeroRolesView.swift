//
//  HeroRolesView.swift
//  Dota Hero
//
//  Created by Nanda Julianda Akbar on 16/04/20.
//  Copyright © 2020 Nanda. All rights reserved.
//

import UIKit

final class HeroRolesView: UIView {
	
	private let cellIdentifier = "HeroRolesCellIdentifier"
	
	@IBOutlet private weak var tableView: UITableView!
	@IBOutlet private weak var closeButton: UIButton!
	
	private let heroRoles: [HeroRole] = HeroRole.allCases
	
	var onRoleSelection: ((HeroRole?) -> ())?
	
	override func layoutSubviews() {
		
		DispatchQueue.main.async { [weak self] in
			self?.tableView.reloadData()
		}
		
		super.layoutSubviews()
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		tableView.dataSource = self
		tableView.delegate = self
		
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
	}
	
	func show(at parentView: UIView) {
		
		parentView.addSubview(self)
		
		self.tag = CustomViewTag.heroSelectionView.rawValue
		
		let initialFrame: CGRect = CGRect(
			x: 0.0,
			y: 0.0,
			width: UIScreen.main.bounds.width,
			height: 0.0
		)
		self.frame = initialFrame
		self.tableView.frame = initialFrame
		self.closeButton.frame = initialFrame
		
		UIView.animate(
			withDuration: 0.5,
			delay: 0,
			usingSpringWithDamping: 0.6,
			initialSpringVelocity: 0.05,
			options: .curveLinear,
			animations: { [weak self] in
				
				let containerWidth: CGFloat = UIScreen.main.bounds.width
				let containerHeight: CGFloat = (UIScreen.main.bounds.height/2) - 50
				let closeButtonWidth: CGFloat = 100
				let closeButtonHeight: CGFloat = 33
				let tableViewHeight: CGFloat = containerHeight - closeButtonHeight
				
				self?.frame = CGRect(
					x: 0.0,
					y: 0.0,
					width: containerWidth,
					height: containerHeight
				)
				
				self?.tableView.frame = CGRect(
					x: 0.0,
					y: 0.0,
					width: containerWidth,
					height: tableViewHeight
				)
				
				self?.closeButton.frame = CGRect(
					x: (containerWidth/2) - (closeButtonWidth/2),
					y: containerHeight - closeButtonHeight,
					width: closeButtonWidth,
					height: closeButtonHeight
				)
			}
		)
	}
	
	func close(onFinished: @escaping () -> ()) {
		
		UIView.animate(
			withDuration: 0.5,
			delay: 0,
			usingSpringWithDamping: 0.8,
			initialSpringVelocity: 0.3,
			options: .curveLinear,
			animations: { [weak self] in
				
				let finalWidth = UIScreen.main.bounds.width
				let finalFrame = CGRect(
					x: 0.0,
					y: 0.0,
					width: finalWidth,
					height: 0
				)
				
				self?.frame = finalFrame
				self?.tableView.frame = finalFrame
				self?.closeButton.frame = finalFrame
			},
			completion: { [weak self] (isFinished: Bool) in
				if (isFinished) {
					onFinished()
					self?.removeFromSuperview()
				}
			}
		)
		
	}
	
	private func reloadTableView() {
		DispatchQueue.main.async { [weak self] in
			self?.tableView.reloadData()
		}
	}
	
	@IBAction private func close(_ sender: Any) {
		onRoleSelection?(nil)
	}
}

extension HeroRolesView : UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return heroRoles.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
		cell.textLabel?.text = heroRoles[indexPath.row].rawValue
		
		return cell
	}
	
}

extension HeroRolesView : UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		onRoleSelection?(heroRoles[indexPath.row])
	}
	
}
