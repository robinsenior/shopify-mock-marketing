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
		marketingActivitiesRoute.post(FormDataCreateRequest.self, at: "", use: createHandler)
		marketingActivitiesRoute.patch("pause", use: pauseHandler)
		
		// todo:
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
		let preview = Preview(previewURL: "http://robinsenior.com/images/cowboy_small.jpg", contentType: "image/jpeg", width: 360, height: 360)

		let response = PreviewResponse(desktop: preview, mobile: preview)
		
		return req.future(response)
	}
	
	func createHandler(_ req: Request, data: FormDataCreateRequest) throws -> Future<CreateResponse> {
		let response = CreateResponse()
		
		return req.future(response)
	}
	
	func pauseHandler(_ req: Request) throws -> Future<HTTPResponse> {
		let response = HTTPResponse(status: .ok)
		
		return req.future(response)
	}
}
