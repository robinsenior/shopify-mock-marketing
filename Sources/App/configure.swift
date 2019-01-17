import Vapor
import Leaf

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    /// Register providers first
	try services.register(LeafProvider())
	services.register(LogMiddleware.self)

    /// Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    /// Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
	middlewares.use(LogMiddleware.self)
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
	middlewares.use(SessionsMiddleware.self) // Federated authentication
    services.register(middlewares)
	
	config.prefer(LeafRenderer.self, for: ViewRenderer.self)
}
