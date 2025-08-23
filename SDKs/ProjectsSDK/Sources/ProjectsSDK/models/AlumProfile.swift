import Foundation

public struct AlumProfile: Codable, Hashable {
    public let id: String?
    public let profileNumber: String?
    public let usageType: String?            // Enum name as String
    public let minHeight: Int?
    public let maxHeight: Int?
    public let minWidth: Int?
    public let maxWidth: Int?
    public let isExpensive: Bool?
    public let recommendedGlassType: String?
    public let pricePerSquareMeter: Double?
    public let imageData: Data?              // byte[] -> Data (Base64)

    public init(id: String? = nil,
                profileNumber: String? = nil,
                usageType: String? = nil,
                minHeight: Int? = nil,
                maxHeight: Int? = nil,
                minWidth: Int? = nil,
                maxWidth: Int? = nil,
                isExpensive: Bool? = nil,
                recommendedGlassType: String? = nil,
                pricePerSquareMeter: Double? = nil,
                imageData: Data? = nil) {
        self.id = id
        self.profileNumber = profileNumber
        self.usageType = usageType
        self.minHeight = minHeight
        self.maxHeight = maxHeight
        self.minWidth = minWidth
        self.maxWidth = maxWidth
        self.isExpensive = isExpensive
        self.recommendedGlassType = recommendedGlassType
        self.pricePerSquareMeter = pricePerSquareMeter
        self.imageData = imageData
    }
}
