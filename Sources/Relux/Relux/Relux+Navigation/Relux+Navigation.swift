
extension Relux {
    public enum Navigation {}
}

extension Relux.Navigation {
    public protocol RouterProtocol: Relux.HybridState { }
    public protocol PathComponent: Equatable, Hashable, Sendable {}
    public protocol PathCodableComponent: PathComponent, Codable {}
    
    public protocol ModalComponent: PathComponent, Identifiable {}
    public protocol ModalCodableComponent: ModalComponent, Codable, Identifiable {}
}

public extension Relux.Navigation.ModalComponent {
    var id: Int { self.hashValue }
}


public extension Relux.Navigation.ModalCodableComponent {
    var id: Int { self.hashValue }
}
