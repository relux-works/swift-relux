import Logger

internal extension Relux {
	actor Dispatcher {
		
		internal private(set) static var subscribers: [Relux.SubscriberRef] = []
		
		internal static func subscribe(_ subscriber: Relux.Subscriber) {
			subscribers.append(.init(subscriber: subscriber))
		}
		
		@inline(__always)
		internal static func sequentialPerform(
			_ actions: [Relux.Action],
			delay: Seconds?,
			fileID: String,
			functionName: String,
			lineNumber: Int
		) async {
			
			if let delay {
				let delay = UInt64(delay * 1_000_000_000)
				try? await Task<Never, Never>.sleep(nanoseconds: delay)
			}
			
			await actions
				.asyncForEach { action in
					log(action, fileID: fileID, functionName: functionName, lineNumber: lineNumber)
					await subscribers
						.concurrentForEach { await $0.subscriber?.notify(action) }
				}
		}
		
		@inline(__always)
		internal static func concurrentPerform(
			_ actions: [Relux.Action],
			delay: Seconds?,
			fileID: String,
			functionName: String,
			lineNumber: Int
		) async {
			if let delay {
				let delay = UInt64(delay * 1_000_000_000)
				try? await Task<Never, Never>.sleep(nanoseconds: delay)
			}
			
			await actions
				.concurrentForEach { action in
					log(action, fileID: fileID, functionName: functionName, lineNumber: lineNumber)
					await subscribers
						.concurrentForEach { await $0.subscriber?.notify(action) }
				}
		}
		
		
	}
}
