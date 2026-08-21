// This source file is part of the swift-test-apple open source project
// Copyright (c) 2024-2026 Coen ten Thije Boonkkamp and project authors
// Licensed under Apache License v2.0

public import Source_Primitives
public import Test
internal import struct Testing.Attachment
internal import struct Testing.Comment
internal import struct Testing.Issue
internal import struct Testing.SourceLocation
internal import func Testing.withKnownIssue

extension Test.Apple {
    /// Explicitly maps neutral issues and attachments into the current Apple test.
    public struct Recorder: Sendable {
        public let source: Source.Location

        public init(
            source: Source.Location = .init(
                fileID: #fileID,
                filePath: #filePath,
                line: #line,
                column: #column
            )
        ) {
            self.source = source
        }
    }
}

extension Test.Apple.Recorder {
    public var neutral: Test.Recorder {
        .init(
            issue: { issue in self.record(issue) },
            attachment: { attachment in self.record(attachment) }
        )
    }

    public func record(_ issue: Test.Issue) {
        let comment = Testing.Comment(rawValue: "\(issue.kind): \(issue.message.plain)")
        record(issue, comment: comment, source: Test.Apple.source(issue.source ?? source))
    }

    public func record(_ attachment: Test.Attachment) {
        Testing.Attachment<[UInt8]>.record(
            attachment.octets,
            named: attachment.name,
            sourceLocation: Test.Apple.source(source)
        )
    }

    private func record(
        _ issue: Test.Issue,
        comment: Testing.Comment,
        source: Testing.SourceLocation
    ) {
        if issue.isKnown {
            Testing.withKnownIssue(comment, sourceLocation: source) {
                Testing.Issue.record(comment, severity: .error, sourceLocation: source)
            }
        } else {
            Testing.Issue.record(comment, severity: .error, sourceLocation: source)
        }
    }
}
