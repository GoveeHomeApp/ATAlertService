//
//  ATAlertService.swift
//  ATAlertService
//
//  Created by abiaoyo on 2024/12/13.
//

import Foundation


/// 优先级
@objc
public enum ATAlertPriority: Int {
    case low
    case middle
    case high
}

/// 频次
@objc
public enum ATAlertFrequency: Int {
    case `default`
    case once
    case every
}

/// 组合
@objc
public enum ATAlertCombined: Int {
    case single
    case cover
    case merged
}

/// 操作
@objcMembers
public class ATAlertOperate: NSObject {
    fileprivate private(set) var combined:ATAlertCombined = .single
    fileprivate private(set) var frequency:ATAlertFrequency = .default
    fileprivate private(set) var opKey:String = ""
    public private(set) var title:String = ""
    public private(set) var text:String = ""
    private(set) var createAlertBlock:((_ operate:ATAlertOperate) -> UIView)?
    public var updateAlertBlock:((_ operate:ATAlertOperate) -> Void)?
    
    fileprivate weak var alertView:UIView?
    fileprivate weak var service:ATAlertService?
    fileprivate var separator:String = " "
    
    private override init() {}
    
    public static func create(opKey: String, title: String, text: String, combined:ATAlertCombined, separator:String = " ", createAlertBlock: (@escaping (_ operate:ATAlertOperate) -> UIView)) -> ATAlertOperate {
        let obj = ATAlertOperate()
        obj.opKey = opKey
        obj.title = title
        obj.text = text
        obj.combined = combined
        obj.separator = separator
        obj.createAlertBlock = createAlertBlock
        return obj
    }
    
    fileprivate func modify(frequency:ATAlertFrequency) {
        self.frequency = frequency
    }
    
    fileprivate func covered(other:ATAlertOperate) {
        self.title = other.title
        self.text = other.text
    }
    
    fileprivate func merged(other:ATAlertOperate) {
        self.title += other.separator + other.title
        self.text += other.separator + other.text
    }
    
    fileprivate func show() {
        self.alertView = createAlertBlock?(self)
    }
    fileprivate func update() {
        updateAlertBlock?(self)
    }
    fileprivate func remove() {
        createAlertBlock = nil
        updateAlertBlock = nil
        alertView?.removeFromSuperview()
    }
    public func finished() {
        createAlertBlock = nil
        updateAlertBlock = nil
        service?.finished(operate: self)
    }
}

/// 队列
class ATAlertQueue {
    private lazy var operates:[ATAlertOperate] = []
    fileprivate var isEmpty:Bool {
        operates.isEmpty
    }
    fileprivate func append(operate:ATAlertOperate) {
        operates.append(operate)
    }
    fileprivate func popFirst() -> ATAlertOperate? {
        
        guard let first = operates.first else { return nil }

        let firstObjId = ObjectIdentifier(first)

        switch first.combined {
        case .single:
            operates.removeAll(where: { ObjectIdentifier($0) == firstObjId })
            return first
        case .cover:
            let filters = operates.filter({ $0.opKey == first.opKey })
            if let last = filters.last {
                operates.removeAll(where: { $0.opKey == first.opKey })
                return last
            }
            operates.removeAll(where: { $0.opKey == first.opKey })
            return first
        case .merged:
            operates.removeAll(where: { ObjectIdentifier($0) == firstObjId })
            let filters = operates.filter({ $0.opKey == first.opKey })
            for filter in filters {
                first.merged(other: filter)
            }
            operates.removeAll(where: { $0.opKey == first.opKey })
            return first
        }
    }
    fileprivate func remove(opKey:String) {
        operates.removeAll(where: { $0.opKey == opKey })
    }
    fileprivate func removeAll() {
        operates.removeAll()
    }
    fileprivate func find(opKey:String) -> ATAlertOperate? {
        operates.first(where: { $0.opKey == opKey })
    }
}

/// 服务
@objcMembers
public class ATAlertService:NSObject {
    public override init() {}
    
    private let container:[ATAlertPriority:ATAlertQueue] = [.high:ATAlertQueue(),.middle:ATAlertQueue(),.low:ATAlertQueue()]
    private var onceKeys:[String:String] = [:]
    private var curOperate:ATAlertOperate?
    
    private var lock = NSLock()
    
    deinit {
        lock.lock()
        curOperate?.remove()
        curOperate = nil
        lock.unlock()
    }
    
    public func append(operate:ATAlertOperate, priority:ATAlertPriority = .middle, frequency:ATAlertFrequency = .default) {
        operate.modify(frequency: frequency)
        
        lock.lock()
        defer {
            lock.unlock()
        }
        let queue = container[priority]!
        
        switch operate.frequency {
        case .once:
            if onceKeys[operate.opKey] != nil {
                return
            }
            if queue.find(opKey: operate.opKey) != nil {
                return
            }
        case .default:
            if queue.find(opKey: operate.opKey) != nil {
                return
            }
        case .every:
            break
        }
        if let curOperate = curOperate, curOperate.opKey == operate.opKey, curOperate.combined == operate.combined {
            switch operate.combined {
            case .cover:
                curOperate.covered(other: operate)
                curOperate.update()
                return
            case .merged:
                curOperate.merged(other: operate)
                curOperate.update()
                return
            default:
                break
            }
        }
        operate.service = self
        queue.append(operate: operate)
    }
    public func show() {
        lock.lock()
        defer {
            lock.unlock()
        }
        if curOperate != nil {
            return
        }
        let hightQueue = container[.high]
        let middleQueue = container[.middle]
        let lowQueue = container[.low]
        if let first = hightQueue?.popFirst() {
            curOperate = first
            curOperate?.show()
        }else if let first = middleQueue?.popFirst() {
            curOperate = first
            curOperate?.show()
        }else if let first = lowQueue?.popFirst() {
            curOperate = first
            curOperate?.show()
        }else {
            //..
        }
    }
    public func clearAll() {
        lock.lock()
        defer {
            lock.unlock()
        }
        curOperate?.remove()
        curOperate = nil
        container.values.forEach { queue in
            queue.removeAll()
        }
    }
    public func clear(opKey:String) {
        lock.lock()
        defer {
            lock.unlock()
        }
        if curOperate?.opKey == opKey {
            curOperate?.remove()
            curOperate = nil
        }
        container.values.forEach { queue in
            queue.remove(opKey: opKey)
        }
    }
    fileprivate func finished(operate: ATAlertOperate) {
        lock.lock()
        if curOperate?.opKey == operate.opKey {
            curOperate?.remove()
            curOperate = nil
        }
        switch operate.frequency {
        case .once:
            onceKeys[operate.opKey] = operate.opKey
            container.values.forEach { queue in
                queue.remove(opKey: operate.opKey)
            }
        case .default:
            container.values.forEach { queue in
                queue.remove(opKey: operate.opKey)
            }
        case .every:
            break
        }
        lock.unlock()
        show()
    }
}
