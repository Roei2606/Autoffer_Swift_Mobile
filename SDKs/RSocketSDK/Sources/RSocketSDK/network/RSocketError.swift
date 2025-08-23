import Foundation

public enum RSocketError: Error, Sendable {
    case notConnected
    case transportClosed
    case encodeFailed
    case decodeFailed
    case serverError(String)
}
