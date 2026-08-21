// This source file is part of the swift-test-apple open source project
// Copyright (c) 2024-2026 Coen ten Thije Boonkkamp and project authors
// Licensed under Apache License v2.0

public import Source_Primitives
public import Test
public import struct Testing.SourceLocation

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
