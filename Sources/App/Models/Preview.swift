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
	
	init(previewURL: String, contentType: String, width: Int, height: Int) {
		self.previewURL = previewURL
		self.contentType = contentType
		self.width = width
		self.height = height
	}
}

struct PreviewResponse: Content {
	let mobile: Preview?
	let desktop: Preview?
	
	init(desktop: Preview?, mobile: Preview?) {
		self.desktop = desktop
		self.mobile = mobile
	}
}
