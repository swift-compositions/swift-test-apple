import Source
internal import Test
@testable import Test_Apple
import Testing

typealias NeutralTest = Test::Test

enum Relation {}

extension Relation {
    @Suite struct Test {
        @Suite struct Unit {
            @Test func `source locations map without losing coordinates`() {
                let source = Source.Location(fileID: "Module/File.swift", filePath: "/tmp/File.swift", line: 17, column: 9)
                let apple = NeutralTest.Apple.source(source)
                #expect(apple.fileID == source.fileID)
                #expect(apple.filePath == source.filePath)
                #expect(apple.line == 17)
                #expect(apple.column == 9)
            }

            @Test func `an issue with its own source and context records both on the current Apple test`() {
                let recorder = NeutralTest.Apple.Recorder()
                let kind = NeutralTest.Issue.Kind.system("adapter probe")
                let expected = "\(kind): expected adapter context"
                withKnownIssue {
                    recorder.record(
                        NeutralTest.Issue(
                            kind: kind,
                            sourceLocation: Source.Location(fileID: "Probe/Issue.swift", filePath: "/tmp/Issue.swift", line: 23, column: 5),
                            context: "expected adapter context"
                        )
                    )
                } matching: { issue in
                    issue.comments.map(\.rawValue) == [expected]
                        && issue.sourceLocation?.fileID == "Probe/Issue.swift"
                        && issue.sourceLocation?.filePath == "/tmp/Issue.swift"
                        && issue.sourceLocation?.line == 23
                        && issue.sourceLocation?.column == 5
                }
            }

            @Test func `an issue without source or context falls back to the recorder source and the bare kind`() {
                let recorder = NeutralTest.Apple.Recorder(
                    source: Source.Location(fileID: "Probe/Fallback.swift", filePath: "/tmp/Fallback.swift", line: 41, column: 3)
                )
                let kind = NeutralTest.Issue.Kind.apiMisused("fallback probe")
                let expected = "\(kind)"
                withKnownIssue {
                    recorder.record(NeutralTest.Issue(kind: kind))
                } matching: { issue in
                    issue.comments.map(\.rawValue) == [expected]
                        && issue.sourceLocation?.fileID == "Probe/Fallback.swift"
                        && issue.sourceLocation?.line == 41
                        && issue.sourceLocation?.column == 3
                }
            }

            @Test func `two direct recorder constructions fall back to their own call sites`() {
                let (first, firstLine) = (NeutralTest.Apple.Recorder(), #line)
                let (secondLine, second) = (#line, NeutralTest.Apple.Recorder())
                let sites = [(first, firstLine, 69), (second, secondLine, 78)]
                for (recorder, line, column) in sites {
                    let apple = NeutralTest.Apple.source(recorder.source)
                    #expect(apple.fileID == #fileID)
                    #expect(apple.filePath == #filePath)
                    #expect(apple.line == line)
                    #expect(apple.column == column)
                }
                for (recorder, line, column) in sites {
                    withKnownIssue {
                        recorder.record(NeutralTest.Issue(kind: .system("call-site probe")))
                    } matching: { issue in
                        issue.sourceLocation?.fileID == #fileID
                            && issue.sourceLocation?.line == line
                            && issue.sourceLocation?.column == column
                    }
                }
            }

            @Test func `a known neutral issue is recorded as a known Apple issue`() {
                NeutralTest.Apple.Recorder().record(
                    NeutralTest.Issue(kind: .system("expected known adapter probe"), isKnown: true)
                )
            }

            @Test func `a neutral attachment keeps its name and exact bytes`() {
                let recorder = NeutralTest.Apple.Recorder()
                let neutral = NeutralTest.Attachment(name: "probe.txt", string: "h\u{E9}llo \u{FF}\u{0}")
                let apple = recorder.attachment(for: neutral)
                #expect(apple.preferredName == "probe.txt")
                #expect(apple.attachableValue == Array("h\u{E9}llo \u{FF}\u{0}".utf8))
                #expect(apple.attachableValue.count == neutral.bytes.count)
                recorder.record(neutral)
            }
        }
    }
}
