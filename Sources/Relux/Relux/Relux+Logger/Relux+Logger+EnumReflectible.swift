
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
		var associatedValues: [String: String] { get }
	}
}
public extension Relux.AssociatedValuesReflectable {
	var associatedValues: [String: String] {
		var values = [String: String]()
		guard let associated = Mirror(reflecting: self).children.first else {
			return values
		}
		
		let children = Mirror(reflecting: associated.value).children
		for case let item in children {
			if let label = item.label {
				values[label] = String(describing: item.value)
			}
		}
		return values
	}
}

