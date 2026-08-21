import Test
import Test_Apple

typealias NeutralTest = Test

enum Probe {}

extension Probe {
    struct Modifier: NeutralTest.Modifier {
        let inheritance: NeutralTest.Scope.Inheritance

        init(inheritance: NeutralTest.Scope.Inheritance = .recursive) {
            self.inheritance = inheritance
        }
    }
}

extension Probe.Modifier {
    func apply<R: ~Copyable, E: Swift.Error>(
        in context: NeutralTest.Context,
        isolation: isolated (any Actor)?,
        operation: @isolated(any) () async throws(E) -> sending R
    ) async throws(E) -> sending R {
        try await operation()
    }
}
