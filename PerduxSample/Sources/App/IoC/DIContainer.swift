import Foundation
import Swinject
import Get

class DIContainer {
    public static func build() -> Container {
        let container = Container()

        utilsModule(container: container)
        persistenceModule(container: container)
        statsModule(container: container)
        settingsModule(container: container)

        return container
    }

    private static func utilsModule(container: Container) {
        
    }

    private static func persistenceModule(container: Container) {

    }

    private static func statsModule(container: Container) {

    }

    private static func settingsModule(container: Container) {
        container.register(ISettingsService.self) { (resolver: Resolver) -> ISettingsService in
                    SettingsService(store: UserDefaults.standard)
                }
                .inObjectScope(.container)

        container.register(ISettingsSaga.self) { (resolver: Resolver) -> ISettingsSaga in
                    SettingsSaga(
                            settingsSvc: resolver.resolve(ISettingsService.self)!
                    )
                }
                .inObjectScope(.container)
    }
}
