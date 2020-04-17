//
//  Hero.swift
//  Dota Hero
//
//  Created by Nanda Julianda Akbar on 16/04/20.
//  Copyright © 2020 Nanda. All rights reserved.
//

import Foundation

struct Hero : Codable, Hashable {
	
	let id: Int
    let name: String
	let localizedName: String
	let primaryAttr: String
	let attackType: String
    let roles: [String]
	let img: String
	let icon: String
    let baseHealth: Int
    let baseHealthRegen: Double?
	let baseMana: Int
	let baseArmor: Double
	let baseMr: Int
	let baseManaRegen: Double
	let baseAttackMin: Int
	let baseAttackMax: Int
	let baseStr: Int
	let baseAgi: Int
    let baseInt: Int
    let strGain: Double
    let agiGain: Double
    let intGain: Double
	let attackRange: Int
	let projectileSpeed: Int
    let attackRate: Double
    let moveSpeed: Int
    let turnRate: Double
    let cmEnabled: Bool
    let legs: Int
	let proBan: Int
	let heroID: Int
	let proWin: Int
    let proPick: Int
	let the1Pick: Int
	let the1Win: Int
	let the2Pick: Int
    let the2Win: Int
	let the3Pick: Int
	let the3Win: Int
	let the4Pick: Int
	let the4Win: Int
	let the5Pick: Int
	let the5Win: Int
	let the6Pick: Int
    let the6Win: Int
	let the7Pick: Int
	let the7Win: Int
	let the8Pick: Int
    let the8Win: Int
	let nullPick: Int
	let nullWin: Int
	
	enum CodingKeys: String, CodingKey {
        case id, name
        case localizedName = "localized_name"
        case primaryAttr = "primary_attr"
        case attackType = "attack_type"
        case roles, img, icon
        case baseHealth = "base_health"
        case baseHealthRegen = "base_health_regen"
        case baseMana = "base_mana"
        case baseManaRegen = "base_mana_regen"
        case baseArmor = "base_armor"
        case baseMr = "base_mr"
        case baseAttackMin = "base_attack_min"
        case baseAttackMax = "base_attack_max"
        case baseStr = "base_str"
        case baseAgi = "base_agi"
        case baseInt = "base_int"
        case strGain = "str_gain"
        case agiGain = "agi_gain"
        case intGain = "int_gain"
        case attackRange = "attack_range"
        case projectileSpeed = "projectile_speed"
        case attackRate = "attack_rate"
        case moveSpeed = "move_speed"
        case turnRate = "turn_rate"
        case cmEnabled = "cm_enabled"
        case legs
        case proBan = "pro_ban"
        case heroID = "hero_id"
        case proWin = "pro_win"
        case proPick = "pro_pick"
        case the1Pick = "1_pick"
        case the1Win = "1_win"
        case the2Pick = "2_pick"
        case the2Win = "2_win"
        case the3Pick = "3_pick"
        case the3Win = "3_win"
        case the4Pick = "4_pick"
        case the4Win = "4_win"
        case the5Pick = "5_pick"
        case the5Win = "5_win"
        case the6Pick = "6_pick"
        case the6Win = "6_win"
        case the7Pick = "7_pick"
        case the7Win = "7_win"
        case the8Pick = "8_pick"
        case the8Win = "8_win"
        case nullPick = "null_pick"
        case nullWin = "null_win"
    }
	
	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}
}
