import Foundation
import Swinject
import Get

class DIContainer {
    public static func build() -> Container {
        let container = Container()

        utilsModule(container: container)
        persistenceModule(container: container)
        statsModule(container: container)

        return container
    }

    private static func utilsModule(container: Container) {
        
    }

    private static func persistenceModule(container: Container) {

    }

    private static func statsModule(container: Container) {

    }

}
