# Test Apple

[![CI](https://github.com/swift-foundations/swift-test-apple/actions/workflows/ci.yml/badge.svg)](https://github.com/swift-foundations/swift-test-apple/actions/workflows/ci.yml)

The Test × Apple Testing relation: source, issue, and attachment mapping into the current Apple test.

```swift
import Test_Apple
import Testing

@Test func example() {
    let recorder = Test.Apple.Recorder()
    recorder.record(Test.Issue(kind: .system("unexpected state"), context: "while loading"))
    recorder.record(Test.Attachment(name: "state.txt", string: "loaded"))
}
```

An issue is recorded at its own `sourceLocation`, or at the recorder's source when it has none; its comment is the issue kind, followed by the context text when present. Known issues are recorded inside `withKnownIssue`. Attachments keep their name and exact bytes; the content type is not carried, because Apple's byte-array attachment has no content-type field.

Compatibility: `Test.Apple.Trait` (the generic neutral-modifier suite/test trait) and `Test.Apple.Recorder.neutral` were removed, because the neutral `Test.Modifier`, `Test.Context` and `Test.Recorder` they adapted no longer exist. The adapter no longer installs a neutral context or applies a neutral modifier scope; there is no drop-in successor.

Apple’s toolchain `Testing` module remains the sole framework, macro, discovery, and runner authority. This package has no Snapshot, Benchmark, SwiftSyntax, Clock, Memory, File System, JSON, Console, reporter, Loader, C auto-installation, or mutable global handler dependency.

## License

Apache 2.0. See [LICENSE.md](LICENSE.md).
