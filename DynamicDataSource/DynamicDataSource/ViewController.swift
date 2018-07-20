//
//  ViewController.swift
//  DynamicDataSource
//
//  Created by L on 2018/7/19.
//  Copyright © 2018年 L. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        navigationController?.pushViewController(C(), animated: true)
    }

}

