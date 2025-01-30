
public extension Relux {
	/// Provides caseName and associatedValues custom mirrors for enumerations.
	 protocol EnumReflectable: CaseNameReflectable, AssociatedValuesReflectable {
		var subsystem: String { get }
		var category: String { get }
	}
}

public extension Relux.EnumReflectable {
	
	var subsystem: String { "Relux" }
	
	var category: String { "Logger" }
}
	
public extension Relux {
	// reflecting enum cases
	protocol CaseNameReflectable {
		var caseName: String { get }
	}
}

public extension Relux.CaseNameReflectable {
	var caseName: String {
		let mirror = Mirror(reflecting: self)
		guard let caseName = mirror.children.first?.label else {
			return "\(mirror.subjectType).\(self)"
		}
		return "\(mirror.subjectType).\(caseName)"
	}
}

// reflecting enum associated values
public extension Relux {
	protocol AssociatedValuesReflectable {
		var associatedValues:  [String]  { get }
	}
}

public extension Relux.AssociatedValuesReflectable {
    var _associatedValues: [String : String] {
        var values = [String : String]()
        guard let associated = Mirror(reflecting: self).children.first else {
            return values
        }
        
        // Try to reflect deeper
        let children = Mirror(reflecting: associated.value).children
        
        if children.isEmpty {
            // Single unlabeled case
            values["value"] = String(describing: associated.value)
        } else {
            // We have multiple labeled properties
            for case let (label?, childValue) in children {
                values[label] = String(describing: childValue)
            }
        }
        return values
    }
}

public extension Relux.AssociatedValuesReflectable {
    var associatedValues: [String] {
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
