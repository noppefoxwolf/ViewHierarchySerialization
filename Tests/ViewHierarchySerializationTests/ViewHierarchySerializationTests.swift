import Testing
import Foundation
@testable import ViewHierarchySerialization
import RegexBuilder

@Suite
struct ViewHierarchySerializationTests {
    @Test
    func decodeLines() async throws {
        let url = Bundle.module.url(forResource: "_printHierarchy", withExtension: "txt")!
        let data = try Data(contentsOf: url)
        let decoder = HierarchyDataDecoder()
        let hierarchyData = try decoder.decode(from: data)
        
        #expect(hierarchyData.hierarchies[0].header.positions.count == 0)
        #expect(hierarchyData.hierarchies[0].controller.name == "DAWN.RootTabBarController")
        #expect(hierarchyData.hierarchies[0].controller.address == "0x107846800")
        #expect(hierarchyData.hierarchies[0].state == .appeared)
        #expect(hierarchyData.hierarchies[0].view == .loaded("UILayoutContainerView", "0x10321deb0"))
        
        #expect(hierarchyData.hierarchies[1].header.positions.count == 1)
        #expect(hierarchyData.hierarchies[1].header.positions[0] == .child)
        #expect(hierarchyData.hierarchies[1].controller.name == "DAWN.RootTabItemNavigationController")
        #expect(hierarchyData.hierarchies[1].controller.address == "0x118016400")
        #expect(hierarchyData.hierarchies[1].state == .appeared)
        #expect(hierarchyData.hierarchies[1].view == .loaded("UILayoutContainerView", "0x103315050"))
        
        #expect(hierarchyData.hierarchies[8].header.positions.count == 1)
        #expect(hierarchyData.hierarchies[8].header.positions[0] == .presented)
        #expect(hierarchyData.hierarchies[8].controller.name == "UINavigationController")
        #expect(hierarchyData.hierarchies[8].controller.address == "0x10223c400")
        #expect(hierarchyData.hierarchies[8].state == .appeared)
        #expect(hierarchyData.hierarchies[8].view == .loaded("UILayoutContainerView", "0x101787320"))
    }
    
    @Test
    func decodeLine() async throws {
        let line = "   |    | <ComposeUI.ComposeEditorViewController 0x10785e600>, state: appeared, view: <ComposeUI.EditorView: 0x1017ac1d0>"
        let decoder = HierarchyDataDecoder()
        let hierarchy = try decoder.decode(line: line[...])
        #expect(hierarchy.header.positions.count == 2)
    }
}

