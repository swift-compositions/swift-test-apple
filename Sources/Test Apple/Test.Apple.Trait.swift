// This source file is part of the swift-test-apple open source project
// Copyright (c) 2024-2026 Coen ten Thije Boonkkamp and project authors
// Licensed under Apache License v2.0

public import Test
public import protocol Testing.SuiteTrait
public import protocol Testing.TestScoping
public import protocol Testing.TestTrait
public import struct Testing.Test

extension _NeutralTest.Apple {
    /// Adapts one neutral modifier to Apple suite and test scoping.
    public struct Trait<M: _NeutralTest.Modifier>: Sendable {
        public let modifier: M
        public let context: _NeutralTest.Context

        public init(_ modifier: M, context: _NeutralTest.Context) {
            self.modifier = modifier
            self.context = context
        }

        public init(_ modifier: M, recorder: Recorder = .init()) {
            self.init(modifier, context: .init(source: recorder.source, recorder: recorder.neutral))
        }
    }
}

extension _NeutralTest.Apple.Trait: Testing.SuiteTrait, Testing.TestTrait {
    public var isRecursive: Bool { modifier.inheritance == .recursive }
}

extension _NeutralTest.Apple.Trait: Testing.TestScoping {
    @concurrent
    public func provideScope(
        for test: Testing.Test,
        testCase: Testing.Test.Case?,
        performing function: @Sendable @concurrent () async throws -> Void
    ) async throws {
        try await context.with(isolation: #isolation) {
            try await modifier.scope(
                in: context,
                isolation: #isolation,
                operation: { try await function() }
            )
        }
    }
}
