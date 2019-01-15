import Vapor
import Imperial

/// Register your application's routes here.
public func routes(_ router: Router) throws {
	try router.register(collection: ImperialController())
	try router.register(collection: MarketingEventsController())
	try router.register(collection: MarketingActivitiesExtensionController())
}
