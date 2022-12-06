
extension Collection where Element == PerduxAction {
	internal func sequentialPerform(
		fileID: String = #fileID,
		functionName: String = #function,
		lineNumber: Int = #line
	) async {
		await ActionDispatcher.sequentialPerform(self.map { $0 }, fileID: fileID, functionName: functionName, lineNumber: lineNumber)
	}
	
	internal func concurrentPerform(
		fileID: String = #fileID,
		functionName: String = #function,
		lineNumber: Int = #line
	) async {
		await ActionDispatcher.concurrentPerform(self.map { $0 }, fileID: fileID, functionName: functionName, lineNumber: lineNumber)
	}
	
	internal func concurrentPerform(
		delay: Double,
		fileID: String = #fileID,
		functionName: String = #function,
		lineNumber: Int = #line
	) async {
		await ActionDispatcher.concurrentPerform(self.map { $0 }, delay: delay, fileID: fileID, functionName: functionName, lineNumber: lineNumber)
	}
}

extension PerduxAction {
	internal func perform(
		fileID: String = #fileID,
		functionName: String = #function,
		lineNumber: Int = #line
	) async {
		await ActionDispatcher.emitAsync(self, fileID: fileID, functionName: functionName, lineNumber: lineNumber)
	}
	
	internal func delayedPerform(
		delay: Double,
		fileID: String = #fileID,
		functionName: String = #function,
		lineNumber: Int = #line
	) async {
		await ActionDispatcher.emitAsync(self, delay: delay, fileID: fileID, functionName: functionName, lineNumber: lineNumber)
	}
}
