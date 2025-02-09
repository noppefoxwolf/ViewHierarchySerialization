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
        
        #expect(hierarchyData.lines[0].header.positions.count == 0)
        #expect(hierarchyData.lines[0].controller.name == "DAWN.RootTabBarController")
        #expect(hierarchyData.lines[0].controller.address == "0x107846800")
        #expect(hierarchyData.lines[0].state == .appeared)
        #expect(hierarchyData.lines[0].view == .loaded("UILayoutContainerView", "0x10321deb0"))
        
        #expect(hierarchyData.lines[1].header.positions.count == 1)
        #expect(hierarchyData.lines[1].header.positions[0] == .child)
        #expect(hierarchyData.lines[1].controller.name == "DAWN.RootTabItemNavigationController")
        #expect(hierarchyData.lines[1].controller.address == "0x118016400")
        #expect(hierarchyData.lines[1].state == .appeared)
        #expect(hierarchyData.lines[1].view == .loaded("UILayoutContainerView", "0x103315050"))
        
        #expect(hierarchyData.lines[8].header.positions.count == 1)
        #expect(hierarchyData.lines[8].header.positions[0] == .presented)
        #expect(hierarchyData.lines[8].controller.name == "UINavigationController")
        #expect(hierarchyData.lines[8].controller.address == "0x10223c400")
        #expect(hierarchyData.lines[8].state == .appeared)
        #expect(hierarchyData.lines[8].view == .loaded("UILayoutContainerView", "0x101787320"))
    }
    
    @Test
    func decodeLine() async throws {
        let line = "   |    | <ComposeUI.ComposeEditorViewController 0x10785e600>, state: appeared, view: <ComposeUI.EditorView: 0x1017ac1d0>"
        let decoder = HierarchyDataDecoder()
        let hierarchy = try decoder.decode(line: line[...])
        #expect(hierarchy.header.positions.count == 2)
    }
    
    @Test
    func decodeHierarchy() async throws {
        let url = Bundle.module.url(forResource: "_printHierarchy", withExtension: "txt")!
        let data = try Data(contentsOf: url)
        let decoder = HierarchyDataDecoder()
        let hierarchyData = try decoder.decode(from: data)
        
        let rootNode = RootNode(hierarchyData)
        #expect(rootNode.children.count == 1)
        #expect(rootNode.children[0].name == "DAWN.RootTabBarController")
        #expect(rootNode.children[0].children.count == 3)
        #expect(rootNode.children[0].children[0].name == "DAWN.RootTabItemNavigationController")
        #expect(rootNode.children[0].children[0].children.count == 1)
        #expect(rootNode.children[0].children[0].children[0].name == "TimelineUI.TimelinePageViewController")
        
        #expect(rootNode.children[0].children[1].name == "DAWN.RootTabItemNavigationController")
        #expect(rootNode.children[0].children[2].name == "UINavigationController")
        
        print(rootNode.debugDescription)
    }
    
    @Test
    func decodeMerge() async throws {
        let url1 = Bundle.module.url(forResource: "_printHierarchy", withExtension: "txt")!
        let url2 = Bundle.module.url(forResource: "_printHierarchy-append", withExtension: "txt")!
        let data1 = try Data(contentsOf: url1)
        let data2 = try Data(contentsOf: url2)
        let decoder = HierarchyDataDecoder()
        let hierarchyData1 = try decoder.decode(from: data1)
        let hierarchyData2 = try decoder.decode(from: data2)
        
        let rootNode1 = RootNode(hierarchyData1)
        let rootNode2 = RootNode(hierarchyData2)
        let rootNode = rootNode1.merged(with: rootNode2)
        
        #expect(rootNode.children.count == 1)
        #expect(rootNode.children[0].name == "DAWN.RootTabBarController")
        #expect(rootNode.children[0].children.count == 3)
        #expect(rootNode.children[0].children[0].name == "DAWN.RootTabItemNavigationController")
        #expect(rootNode.children[0].children[0].children.count == 2)
        #expect(rootNode.children[0].children[0].children[0].name == "TimelineUI.TimelinePageViewController")
        #expect(rootNode.children[0].children[0].children[1].name == "TimelineUI.TimelinePageViewController2")
        
        #expect(rootNode.children[0].children[1].name == "DAWN.RootTabItemNavigationController")
        #expect(rootNode.children[0].children[2].name == "UINavigationController")
        
        print(rootNode)
    }
}

