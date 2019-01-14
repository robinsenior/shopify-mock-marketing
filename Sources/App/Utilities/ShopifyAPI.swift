//
//  ShopifyAPI.swift
//
//  Created by David Muzi on 2019-01-01.
//

import Foundation
import Vapor

protocol ShopifyResource {
	static var path: String { get }
}

protocol ShopifyCreatableResource: ShopifyResource {
	static var identifier: String { get }
}

extension Array: ShopifyResource where Element: ShopifyResource {
	static var path: String { return Element.path }
}

class ShopifyAPI {
	private let session: Session
	private let host: URL
	
	init(session: Session) throws {
		self.session = session
		let domain = try session.shopDomain()
		self.host = URL(string: "https://\(domain)/admin/")!
	}
	
	func get<R: ShopifyResource & Decodable>(resource: R.Type, request: Request) throws -> Future<R> {
		let url = host.appendingPathComponent(resource.path)
		let headers = HTTPHeaders([("X-Shopify-Access-Token", try request.accessToken())])
		
		return try request
			.client()
			.get(url, headers: headers)
			.map(to: R.self) { response in
				guard response.http.status == .ok else { throw Abort(.internalServerError) }
				return try response.content.syncDecode(R.self)
		}
	}
	
	func post<R: ShopifyCreatableResource & Content>(resource: R, request: Request) throws -> Future<R> {
		let url = host.appendingPathComponent(R.path)
		let headers = HTTPHeaders([("X-Shopify-Access-Token", try request.accessToken())])
		
		return try request
			.client()
			.post(url, headers: headers) { post in
				let dict = [R.identifier: resource]
				
				try post.content.encode(dict)
			}
			.map(to: R.self) { response in
				guard response.http.status == .created else { throw Abort(.internalServerError) }
				
				typealias Container = [String: R]
				let contained = try response.content.syncDecode(Container.self)
				
				return contained[R.identifier]!
			}
	}
}
