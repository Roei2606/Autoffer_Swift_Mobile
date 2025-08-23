import Foundation

public enum RSocketClientFactory {
    public static func create(urlString: String) async throws -> RSocketClient {
        return RSocketMockClient()
    }
}

public final class RSocketMockClient: RSocketClient, @unchecked Sendable {
    public var isDisposed: Bool = false
    public init() {}

    public func requestResponse<T: Encodable>(route: String, data: T) async throws -> Data {
        let payload: [String: Any] = [
            "route": route,
            "echo": String(data: try JSONEncoder().encode(EncodableBox(data)), encoding: .utf8) ?? "{}"
        ]
        return try JSONSerialization.data(withJSONObject: payload)
    }

    public func requestStream<T: Encodable>(route: String, data: T) async throws -> AsyncThrowingStream<Data, Error> {
        let first  = try JSONSerialization.data(withJSONObject: ["route": route, "idx": 1])
        let second = try JSONSerialization.data(withJSONObject: ["route": route, "idx": 2])
        return AsyncThrowingStream { cont in
            Task {
                cont.yield(first)
                try? await Task.sleep(nanoseconds: 120_000_000)
                cont.yield(second)
                cont.finish()
            }
        }
    }
}

private struct EncodableBox<T: Encodable>: Encodable {
    let wrapped: T
    init(_ wrapped: T) { self.wrapped = wrapped }
    func encode(to encoder: Encoder) throws { try wrapped.encode(to: encoder) }
}
