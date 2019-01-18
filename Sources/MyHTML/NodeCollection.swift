//
//  Collection.swift
//  MyHTML
//
//  Created by Trevör Anne Denise on 14/01/2019.
//

import CMyHTML

public class NodeCollection: Collection {
    
    var raw: UnsafeMutablePointer<myhtml_collection>?
    
    init(raw: UnsafeMutablePointer<myhtml_collection>) {
        self.raw = raw
    }
    
    private init(raw: UnsafeMutablePointer<myhtml_collection>?) {
        self.raw = raw
    }
    
    static let empty = NodeCollection(raw: nil)
    
    deinit {
        myhtml_collection_destroy(raw)
    }
    
    public var count: Int {
        return raw?.pointee.length ?? 0
    }
    
    public func index(after i: Int) -> Int {
        return i+1
    }
    
    public subscript(position: Int) -> Node {
        guard let raw = self.raw,
            position >= startIndex && position < endIndex else {
            fatalError("Out of bound access")
        }
        return Node(raw: raw.pointee.list[position]!)
    }
    
    public var startIndex: Int = 0
    
    public var endIndex: Int {
        return raw?.pointee.length ?? 0
    }
    
    
    
    public typealias Element = Node
    public typealias Index = Int
    
}
