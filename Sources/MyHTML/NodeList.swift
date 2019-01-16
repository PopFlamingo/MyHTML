import CMyHTML

struct NodeSequence: Sequence, IteratorProtocol {
    var current: Node?
    
    init(current: Node?) {
        self.current = current
    }
    
    typealias Element = Node
    typealias Iterator = NodeSequence
    mutating func next() -> Node? {
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
