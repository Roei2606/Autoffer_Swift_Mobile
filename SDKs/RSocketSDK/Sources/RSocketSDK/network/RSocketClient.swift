import Foundation

public protocol RSocketClient: Sendable {
    func requestResponse<T: Encodable>(route: String, data: T) async throws -> Data
    func requestStream<T: Encodable>(route: String, data: T) async throws -> AsyncThrowingStream<Data, Error>
    var isDisposed: Bool { get }
}
