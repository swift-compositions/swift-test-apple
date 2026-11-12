internal import Dispatch
public import Test
public import Testing

extension Test::Test.Apple {
    /// A time limit that ends the process.
    ///
    /// Swift Testing's own `.timeLimit` cancels the test's task, and a cancellation ends only what looks
    /// for it. A blocked thread, or a wait on a call that never comes back, goes on, and the run hangs
    /// without naming a test. A deadline is kept on a queue of its own: when it runs out it stops the
    /// process with a message that names the suite or test, so the run fails and the runner reports
    /// which tests had started.
    public struct Deadline: Testing.SuiteTrait, Testing.TestTrait, Sendable {
        /// The time the suite or test may take.
        public let limit: Swift.Duration

        public init(limit: Swift.Duration) {
            self.limit = limit
        }
    }
}

extension Test::Test.Apple.Deadline {
    /// Runs `body`, and stops the process if it has not ended within `limit`. `name` is what the
    /// message calls the work that ran out of time.
    @concurrent
    static func limited(
        _ name: Swift.String,
        to limit: Swift.Duration,
        _ body: @Sendable @concurrent () async throws -> Void
    ) async throws {
        let (seconds, attoseconds) = limit.components
        let nanoseconds = Int(clamping: seconds) &* 1_000_000_000 &+ Int(attoseconds / 1_000_000_000)
        let timer = DispatchSource.makeTimerSource(queue: .global())
        timer.setEventHandler {
            fatalError("\(name) did not end within \(limit): the process is stopped here, so the run fails and reports what had started")
        }
        timer.schedule(deadline: .now() + .nanoseconds(nanoseconds))
        timer.resume()
        defer { timer.cancel() }
        try await body()
    }
}

extension Test::Test.Apple.Deadline: Testing.TestScoping {
    @concurrent
    public func provideScope(
        for test: Testing.Test,
        testCase: Testing.Test.Case?,
        performing function: @Sendable @concurrent () async throws -> Void
    ) async throws {
        try await Self.limited(test.name, to: limit, function)
    }
}

extension Testing.Trait where Self == Test::Test.Apple.Deadline {
    /// Stops the process when the suite or test has not ended within `limit`.
    ///
    /// On a suite the limit is for the whole suite, once. On a test it is for each of its cases.
    public static func deadline(_ limit: Swift.Duration) -> Self {
        Test::Test.Apple.Deadline(limit: limit)
    }
}
