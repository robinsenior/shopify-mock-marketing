//
//  MarketingActivitiesExtensionController.swift
//  App
//
//  Created by Robin Senior on 2019-01-14.
//

import Vapor
import Leaf
import Authentication

struct MarketingActivitiesExtensionController: RouteCollection {
	func boot(router: Router) throws {
		let marketingActivitiesRoute = router.grouped("api", "marketing_activities")
		marketingActivitiesRoute.post(FormDataPreloadRequest.self, at: "preload_form_data", use: preloadFormDataHandler)
		marketingActivitiesRoute.post(FormDataReloadRequest.self, at: "reload_form_data", use: reloadFormDataHandler)
		marketingActivitiesRoute.post(PreviewRequest.self, at: "preview", use: previewHandler)
		
		// todo:
		// POST / - create activity
		// PATCH / - update
		// PATCH /pause - pause activity
		// PATCH /resume - resume activity
		// POST /republish - republish activity
		// POST /load_field/:field_name
	}
	
	func preloadFormDataHandler(_ req: Request, data: FormDataPreloadRequest) throws -> Future<FormDataResponse> {
		let formData = FormData()
		
		return formData.response(on: req)
	}
	
	func reloadFormDataHandler(_ req: Request, data: FormDataReloadRequest) throws -> Future<FormDataResponse> {
		let formData = FormData()
		
		return formData.response(on: req)
	}
	
	func previewHandler(_ req: Request, data: PreviewRequest) throws -> Future<PreviewResponse> {
		let response = PreviewResponse(previews: [:])
		
		return req.future(response)
	}
}

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
	let shopID: Int
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
