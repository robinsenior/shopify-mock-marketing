import Vapor
import Imperial

class ImperialController {
	var shopifyRouter: Shopify!
	
	let authenticateSlug = "authenticate"
}

extension ImperialController {
	
	// 1. Called from iFrame will redirect to app as main frame using App Bridge
	func beginAuth(_ req: Request) throws -> Future<View> {
		
		print("1. Redirecting to self via App Bridge to escape iFrame")
		
		let com = URLComponents(url: req.http.url, resolvingAgainstBaseURL: false)!
		let shop = com.queryItems!.first{ $0.name == "shop"}!.value!
		let host = req.http.headers[.host].first!
		let url = "https://\(host)/\(authenticateSlug)?shop=\(shop)"
		let apiKey = try ShopifyAuth().clientID
		
		let html = """
		<html>
		<script src="https://unpkg.com/@shopify/app-bridge"></script>
		<script src="/scripts/redirect.js"></script>
		<script>redirect("\(apiKey)", "\(shop)", "\(url)")</script>
		</html>
		"""
		
		let promise: EventLoopPromise<View> = req.eventLoop.newPromise()
		promise.succeed(result: View(data: html.data(using: .utf8)!))
		return promise.futureResult
	}
	
	// 2. Called in main frame, initiates OAuth (which has write access to cookies) via a window redirect
	func authenticate(_ req: Request) throws -> Future<AnyResponse> {
		
		print("2. Redirecting to authentication flow")
		
		let authURL = try shopifyRouter.shopifyRouter.authURL(req)
		
		let html = """
		<html><script>location.href = "\(authURL)"</script></html>
		"""
		
		let promise: EventLoopPromise<View> = req.eventLoop.newPromise()
		promise.succeed(result: View(data: html.data(using: .utf8)!))
		return promise.futureResult.map(AnyResponse.init)
	}
}

extension ImperialController: RouteCollection {
	func boot(router: Router) throws {
		guard let callbackURL = Environment.get("SHOPIFY_CALLBACK_URL") else { fatalError("Callback not set") }
		
		shopifyRouter = try Shopify(
			router: router,
			authenticate: "login-shopify",
			authenticateCallback: nil,
			callback: callbackURL,
			scope: ["read_marketing_events", "write_marketing_events"],
			completion: processShopifyLogin
		)
		
		router.get(authenticateSlug, use: authenticate)
		router.get("begin_auth", use: beginAuth)
	}
	
	func processShopifyLogin(request: Request, token: String) throws -> Future<ResponseEncodable> {
		return request.future(request.redirect(to: "/marketing_events"))
	}
}
