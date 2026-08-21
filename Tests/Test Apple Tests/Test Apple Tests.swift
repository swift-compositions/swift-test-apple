import Source_Primitives
internal import Test
import Test_Apple
import Testing

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

            @Test func `known neutral issues map to known Apple issues`() {
                let recorder = NeutralTest.Apple.Recorder().neutral
                recorder(.init(kind: .system, message: "expected adapter probe", isKnown: true))
            }

            @Test func `neutral attachments map to Apple attachments`() {
                let recorder = NeutralTest.Apple.Recorder().neutral
                recorder.record(.init(name: "probe.txt", text: "attachment probe"))
            }
        }

        @Suite struct `Edge Case` {
            @Test func `local modifiers produce a nonrecursive Apple trait`() {
                let trait = NeutralTest.Apple.Trait(Probe.Modifier(inheritance: .local))
                #expect(!trait.isRecursive)
            }
        }

        @Suite struct Integration {
            @Test(NeutralTest.Apple.Trait(Probe.Modifier()))
            func `generic trait installs neutral context`() {
                #expect(NeutralTest.Context.current != nil)
            }
        }
    }
}
