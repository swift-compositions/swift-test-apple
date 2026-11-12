import Dispatch
internal import Test
import Testing

@testable import Test_Apple

/// Blocks the thread for twenty seconds, which no cancellation shortens. It is not for ever, so that
/// a deadline that fails to stop the process fails its test instead of hanging the run.
func stall() {
    _ = DispatchSemaphore(value: 0).wait(timeout: .now() + .seconds(20))
}

#if os(macOS) || os(Linux) || os(Windows)
    extension Relation.Test {
        @Suite struct Deadline {
            @Test func `work that outlasts its deadline stops the process, although its thread is blocked`() async {
                await #expect(processExitsWith: .failure) {
                    try await NeutralTest.Apple.Deadline.limited("the stalled work", to: .milliseconds(200)) {
                        stall()
                    }
                }
            }

            @Test func `work that ends within its deadline leaves the process running, also once the deadline has passed`() async {
                await #expect(processExitsWith: .success) {
                    try await NeutralTest.Apple.Deadline.limited("the quick work", to: .milliseconds(200)) {}
                    try await Task.sleep(for: .milliseconds(600))
                }
            }

            @Test func `work that throws within its deadline throws what it threw, and the deadline is off`() async {
                await #expect(processExitsWith: .success) {
                    struct Stop: Swift.Error {}
                    do {
                        try await NeutralTest.Apple.Deadline.limited("the failing work", to: .milliseconds(200)) { throw Stop() }
                        fatalError("the work's error was swallowed")
                    } catch is Stop {
                        try await Task.sleep(for: .milliseconds(600))
                    }
                }
            }

            @Test(.deadline(.seconds(60))) func `a test under a deadline it keeps passes`() {
                #expect(Bool(true))
            }
        }
    }
#endif
