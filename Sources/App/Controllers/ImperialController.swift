import Vapor
import Imperial

struct ImperialController: RouteCollection {
	func boot(router: Router) throws {
		let hostEnvKey: String = "APP_HOST"
		let hostError = ImperialError.missingEnvVar(hostEnvKey)
		let host = try Environment.get(hostEnvKey).value(or: hostError)
		
		try router.oAuth(
			from: Shopify.self,
			authenticate: "login-shopify",
			callback: "\(host)/auth",
			scope: ["read_marketing_events", "write_marketing_events"],
			completion: processShopifyLogin
		)
	}
	
	func processShopifyLogin(request: Request, token: String) throws -> Future<ResponseEncodable> {
		return request.future(request.redirect(to: "/marketing_events"))
	}
}
