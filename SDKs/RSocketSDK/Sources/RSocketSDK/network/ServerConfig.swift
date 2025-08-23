import Foundation

public enum ServerConfig {
    /// מחזיר כתובת שרת לפי סביבת ריצה (סימולטור/מכשיר)
    public static func getServerUrl() -> String {
        #if targetEnvironment(simulator)
        return ServerConstants.SIMULATOR_SERVER_URL
        #else
        return ServerConstants.PUBLIC_SERVER_URL
        #endif
    }
}
