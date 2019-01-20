import CMyHTML

public struct NodeSequence: Sequence, IteratorProtocol {
    
    init(current: Node?) {
        self.current = current
    }
    
    var current: Node?
    
    public typealias Element = Node
    public typealias Iterator = NodeSequence
    public mutating func next() -> Node? {
        if let current = current {
            defer {
                if let rawNext = myhtml_node_next(current.rawNode) {
                    self.current = Node(rawNode: rawNext)
                } else {
                    self.current = nil
                }
            }
            return current
        } else {
            return nil
        }
    }
}
