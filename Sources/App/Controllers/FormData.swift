//
//  FormData.swift
//  App
//
//  Created by Robin Senior on 2019-01-15.
//

import Vapor

struct FormDataPreloadRequest: Content {
	enum CodingKeys: String, CodingKey {
		case shopifyDomain = "shopify_domain"
		case shopID = "shop_id"
		case userID = "user_id"
		case locale = "locale"
		case marketingActivityID = "marketing_activity_id"
	}
	
	let shopifyDomain: String
	let shopID: Int
	let userID: Int
	let locale: String
	let marketingActivityID: Int?
}

struct FormDataReloadRequest: Content {
	enum CodingKeys: String, CodingKey {
		case shopifyDomain = "shopify_domain"
		case shopID = "shop_id"
		case userID = "user_id"
		case locale = "locale"
		case properties = "properties"
	}
	
	let shopifyDomain: String
	let shopID: Int
	let userID: Int
	let locale: String
	let properties: [String: String]
}

struct FormDataResponse: Content {
	enum CodingKeys: String, CodingKey {
		case formData = "form_data"
	}
	
	let formData: FormData
}

struct FormData: Content {
}

extension FormData {
	func response(on req: Request) -> Future<FormDataResponse> {
		return req.future(FormDataResponse(formData: self))
	}
}

struct FormField: Content {
	
}
