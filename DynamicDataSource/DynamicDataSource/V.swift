//
//  V.swift
//  DynamicDataSource
//
//  Created by L on 2018/7/19.
//  Copyright © 2018年 L. All rights reserved.
//

import UIKit

class V: UITableViewCell {
    
    var m: M? {
        didSet {
            guard let model = m else { return }
            textLabel?.text = "Level~~\(model.growthLevel) progress~~\(model.progress)"
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("V deinit")
    }
    
}
