//
//  M.swift
//  DynamicDataSource
//
//  Created by L on 2018/7/19.
//  Copyright © 2018年 L. All rights reserved.
//

import Foundation

enum Status {
    case growing
    case failed
    case successed
    case ready
    case canceled
    case suspended
}

enum Result<T, Error> {
    case successed(T)
    case failed(Error)
}

protocol MStatusDidChangeDelegate: class {
    func m(_ m: M, progressDidChange progress: Float)
    func m(_ m: M, finishWithResult result: Result<Any, Any>)
}

class M: NSObject {
    
    var progress: Float = 0.0
    
    var status = Status.ready {
        didSet {
            if status == .failed {
                progress = 0
            } else if status == .successed {
                progress = 20
            }
        }
    }
    
    weak var delegate: MStatusDidChangeDelegate?
    
    let growthLevel = NSNumber(value: arc4random()%10 + 1).floatValue
    
    private lazy var timer: Timer = {
        let time = Timer(timeInterval: 0.5, target: self, selector: #selector(progressDidChange), userInfo: nil, repeats: true)
        return time
    }()
    
    func start() {
        if status == .ready {
            RunLoop.main.add(timer, forMode: .commonModes)
        } 
        status = .growing
    }
    
    func cancel() {
        timer.invalidate()
        status = .canceled
    }

    deinit {
        print("M deinit")
    }
    
}

@objc private extension M {
    
    func progressDidChange() {
        
        progress += (growthLevel/100)
        
        if progress >= 20 {
            timer.invalidate()
            delegate?.m(self, finishWithResult: .successed("Finish"))
            status = .successed
        }
        
        if growthLevel == 4 && progress > 10 {
            timer.invalidate()
            delegate?.m(self, finishWithResult: .failed("error reason"))
            status = .failed
        }
        
        delegate?.m(self, progressDidChange: progress)
        
    }
    
}


