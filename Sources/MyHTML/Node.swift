//
//  Node.swift
//  MyHTML
//
//  Created by Trevör Anne Denise on 14/01/2019.
//

import CMyHTML

public class Node {
    var raw: OpaquePointer
    init(raw: OpaquePointer) {
        self.raw = raw
    }
    
    public var textContent: String? {
        guard let rawText = myhtml_node_text(raw, nil) else {
            return nil
        }
        return String(cString: rawText)
    }
    
    public var tagId: Int {
        return myhtml_node_tag_id(raw)
    }
    
    public var children: Array<Node> {
        if let rawChild = myhtml_node_child(raw) {
            return Array(NodeSequence(current: Node(raw: rawChild)))
        } else {
            return []
        }
    }
    
    public var childrenSequence: NodeSequence {
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
    
    var namespace: myhtml_namespace_t {
        return myhtml_node_namespace(raw)
    }
    
    var id: Int {
        return myhtml_node_tag_id(raw)
    }
    
    func isSameNode(as other: Node) -> Bool {
        return self.raw == other.raw
    }
    
    func valueOf(attribute: String) -> String? {
        return attribute.withCString { cStr -> (String?) in
            guard let attr = myhtml_attribute_by_key(raw, cStr, attribute.utf8.count) else { return nil }
            guard let rawStr = myhtml_attribute_value(attr, nil) else { return nil }
            return String(cString: rawStr)
        }
    }
    
}
