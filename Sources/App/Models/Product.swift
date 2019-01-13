import Vapor

final class Products: Content {
	let products: [Product]
}

final class Product: Content {
	let title: String
}

extension Products: ShopifyResource {
	static var path: String { return "products.json" }
}
