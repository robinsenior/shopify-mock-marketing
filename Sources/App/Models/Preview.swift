//
//  Preview.swift
//  App
//
//  Created by Robin Senior on 2019-01-15.
//

import Foundation
import Vapor

struct PreviewRequest: Content {
	enum CodingKeys: String, CodingKey {
		case shopifyDomain = "shopify_domain"
		case shopID = "shop_id"
		case userID = "user_id"
		case locale = "locale"
		case previewTypes = "preview_types"
		case properties = "properties"
	}
	
	let shopifyDomain: String
	let shopID: String
	let userID: Int
	let locale: String
	let previewTypes: [Preview.PreviewType]
	let properties: [String: String]
}

struct Preview: Content {
	enum PreviewType: String, Content {
		case desktop
		case mobile
	}
	
	enum CodingKeys: String, CodingKey {
		case previewURL = "preview_url"
		case contentType = "content_type"
		case width = "width"
		case height = "height"
	}
	
	let previewURL: String
	let contentType: String
	let width: Int
	let height: Int
}

struct PreviewResponse: Content {
	let previews: [Preview.PreviewType: Preview]
}
