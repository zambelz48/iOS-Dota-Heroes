//
//  Endpoint.swift
//  Dota Hero
//
//  Created by Nanda Julianda Akbar on 16/04/20.
//  Copyright © 2020 Nanda. All rights reserved.
//

import Foundation

enum MainEndpoint : EndpointType {
	
	case api
	case heroStats
	case heroImage(path: String)
	
	var description: String {
		
		switch self {
			
		case .api:
			return "\(Config.baseApiURL)/api"
			
		case .heroStats:
			return "\(MainEndpoint.api)/herostats"
			
		case .heroImage(let path):
			return Config.baseApiURL + path
			
		}
	}
	
}
