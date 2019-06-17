//
//  ObjectIds.swift
//  ArtZen
//
//  Created by Kevin Jackson on 6/17/19.
//  Copyright © 2019 Kevin Jackson. All rights reserved.
//

import Foundation

class ObjectIds {
    
    weak var delegate: ObjectIdsDelegate?
    var todoIds: [Int]
    var doneIds: [Int]
    var percentage: Float {
        let total = Float(todoIds.count + doneIds.count)
        return total == 0 ? 0 : Float(doneIds.count) / total
    }
    
    func finishedWith(id: Int) {
        if let index = todoIds.firstIndex(of: id) {
            todoIds.remove(at: index)
            doneIds.append(id)
            delegate?.objectIdsDidUpdate()
        }
    }
    
    init(todoIds: [Int], doneIds: [Int]) {
        self.todoIds = todoIds
        self.doneIds = doneIds
    }
}

protocol ObjectIdsDelegate: AnyObject {
    func objectIdsDidUpdate()
}
