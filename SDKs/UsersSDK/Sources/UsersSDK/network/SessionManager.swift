import Foundation
import CoreModelsSDK  // User, UserType

public enum UserSessionError: Error {
    case notLoggedIn,
    missingProfileType
}

/// Thread-safe singleton for the logged-in user/session.
public actor SessionManager {
    public static let shared = SessionManager()
    private init() {}

    public private(set) var currentUserId: String?
    public private(set) var currentUser: User?

    // Set only the ID (before you have the full user)
    @discardableResult
    public func setCurrentUserId(_ id: String?) -> String? {
        currentUserId = id
        return id
    }

    // Set the full user (also updates currentUserId)
    public func setCurrentUser(_ user: User?) {
        currentUser = user
        currentUserId = user?.id
    }

    // Getters
    public func getCurrentUserId() -> String? { currentUserId }
    public func getCurrentUser() -> User? { currentUser }

    public func getCurrentUserProfileType() throws -> UserType {
            guard let user = currentUser else { throw UserSessionError.notLoggedIn }
            guard let type = user.profileType else { throw UserSessionError.missingProfileType }
            return type
        }

    public var isLoggedIn: Bool { currentUser != nil }

    // Logout / clear
    public func clear() {
        currentUser = nil
        currentUserId = nil
    }
}
