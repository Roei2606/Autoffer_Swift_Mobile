import Foundation

public struct ProjectDTO: Codable, Hashable {
    public var projectId: String?
    public var clientId: String?
    public var projectAddress: String?
    public var items: [ItemModelDTO]?
    public var factoryIds: [String]?

    // factoryId -> "PENDING"/"ACCEPTED"/...
    public var quoteStatuses: [String: String]?

    // factoryId -> Quote
    public var quotes: [String: Quote]?

    public var boqPdf: Data?      // List<Byte> -> Data
    public var createdAt: String?

    public init(projectId: String? = nil,
                clientId: String? = nil,
                projectAddress: String? = nil,
                items: [ItemModelDTO]? = nil,
                factoryIds: [String]? = nil,
                quoteStatuses: [String: String]? = nil,
                quotes: [String: Quote]? = nil,
                boqPdf: Data? = nil,
                createdAt: String? = nil) {
        self.projectId = projectId
        self.clientId = clientId
        self.projectAddress = projectAddress
        self.items = items
        self.factoryIds = factoryIds
        self.quoteStatuses = quoteStatuses
        self.quotes = quotes
        self.boqPdf = boqPdf
        self.createdAt = createdAt
    }
}
