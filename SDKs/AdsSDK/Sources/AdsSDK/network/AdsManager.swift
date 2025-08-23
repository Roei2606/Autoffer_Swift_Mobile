import Foundation
import RSocketSDK
import CoreModelsSDK

public protocol AdsManaging {
    func getAds(for profileType: UserType) async throws -> [Ad]
}

public final class AdsManager: AdsManaging {

    private let client: any RSocketClient

    // Prefer DI
    public init(client: any RSocketClient) {
        self.client = client
    }

    // Convenience initializer that talks to the actor-based manager
    public convenience init(clientManager: RSocketClientManager = .shared) async throws {
        let cli = try await clientManager.getOrConnect()
        self.init(client: cli)
    }

    public func getAds(for profileType: UserType) async throws -> [Ad] {
        try ensureConnected()

        // If your server expects strings, change to profileType.rawValue
        let request = GetAdsForAudienceRequest(profileType: profileType)

        // Route must match your server @MessageMapping
        let stream = try await client.requestStream(
            route: AdsRoutes.getAdsForAudience,
            data: request
        )

        var items: [Ad] = []
        for try await chunk in stream {
            // Use RSocketJSON.decoder if you have it, else JSONDecoder()
            let ad = try JSONDecoder().decode(Ad.self, from: chunk)
            items.append(ad)
        }
        return items
    }

    private func ensureConnected() throws {
        if client.isDisposed { throw RSocketError.notConnected }
    }
}
