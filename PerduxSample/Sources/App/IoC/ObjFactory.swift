import Swinject

typealias F = ObjectFactory

class ObjectFactory {
    private static var defaultContainer: Container?

    public static func initialize(with container: Container) {
        defaultContainer = container
    }

    public static func deInitialize() {
        defaultContainer = nil
    }

    public static func get<Service>(type: Service.Type, name: String? = nil) -> Service? {
        if let name = name {
            return defaultContainer?.synchronize().resolve(type, name: name)
        }
        return defaultContainer?.synchronize().resolve(type)
    }
}
