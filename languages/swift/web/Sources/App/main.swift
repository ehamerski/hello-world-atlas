import Vapor

@main
struct HelloWeb {
    static func main() async throws {
        let app = try await Application.make()
        
        app.get { req in
            "Hello, World!"
        }
        
        try await app.execute()
    }
}
