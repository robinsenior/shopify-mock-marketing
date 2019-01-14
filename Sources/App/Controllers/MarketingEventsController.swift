import Vapor
import Leaf
import Authentication

struct MarketingEventsController: RouteCollection {
	func boot(router: Router) throws {
		let marketingEventsRoute = router.grouped("marketing_events")
		marketingEventsRoute.get(use: getAllHandler)
		marketingEventsRoute.get("new", use: createMarketingEventHandler)
		marketingEventsRoute.post(CreateMarketingEventData.self, at: "new", use: createMarketingEventPostHandler)
	}
	
	func getAllHandler(_ req: Request) throws -> Future<View> {
		let api = try ShopifyAPI(session: req.session())
		
		return try api.get(resource: MarketingEvents.self, request: req)
			.flatMap(to: View.self) { marketingEvents in
				let context = AllMarketingEventsContext(marketingEvents: marketingEvents.marketingEvents)
				return try req.view().render("allMarketingEvents", context)
			}
	}
	
	func createMarketingEventHandler(_ req: Request) throws -> Future<View> {
		let token = try CryptoRandom().generateData(count: 16).base64EncodedString()
		let context = CreateMarketingEventContext(csrfToken: token)
		
		try req.session()["CSRF_TOKEN"] = token
		
		return try req.view().render("createMarketingEvent", context)
	}
	
	func createMarketingEventPostHandler(_ req: Request, data: CreateMarketingEventData) throws -> Future<Response> {
		let expectedToken = try req.session()["CSRF_TOKEN"]
		try req.session()["CSRF_TOKEN"] = nil
		
		guard expectedToken == data.csrfToken else {
			throw Abort(.badRequest)
		}
		
		let api = try ShopifyAPI(session: req.session())
		
		let marketingEvent = MarketingEvent(
			id: nil,
			description: data.description,
			eventType: data.eventType,
			marketingChannel: .display,
			paid: false,
			startedAt: Date()
		)

		return try api.post(resource: marketingEvent, request: req)
			.transform(to: req.redirect(to: "/marketing_events"))
	}
}

struct AllMarketingEventsContext: Encodable {
	let title = "All Marketing Events"
	let marketingEvents: [MarketingEvent]
}

struct CreateMarketingEventContext: Encodable {
	let title = "Create Marketing Event"
	let csrfToken: String
}

struct CreateMarketingEventData: Content {
	let description: String
	let eventType: MarketingEvent.EventType
	let csrfToken: String
}
