internal import Cardinal
public import Source
internal import Tagged
public import Test
public import struct Testing.SourceLocation
internal import Text

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
