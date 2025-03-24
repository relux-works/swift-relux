extension Relux {
    /// Provides caseName and associatedValues custom mirrors for enumerations.
    public protocol EnumReflectable: CaseNameReflectable, AssociatedValuesReflectable {
        var subsystem: String { get }
        var category: String { get }
    }
}

extension Relux.EnumReflectable {
    public var subsystem: String { "Relux" }
    public var category: String { "Logger" }
}

extension Relux {
    // reflecting enum cases
    public protocol CaseNameReflectable {
        var caseName: String { get }
    }
}

extension Relux.CaseNameReflectable {
    public var caseName: String {
        let mirror = Mirror(reflecting: self)
        guard let caseName = mirror.children.first?.label else {
            return "\(mirror.subjectType).\(self)"
        }
        return "\(mirror.subjectType).\(caseName)"
    }
}

// reflecting enum associated values
extension Relux {
    public protocol AssociatedValuesReflectable {
        var associatedValues: [String] { get }
    }
}

extension Relux.AssociatedValuesReflectable {
    public var associatedValues: [String] {
        var values = [String]()
        guard let associated = Mirror(reflecting: self).children.first else {
            return values
        }

        let valueMirror = Mirror(reflecting: associated.value)
        switch valueMirror.displayStyle {
        case .tuple:
            // Handle tuples (multiple parameters) with labels (e.g., ".0" → "0")
            for child in valueMirror.children {
                let label = child.label?.replacingOccurrences(
                    of: "^\\.",
                    with: "",
                    options: .regularExpression
                )
                let value = String(describing: child.value)
                values.append(label != nil ? "\(label!): \(value)" : value)
            }
        default:
            // For single values, append the value WITHOUT any label
            let value = String(describing: associated.value)
            values.append(value)
        }
        return values
    }
}
