//
//  Collection.swift
//  MyHTML
//
//  Created by Trevör Anne Denise on 14/01/2019.
//

import CMyHTML

public class NodeCollection: Collection {
    
    var rawCollection: UnsafeMutablePointer<myhtml_collection>?
    var tree: Tree!
    
    init(rawCollection: UnsafeMutablePointer<myhtml_collection>, tree: Tree?) {
        self.rawCollection = rawCollection
        self.tree = tree
    }
    
    private init(raw: UnsafeMutablePointer<myhtml_collection>?, tree: Tree?) {
        self.rawCollection = raw
        self.tree = tree
    }
    
    static let empty = NodeCollection(raw: nil, tree: nil)
    
    deinit {
        assert(myhtml_collection_destroy(rawCollection) == nil, "Unsuccessful destroy")
    }
    
    public var count: Int {
        return rawCollection?.pointee.length ?? 0
    }
    
    public func index(after i: Int) -> Int {
        return i+1
    }
    
    public subscript(position: Int) -> Node {
        guard let raw = self.rawCollection,
            position >= startIndex && position < endIndex else {
                fatalError("Out of bound access")
        }
        return Node(rawNode: raw.pointee.list[position]!, tree: tree)
    }
    
    public var startIndex: Int = 0
    
    public var endIndex: Int {
        return rawCollection?.pointee.length ?? 0
    }
    
    
    
    public typealias Element = Node
    public typealias Index = Int
    
}
