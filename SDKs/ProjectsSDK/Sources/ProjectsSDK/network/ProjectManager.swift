import Foundation
import RSocketSDK         // צריך להגדיר שם: RSocketClient, RSocketClientManager.shared, RSocketJSON.decoder/encoder
import ProjectsSDK        // כדי לגשת למודלים (ProjectDTO/AlumProfile/Glass/QuoteStatus/ItemModelDTO)

public protocol ProjectManaging {
    func getUserProjects(_ request: UserProjectRequest) async throws -> [ProjectDTO]
    func sendBOQToFactories(_ request: SendBOQRequest) async throws
    func respondToBoqRequest(_ request: UpdateFactoryStatusRequest) async throws
    func deleteProjectById(_ projectId: String) async throws
    func getMatchingProfiles(width: Int, height: Int) async throws -> [AlumProfile]
    func getGlassesForProfile(profileNumber: String) async throws -> [Glass]
    func createProject(_ request: CreateProjectRequest) async throws -> ProjectDTO
    func updateFactoryStatus(projectId: String, factoryId: String, newStatus: QuoteStatus) async throws
    func getQuotePdf(projectId: String, factoryId: String) async throws -> Data
}

public final class ProjectManager: ProjectManaging {

    private let client: RSocketClient

    public init(client: RSocketClient) {
        self.client = client
    }

    public convenience init() async throws {
        let cli = try await RSocketClientManager.shared.getOrConnect()
        self.init(client: cli)
    }


    // MARK: - API

    public func getUserProjects(_ request: UserProjectRequest) async throws -> [ProjectDTO] {
        try ensureConnected()
        let stream = try await client.requestStream(route: ProjectRoutes.getAllForUser, data: request)
        var items: [ProjectDTO] = []
        for try await chunk in stream {
            items.append(try RSocketJSON.decoder.decode(ProjectDTO.self, from: chunk))
        }
        return items
    }

    public func sendBOQToFactories(_ request: SendBOQRequest) async throws {
        try ensureConnected()
        _ = try await client.requestResponse(route: ProjectRoutes.sendToFactories, data: request)
    }

    public func respondToBoqRequest(_ request: UpdateFactoryStatusRequest) async throws {
        try ensureConnected()
        _ = try await client.requestResponse(route: ProjectRoutes.respondToBoqRequest, data: request)
    }

    public func deleteProjectById(_ projectId: String) async throws {
        try ensureConnected()
        // באנדרואיד נשלח מחרוזת גולמית – נשמור על זה:
        struct Raw: Codable { let value: String }
        _ = try await client.requestResponse(route: ProjectRoutes.deleteProject, data: Raw(value: projectId))
    }

    public func getMatchingProfiles(width: Int, height: Int) async throws -> [AlumProfile] {
        try ensureConnected()
        let req = SizeRequest(width: width, height: height)
        let stream = try await client.requestStream(route: ProjectRoutes.matchProfilesBySize, data: req)
        var profiles: [AlumProfile] = []
        for try await chunk in stream {
            profiles.append(try RSocketJSON.decoder.decode(AlumProfile.self, from: chunk))
        }
        return profiles
    }

    public func getGlassesForProfile(profileNumber: String) async throws -> [Glass] {
        try ensureConnected()
        // באנדרואיד נשלח profileNumber כמחרוזת – נשמור על זה
        struct Raw: Codable { let value: String }
        let stream = try await client.requestStream(route: ProjectRoutes.glassesByProfile, data: Raw(value: profileNumber))
        var glasses: [Glass] = []
        for try await chunk in stream {
            glasses.append(try RSocketJSON.decoder.decode(Glass.self, from: chunk))
        }
        return glasses
    }

    public func createProject(_ request: CreateProjectRequest) async throws -> ProjectDTO {
        try ensureConnected()
        let data = try await client.requestResponse(route: ProjectRoutes.createProject, data: request)
        return try RSocketJSON.decoder.decode(ProjectDTO.self, from: data)
    }

    public func updateFactoryStatus(projectId: String, factoryId: String, newStatus: QuoteStatus) async throws {
        try ensureConnected()
        let req = UpdateFactoryStatusRequest(projectId: projectId, factoryId: factoryId, newStatus: newStatus)
        _ = try await client.requestResponse(route: ProjectRoutes.updateFactoryStatus, data: req)
    }

    public func getQuotePdf(projectId: String, factoryId: String) async throws -> Data {
        try ensureConnected()
        let req = GetQuotePdfRequest(projectId: projectId, factoryId: factoryId)
        let data = try await client.requestResponse(route: ProjectRoutes.getQuotePdfForFactory, data: req)
        // השרת מחזיר byte[] → ב-Swift זה Data; אם מגיע JSON עטוף של Base64, תתאים כאן בהתאם.
        return data
    }

    // MARK: - Helpers
    private func ensureConnected() throws {
        if client.isDisposed { throw RSocketError.notConnected }
    }
}
