import Foundation

/// שולח ping לשרת ומחזיר את תגובת הטקסט
public enum PingSender {
    public static func sendPing() async -> Result<String, Error> {
        do {
            let client = try await RSocketClientManager.shared.getOrConnect()
            // ב-Android שלחת "ping from android" – כאן "ping from ios" לשקיפות
            let data = try await client.requestResponse(route: "ping", data: "ping from ios")
            let reply = String(data: data, encoding: .utf8) ?? ""
            return .success(reply)
        } catch {
            return .failure(error)
        }
    }
}
