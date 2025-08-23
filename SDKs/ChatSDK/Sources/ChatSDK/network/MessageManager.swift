import Foundation
import RSocketSDK
import CoreModelsSDK

public protocol MessageManaging {
    func sendMessage(_ message: Message) async throws -> Message
    func sendFileMessage(_ request: FileMessageRequest) async throws
}

public final class MessageManager: MessageManaging {
    private let client: any RSocketClient

    // DI init
    public init(client: any RSocketClient) {
        self.client = client
    }

    // Convenience init that talks to the actor-based manager
    public convenience init(clientManager: RSocketClientManager = .shared) async throws {
        let cli = try await clientManager.getOrConnect()
        self.init(client: cli)
    }

    public func sendMessage(_ message: Message) async throws -> Message {
        try ensureConnected()
        let data = try await client.requestResponse(route: MessageRoutes.sendMessage, data: message)
        return try JSONDecoder().decode(Message.self, from: data)   // use RSocketJSON.decoder if you have one
    }

    public func sendFileMessage(_ request: FileMessageRequest) async throws {
        try ensureConnected()
        _ = try await client.requestResponse(route: MessageRoutes.sendFile, data: request)
    }

    // MARK: - Helpers
    private func ensureConnected() throws {
        if client.isDisposed { throw RSocketError.notConnected }
    }
}
