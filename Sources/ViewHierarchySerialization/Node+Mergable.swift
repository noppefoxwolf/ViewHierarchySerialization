protocol Mergable {
    mutating func merge(with other: Self)
}

extension Mergable {
    func merged(with other: Self) -> Self {
        var copy = self
        copy.merge(with: other)
        return copy
    }
}

extension RootNode: Mergable {
    mutating func merge(with other: RootNode) {
        for otherChild in other.children {
            if let index = children.firstIndex(where: { $0.id == otherChild.id }) {
                children[index].merge(with: otherChild)
            } else {
                children.append(otherChild)
            }
        }
    }
}

extension HierarchyNode: Mergable {
    func merge(with other: HierarchyNode) {
        for otherChild in other.children {
            if let index = children.firstIndex(where: { $0.id == otherChild.id }) {
                children[index].merge(with: otherChild)
            } else {
                children.append(otherChild)
            }
        }
    }
}
