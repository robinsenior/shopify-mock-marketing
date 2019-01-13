import Vapor
import Imperial

struct ImperialController: RouteCollection {
	func boot(router: Router) throws {
		try router.oAuth(
			from: Shopify.self,
			authenticate: "login-shopify",
			callback: "http://5cf8144d.ngrok.io/auth",
			scope: ["read_products", "read_marketing_events"],
			completion: processShopifyLogin
		)
	}
	
	func processShopifyLogin(request: Request, token: String) throws -> Future<ResponseEncodable> {
		return request.future(request.redirect(to: "/marketing_events"))
	}
}
