import Foundation
import RSocketSDK
import CoreModelsSDK   // User, UserType
import UsersSDK        // your request DTOs live here (LoginRequest, etc.)

public final class UserManager {
    private let client: any RSocketClient
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()

    // Dependency injection
    public init(client: any RSocketClient) { self.client = client }

    // Convenience init (uses the actor-based manager)
    public convenience init(clientManager: RSocketClientManager = .shared) async throws {
        let cli = try await clientManager.getOrConnect()
        self.init(client: cli)
    }

    // MARK: - API (async/await)

    @discardableResult
    public func loginUser(email: String, password: String) async throws -> User {
        try ensureConnected()
        let req = LoginRequest(email: email, password: password)
        let data = try await client.requestResponse(route: UsersRoutes.login, data: req)
        let user = try decoder.decode(User.self, from: data)

        // optional: keep session in memory
        await SessionManager.shared.setCurrentUser(user)
        return user
    }

    @discardableResult
    public func registerUser(_ request: RegisterUserRequest) async throws -> User {
        try ensureConnected()
        let data = try await client.requestResponse(route: UsersRoutes.register, data: request)
        return try decoder.decode(User.self, from: data)
    }

    public func getAllUsers() async throws -> [User] {
        try ensureConnected()
        struct Empty: Codable {}
        let stream = try await client.requestStream(route: UsersRoutes.getAll, data: Empty())
        var users: [User] = []
        for try await chunk in stream {
            users.append(try decoder.decode(User.self, from: chunk))
        }
        return users
    }

    public func getUserById(_ userId: String) async throws -> User {
        try ensureConnected()
        let req = UserIdRequest(userId: userId)
        let data = try await client.requestResponse(route: UsersRoutes.getById, data: req)
        return try decoder.decode(User.self, from: data)
    }

    public func resetPassword(_ request: ResetPasswordRequest) async throws {
        try ensureConnected()
        _ = try await client.requestResponse(route: UsersRoutes.resetPass, data: request)
    }

    public func getUsers(by type: UserType) async throws -> [User] {
        try ensureConnected()
        // If your server expects the enum rawValue (string), the request struct can wrap it.
        // Here we just send the raw value directly.
        let stream = try await client.requestStream(route: UsersRoutes.getByType, data: type.rawValue)
        var users: [User] = []
        for try await chunk in stream {
            users.append(try decoder.decode(User.self, from: chunk))
        }
        return users
    }

    // MARK: - Helpers
    private func ensureConnected() throws {
        if client.isDisposed { throw RSocketError.notConnected }
    }
}
