import CMyHTML

public struct NodeSequence: Sequence, IteratorProtocol {
    var current: Node?
    
    init(current: Node?) {
        self.current = current
    }
    
    public typealias Element = Node
    public typealias Iterator = NodeSequence
    public mutating func next() -> Node? {
        if let current = current {
            defer {
                if let rawNext = myhtml_node_next(current.raw) {
                    self.current = Node(raw: rawNext)
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
