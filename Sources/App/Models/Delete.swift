//
//  Delete.swift
//  App
//
//  Created by Robin Senior on 2019-06-04.
//

import Foundation
import Vapor

struct FormDataDeleteRequest: Content {
	enum CodingKeys: String, CodingKey {
		case shopifyDomain = "shopify_domain"
		case shopID = "shop_id"
		case userID = "user_id"
		case locale = "locale"
		case marketingActivityID = "marketing_activity_id"
	}
	
	let shopifyDomain: String
	let shopID: String
	let userID: Int
	let locale: String
	let marketingActivityID: String
}

struct DeleteResponse: Content {
	init() {
	}
}
