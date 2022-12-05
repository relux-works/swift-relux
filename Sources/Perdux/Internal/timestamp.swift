import Darwin

@usableFromInline
struct timestamp {
	
	@usableFromInline
	static var seconds: Int {
		var timespec = timespec()
		timespec_get(&timespec, TIME_UTC)
		return timespec.tv_sec
	}
	
	@usableFromInline //@inline(__always)
	static var milliseconds: Int {
		var timespec = timespec()
		timespec_get(&timespec, TIME_UTC)
		var millis = timespec.tv_sec * 1000
		millis += timespec.tv_nsec/1000000
		
		if (timespec.tv_nsec % 1000000 >= 500000) {
			millis+=1;
		}
		
		return millis
	}
	
	
	@usableFromInline// @inline(__always)
	static var microseconds: Int {
		var timespec = timespec()
		timespec_get(&timespec, TIME_UTC)
		var micros = timespec.tv_sec * 1000000
		micros += timespec.tv_nsec/1000
		
		if (timespec.tv_nsec % 1000 >= 500) {
			micros+=1;
		}
		
		return micros
	}
}
