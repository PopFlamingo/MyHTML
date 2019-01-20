//
//  Collection.swift
//  MyHTML
//
//  Created by Trevör Anne Denise on 14/01/2019.
//

import CMyHTML

public class NodeCollection: Collection {
    
    var rawCollection: UnsafeMutablePointer<myhtml_collection>?
    
    init(rawCollection: UnsafeMutablePointer<myhtml_collection>) {
        self.rawCollection = rawCollection
    }
    
    private init(raw: UnsafeMutablePointer<myhtml_collection>?) {
        self.rawCollection = raw
    }
    
    static let empty = NodeCollection(raw: nil)
    
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
        return Node(rawNode: raw.pointee.list[position]!)
    }
    
    public var startIndex: Int = 0
    
    public var endIndex: Int {
        return rawCollection?.pointee.length ?? 0
    }
    
    
    
    public typealias Element = Node
    public typealias Index = Int
    
}
