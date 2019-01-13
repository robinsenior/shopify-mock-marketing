import Vapor

struct ProductsController: RouteCollection {
	func boot(router: Router) throws {
		let productsRoute = router.grouped("products")
		productsRoute.get(use: getAllHandler)
	}
	
	func getAllHandler(_ req: Request) throws -> Future<[Product]> {
		let api = try ShopifyAPI(session: req.session())
		return try api.get(resource: Products.self, request: req).map { $0.products }
	}
}
