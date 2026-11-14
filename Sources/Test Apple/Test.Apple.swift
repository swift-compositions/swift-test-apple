internal import Cardinal
public import Source
internal import Tagged
public import Test
internal import Text

public import struct Testing.Issue
public import struct Testing.SourceLocation

extension Test {
    public enum Apple {}
}

extension Test.Apple {
    public static func source(_ source: Source.Location) -> Testing.SourceLocation {
        .init(
            fileID: source.fileID,
            filePath: source.filePath ?? source.fileID,
            line: Int(source.line.underlying),
            // swift-linter:disable:next raw value access
            // REASON: Apple Testing.SourceLocation requires Int coordinates; this is the external typed-conversion boundary.
            column: Int(source.column.underlying.rawValue)
        )
    }
}

extension Test.Apple {
    public static func severity(_ severity: Test.Issue.Severity) -> Testing.Issue.Severity {
        switch severity {
        case .warning: .warning
        case .error: .error
        }
    }
}
