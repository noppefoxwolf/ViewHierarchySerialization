public struct RootNode {
    public var children: [HierarchyNode]
}

public final class HierarchyNode: Identifiable {
    public var id: String
    public let name: String
    public let isPresented: Bool
    public var children: [HierarchyNode] = []
    
    init(id: String, name: String, isPresented: Bool) {
        self.id = id
        self.name = name
        self.isPresented = isPresented
    }
}

extension RootNode {
    public init(_ printHierarchy: PrintHierarchy) {
        var nodes: [Int : HierarchyNode] = [:]
        var rootNodes: [HierarchyNode] = []
        
        for line in printHierarchy.lines {
            let parentIndex = line.header.positions.count
            let id = "\(line.controller.name):\(line.controller.address)"
            let name = line.controller.name
            let isPresented = line.header.positions.last == .presented
            let node = HierarchyNode(id: id, name: name, isPresented: isPresented)
            nodes[parentIndex] = node
            
            if parentIndex == 0 {
                rootNodes.append(node)
            } else {
                if let parentNode = nodes[parentIndex - 1] {
                    parentNode.children.append(node)
                }
            }
        }
        self = RootNode(children: rootNodes)
    }
}


