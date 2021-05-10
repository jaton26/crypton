//
//  DataList.swift
//  crypton
//
//  Created by Jason Chong on 4/7/21.
//

import Foundation

class Node {
    var value: [APIFormat]
    var isSaved: Bool?
    var next: Node?
    weak var previous: Node?
    
    init(_ value: [APIFormat]) {
        self.value = value
    }
}

class DataList {
    var head: Node?
    var tail: Node?
    
    func append(_ value: [APIFormat]) {
        let newNode = Node(value)
        if let tailNode = tail {
            tailNode.next = newNode
            newNode.previous = tailNode
        }
        else {
            head = newNode
        }
        
        tail = newNode
    }
    
    func remove(_ name: String) {
        var node = head
        
        if getLength() == 1 {
            if head!.value[0].id == name {
                head = nil
                tail = nil
            }
        }
        
        else if getLength() == 2 {
            if head!.value[0].id == name{
                head!.next = nil
                tail!.previous = nil
                
                head = tail
            }
            
            else if tail!.value[0].id == name{
                tail!.previous = nil
                head!.next = nil
                tail = head
            }
        }
        
        
        else {
            while(node != nil){
                if node!.value[0].id == name {
                    if node!.value[0].id == head!.value[0].id {
                        node = node!.next
                        node!.previous = nil
                        head!.next = nil
                        head = node
                    }
                    
                    else if node!.value[0].id == tail!.value[0].id{
                        node = node!.previous
                        node!.next = nil
                        tail!.previous = nil
                        tail = node
                    }
                    
                    else{
                        node!.previous!.next = node!.next
                        node!.next!.previous = node!.previous
                        
                        node!.next = nil
                        node!.previous = nil
                    }
                }
                
                node = node!.next
                
            }
        }

    }
    
    func getData(_ data: [APIFormat]) -> [APIFormat]? {
        var node = head
        while(node != nil){
            if node!.value[0].id == data[0].id {
                return node!.value
            }
            node = node!.next
        }
        return nil
    }
    
    func printList() {
        var node = head
        while(node != nil) {
            print(node!.value)
            node = node!.next
        }
    }
    
    func isEmpty() -> Bool {
        if (head == nil) {
            print("true")
            return true
        }
        else {
            print("false")
            return false
        }
    }
        
    func getLength() -> Int {
        var node = head
        var count = 0
        while(node != nil) {
            count += 1
            node = node!.next
        }
        return count
    }
}
