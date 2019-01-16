//
//  Node.swift
//  MyHTML
//
//  Created by Trevör Anne Denise on 14/01/2019.
//

import CMyHTML

class Node {
    var raw: OpaquePointer
    init(raw: OpaquePointer) {
        self.raw = raw
    }
    
    var textContent: String? {
        guard let rawText = myhtml_node_text(raw, nil) else {
            return nil
        }
        return String(cString: rawText)
    }
    
    var tagId: Int {
        return myhtml_node_tag_id(raw)
    }
    
    var children: NodeSequence {
        if let rawChild = myhtml_node_child(raw) {
            return NodeSequence(current: Node(raw: rawChild))
        } else {
            return NodeSequence(current: nil)
        }
    }
    
    // Convenience
    var textChildren: [Node] {
        return children.filter({ $0.tagId == MyHTML_TAG__TEXT.rawValue })
    }
    
    var parent: Node? {
        if let rawParent = myhtml_node_parent(raw) {
            return Node(raw: rawParent)
        } else {
            return nil
        }
    }
    
    
}
