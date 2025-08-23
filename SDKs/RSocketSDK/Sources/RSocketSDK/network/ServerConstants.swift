import Foundation

public enum ServerConstants {
    /// בסימולטור iOS ניגשים ל־localhost ישירות (לא 10.0.2.2 כמו אנדרואיד)
    public static let SIMULATOR_SERVER_URL = "ws://127.0.0.1:8080/rsocket"

    /// אותו Production URL כמו באנדרואיד
    public static let PUBLIC_SERVER_URL = "wss://autoffer-server-313683195324.europe-west1.run.app/rsocket"
}
