//
//  AG_ListenerBox.swift
//  AGWheel
//
//  Created by Anthony on 2022/3/23.
//


public struct ListenerBox<T> {
    public typealias ValueChangeBlock = (T) -> Void
    public var value: T {
        didSet {
            listenerBlocks?.forEach { block in
                block(value)
            }
        }
    }

    init(_ value: T) {
        self.value = value
    }

    public mutating func addLister(_ block: @escaping ValueChangeBlock) {
        if listenerBlocks == nil {
            listenerBlocks = [ValueChangeBlock]()
        }
        listenerBlocks!.append(block)
    }

    private var listenerBlocks: [ValueChangeBlock]?
}
