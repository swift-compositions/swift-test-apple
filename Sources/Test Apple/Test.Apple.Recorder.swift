// This source file is part of the swift-test-apple open source project
// Copyright (c) 2024-2026 Coen ten Thije Boonkkamp and project authors
// Licensed under Apache License v2.0

internal import Byte
public import Source
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

        public init(source: Source.Location) {
            self.source = source
        }

        public init(
            fileID: Swift.String = #fileID,
            filePath: Swift.String = #filePath,
            line: Int = #line,
            column: Int = #column
        ) {
            self.init(source: Source.Location(fileID: fileID, filePath: filePath, line: line, column: column))
        }
    }
}

extension Test.Apple.Recorder {
    public func record(_ issue: Test.Issue) {
        let comment = comment(for: issue)
        let location = Test.Apple.source(issue.sourceLocation ?? source)
        if issue.isKnown {
            Testing.withKnownIssue(comment, sourceLocation: location) {
                Testing.Issue.record(comment, severity: .error, sourceLocation: location)
            }
        } else {
            Testing.Issue.record(comment, severity: .error, sourceLocation: location)
        }
    }

    public func record(_ attachment: Test.Attachment) {
        Testing.Attachment.record(self.attachment(for: attachment), sourceLocation: Test.Apple.source(source))
    }

    func comment(for issue: Test.Issue) -> Testing.Comment {
        Testing.Comment(rawValue: issue.context.map { "\(issue.kind): \($0.plainText)" } ?? "\(issue.kind)")
    }

    func attachment(for attachment: Test.Attachment) -> Testing.Attachment<[UInt8]> {
        Testing.Attachment(
            attachment.bytes.map(\.bitPattern),
            named: attachment.name,
            sourceLocation: Test.Apple.source(source)
        )
    }
}
