import Foundation

public struct Glass: Codable, Hashable {
    public let id: String?
    public let type: String?
    public let supportedProfiles: [String]?
    public let pricePerSquareMeter: Double?
    public var imageData: Data?          // List<Byte> -> Data (Base64)

    public init(id: String? = nil,
                type: String? = nil,
                supportedProfiles: [String]? = nil,
                pricePerSquareMeter: Double? = nil,
                imageData: Data? = nil) {
        self.id = id
        self.type = type
        self.supportedProfiles = supportedProfiles
        self.pricePerSquareMeter = pricePerSquareMeter
        self.imageData = imageData
    }
}
