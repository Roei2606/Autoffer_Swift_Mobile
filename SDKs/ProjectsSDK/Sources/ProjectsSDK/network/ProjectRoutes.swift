import Foundation

public enum ProjectRoutes {
    public static let getAllForUser         = "projects.getAllForUser"
    public static let sendToFactories       = "projects.sendToFactories"
    public static let respondToBoqRequest   = "projects.respondToBoqRequest"
    public static let deleteProject         = "projects.delete"
    public static let matchProfilesBySize   = "profiles.matchBySize"
    public static let glassesByProfile      = "glasses.getByProfile"
    public static let createProject         = "project.create"
    public static let updateFactoryStatus   = "projects.updateFactoryStatus"
    public static let getQuotePdfForFactory = "projects.getQuotePdfForFactory"
}
