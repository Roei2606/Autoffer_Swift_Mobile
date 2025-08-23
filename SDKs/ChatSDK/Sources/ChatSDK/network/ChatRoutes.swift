import Foundation

public enum ChatRoutes {
    public static let getAll         = "chats.getAll"
    public static let getMessages    = "chats.getMessages"
    public static let getOrCreate    = "chats.getOrCreate"
    public static let streamMessages = "chats.stream"        // adjust if your server uses a different name
    public static let getUnreadCount = "chats.unreadCount"
}
