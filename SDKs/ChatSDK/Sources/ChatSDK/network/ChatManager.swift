import Foundation
import RSocketSDK
import CoreModelsSDK

public protocol ChatManaging {
    func getUserChats(userId: String, page: Int, size: Int) async throws -> [Chat]
    func getChatMessages(chatId: String, page: Int, size: Int) async throws -> [Message]
    func getOrCreateChat(currentUserId: String, otherUserId: String) async throws -> Chat
    func streamMessages(chatId: String) async throws -> AsyncThrowingStream<Message, Error>
    func getUnreadCount(chatId: String, userId: String) async throws -> Int
    func hasChats(userId: String) async -> Bool
    func disposeMessageStream()
}

public final class ChatManager: ChatManaging {
    private let client: any RSocketClient
    private var messageStreamTask: Task<Void, Never>?

    // DI init
    public init(client: any RSocketClient) {
        self.client = client
    }

    // Use the actor to get a connected client
    public convenience init(clientManager: RSocketClientManager = .shared) async throws {
        let cli = try await clientManager.getOrConnect()
        self.init(client: cli)
    }

    public func getUserChats(userId: String, page: Int, size: Int) async throws -> [Chat] {
        try ensureConnected()
        let req = UserChatsRequest(userId: userId, page: page, size: size)
        let stream = try await client.requestStream(route: ChatRoutes.getAll, data: req)
        var items: [Chat] = []
        for try await data in stream {
            items.append(try JSONDecoder().decode(Chat.self, from: data))
        }
        return items
    }

    public func getChatMessages(chatId: String, page: Int, size: Int) async throws -> [Message] {
        try ensureConnected()
        let req = ChatMessagesRequest(chatId: chatId, page: page, size: size)
        let stream = try await client.requestStream(route: ChatRoutes.getMessages, data: req)
        var items: [Message] = []
        for try await data in stream {
            items.append(try JSONDecoder().decode(Message.self, from: data))
        }
        return items
    }

    public func getOrCreateChat(currentUserId: String, otherUserId: String) async throws -> Chat {
        try ensureConnected()
        let req = ChatRequest(currentUserId: currentUserId, otherUserId: otherUserId) // ← labels match your DTO
        let data = try await client.requestResponse(route: ChatRoutes.getOrCreate, data: req)
        return try JSONDecoder().decode(Chat.self, from: data)
    }

    public func streamMessages(chatId: String) async throws -> AsyncThrowingStream<Message, Error> {
        try ensureConnected()
        struct Raw: Codable { let value: String }
        let stream = try await client.requestStream(route: ChatRoutes.streamMessages, data: Raw(value: chatId))
        return AsyncThrowingStream { cont in
            self.messageStreamTask?.cancel()
            self.messageStreamTask = Task {
                do {
                    for try await data in stream {
                        let msg = try JSONDecoder().decode(Message.self, from: data)
                        cont.yield(msg)
                    }
                    cont.finish()
                } catch {
                    cont.finish(throwing: error)
                }
            }
        }
    }

    public func getUnreadCount(chatId: String, userId: String) async throws -> Int {
        try ensureConnected()
        let req = UnreadCountRequest(chatId: chatId, userId: userId)
        let data = try await client.requestResponse(route: ChatRoutes.getUnreadCount, data: req)
        let resp = try JSONDecoder().decode(UnreadCountResponse.self, from: data)
        return resp.count
    }

    public func hasChats(userId: String) async -> Bool {
        let base = "http://127.0.0.1:8080"
        guard let url = URL(string: "\(base)/hasChats/\(userId)") else { return false }
        var req = URLRequest(url: url); req.httpMethod = "GET"; req.timeoutInterval = 3
        do {
            let (data, resp) = try await URLSession.shared.data(for: req)
            guard let http = resp as? HTTPURLResponse, http.statusCode == 200 else { return false }
            let text = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "false"
            return (text as NSString).boolValue
        } catch { return false }
    }

    public func disposeMessageStream() {
        messageStreamTask?.cancel()
        messageStreamTask = nil
    }

    private func ensureConnected() throws {
        if client.isDisposed { throw RSocketError.notConnected }
    }
}
