import Vapor

final class LogMiddleware: Middleware {
	let logger: Logger
	
	init(logger: Logger) {
		self.logger = logger
	}
	
	func respond(to req: Request, chainingTo next: Responder) throws -> Future<Response> {
		let start = Date()
		logger.info(req.description)
		return try next.respond(to: req).map { res in
			self.log(res, start: start, for: req)
			
			return res
		}
	}
	
	func log(_ res: Response, start: Date, for req: Request) {
		let reqInfo = "\(req.http.method.string) \(req.http.url.path)"
		let resInfo = "\(res.http.status.code) " + "\(res.http.status.reasonPhrase)"
		let time = Date().timeIntervalSince(start)
		logger.info("\(reqInfo) -> \(resInfo) [\(time)]")
	}
}

extension LogMiddleware: ServiceType {
	static func makeService(for container: Container) throws -> LogMiddleware {
		return try .init(logger: container.make())
	}
}
