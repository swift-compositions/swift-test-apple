# swift-test-apple

Use this package when code that reports through the runner-neutral vocabulary of swift-test has to show up as issues and attachments in Apple's Swift Testing. Start from `Test.Apple.Recorder`, and from `Test.Apple.source(_:)` if you only need to turn a `Source.Location` into a `Testing.SourceLocation`. Apple's `Testing` stays the framework that discovers and runs tests. If you want the neutral types without Apple's runner, use swift-test.

## Laws

- `Test.Apple.Recorder.record(_:)` records into whichever Apple test is running. A `Test.Issue` is placed at its own `sourceLocation`, or at the recorder's `source` when it has none.
- A recorder made without an explicit source takes the file, line and column of the place where it was created.
- The comment of a recorded issue is the issue's kind. When the issue has `context`, the comment is the kind, a colon and a space, and then the context as plain text.
- Every issue is recorded with error severity. An issue with `isKnown` set is recorded inside `withKnownIssue`, so it is reported as a known issue and doesn't fail the test.
- A `Test.Attachment` keeps its name and its exact bytes and is recorded at the recorder's `source`. Its content type is dropped, because Apple's byte-array attachment has nowhere to put it.
- `Test.Apple.source(_:)` keeps every coordinate. A `Source.Location` with no `filePath` uses its `fileID` as the file path.
- A `Test.Apple.Deadline`, written `.deadline(_:)` on a suite or a test, stops the process when the work has not ended within its limit, with a message that names the suite or test. It does so although the work's thread is blocked or waits on a call that never returns, which Swift Testing's own `.timeLimit` cannot end, because that only cancels the task. The run then fails and reports which tests had started.
- On a suite the limit is for the whole suite, once. On a test it is for each of its cases. Work that ends or throws within its limit is left alone, and its deadline is off from then on.
