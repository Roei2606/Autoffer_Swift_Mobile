import Foundation

public enum RSocketJSON {
    public static let encoder: JSONEncoder = {
        let enc = JSONEncoder()
        // שמירה בפורמט ISO-8601 (מקביל ל-JavaTimeModule + בלי timestamps)
        enc.dateEncodingStrategy = .iso8601
        return enc
    }()

    public static let decoder: JSONDecoder = {
        let dec = JSONDecoder()
        dec.dateDecodingStrategy = .iso8601
        return dec
    }()
}

public enum RSocketUtils {
    /// אנקוד כל טיפוס Encodable ל-Data JSON; אם זה String/Enum – נחזיר UTF8 של הערך, בדומה למימוש בג׳אווה
    public static func encodeData<T: Encodable>(_ data: T) throws -> Data {
        switch data {
        case let s as String:
            return Data(s.utf8)
        case let e as any RawRepresentable where e.rawValue is String:
            return Data(String(describing: (e.rawValue as! String)).utf8)
        default:
            return try RSocketJSON.encoder.encode(data)
        }
    }

    /// מקביל ל-parsePayloadAsByteList – אם קיבלת Data בינארי ורוצה רשימת בתים
    public static func dataToByteList(_ data: Data) -> [UInt8] {
        return [UInt8](data)
    }
}
