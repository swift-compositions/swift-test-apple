# Test Apple

[![CI](https://github.com/swift-foundations/swift-test-apple/actions/workflows/ci.yml/badge.svg)](https://github.com/swift-foundations/swift-test-apple/actions/workflows/ci.yml)

The Test × Apple Testing relation: source, issue, and attachment mapping plus a generic neutral-modifier trait for Apple tests and suites.

```swift
import Test_Apple
import Testing

@Test(Test.Apple.Trait(modifier))
func example() {
    // Test.Context.current is installed for this scope.
}
```

Apple’s toolchain `Testing` module remains the sole framework, macro, discovery, and runner authority. This package has no Snapshot, Benchmark, SwiftSyntax, Clock, Memory, File System, JSON, Console, reporter, Loader, C auto-installation, or mutable global handler dependency.

## License

Apache 2.0. See [LICENSE.md](LICENSE.md).
