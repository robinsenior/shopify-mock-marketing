//
//  Create.swift
//  App
//
//  Created by Robin Senior on 2019-03-21.
//

import Foundation
import Vapor

struct FormDataCreateRequest: Content {
	enum CodingKeys: String, CodingKey {
		case shopifyDomain = "shopify_domain"
		case shopID = "shop_id"
		case userID = "user_id"
		case locale = "locale"
		case marketingActivityID = "marketing_activity_id"
		case marketingActivityTitle = "marketing_activity_title"
		case properties = "properties"
	}
	
	let shopifyDomain: String
	let shopID: String
	let userID: Int
	let locale: String
	let marketingActivityID: String?
	let marketingActivityTitle: String?
	let properties: [String: String]
}

struct CreateResponse: Content {
	init() {
	}
}
