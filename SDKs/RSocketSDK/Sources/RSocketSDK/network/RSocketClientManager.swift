import Foundation

public actor RSocketClientManager {
    public static let shared = RSocketClientManager()

    // Readable from other modules, but only this actor can mutate it
    public private(set) var client: (any RSocketClient)?
    private var connecting = false

    private init() {}

    public var isConnected: Bool {
        if let client, client.isDisposed == false { return true }
        return false
    }

    /// Establish a connection if not already connected.
    @discardableResult
    public func connect() async -> Bool {
        if isConnected { return true }
        if connecting { return false }
        connecting = true
        defer { connecting = false }

        let urlString = ServerConfig.getServerUrl()
        do {
            let c = try await RSocketClientFactory.create(urlString: urlString)
            self.client = c
            return isConnected
        } catch {
            self.client = nil
            return false
        }
    }

    /// Returns a connected client or throws if the connection cannot be made.
    public func getOrConnect() async throws -> any RSocketClient {
        if !isConnected {
            let ok = await connect()
            if !ok { throw RSocketError.notConnected }
        }
        // client is guaranteed non-nil here
        return client!
    }

    // Testing hooks
    public func setClientForTesting(_ client: any RSocketClient) { self.client = client }
    public func disconnect() { self.client = nil }
}
