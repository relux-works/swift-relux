public extension Relux {
	protocol Logger {
		func logAction(
			_ action: Relux.EnumReflectable,
			startTimeInMillis: Int,
			privacy: Relux.OSLogPrivacy,
			fileID: String,
			functionName: String,
			lineNumber: Int
		)
		
		func logAction(
			_ action: Relux.EnumReflectable,
			text: String,
			privacy: Relux.OSLogPrivacy,
			fileID: String,
			functionName: String,
			lineNumber: Int
		)
	}
}


public extension Relux {
	/// A proxy type to work around apple os log [limitations](https://stackoverflow.com/questions/62675874/xcode-12-and-oslog-os-log-wrapping-oslogmessage-causes-compile-error-argumen#63036815).
	///
	///
	enum OSLogPrivacy: Equatable {
		case  auto, `public`, `private`, sensitive
	}
}
