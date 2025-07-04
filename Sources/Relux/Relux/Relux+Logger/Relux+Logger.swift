extension Relux {
    public protocol Logger: Sendable {
        func logAction(
            _ action: Relux.EnumReflectable,
            result: Relux.ActionResult?,
            startTimeInMillis: Int,
            privacy: Relux.OSLogPrivacy,
            fileID: String,
            functionName: String,
            lineNumber: Int
        )
    }
}

extension Relux {
    /// A proxy type to work around apple os log [limitations](https://stackoverflow.com/questions/62675874/xcode-12-and-oslog-os-log-wrapping-oslogmessage-causes-compile-error-argumen#63036815).
    public enum OSLogPrivacy: Equatable {
        case auto, `public`, `private`, sensitive
    }
}
