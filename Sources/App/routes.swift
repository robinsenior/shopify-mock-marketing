import Vapor
import Imperial

/// Register your application's routes here.
public func routes(_ router: Router) throws {
	try router.register(collection: MarketingEventsController())
	try router.register(collection: MarketingActivitiesExtensionController())
	
	let imperial = ImperialController()
	try router.register(collection: imperial)
	
	let appGroup = router.grouped("app")
	let authController = OAuthController()
	authController.imperial = imperial
	
	try appGroup.register(collection: authController)
}
