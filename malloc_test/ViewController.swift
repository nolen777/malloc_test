//
//  ViewController.swift
//  malloc_test
//
//  Created by Dan Crosby on 3/9/18.
//  Copyright © 2018 Dan Crosby. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var mbField : UITextField?
    @IBOutlet var timeField : UITextField?
    @IBOutlet var dirtySwitch : UISwitch?
    @IBOutlet var lastRunText : UILabel?
    @IBOutlet var mbAllocatedField : UILabel?
    
    let PAGE_SIZE = 4096
    let LAST_RUN_MB_KEY = "lastRunMB"
    var currentMbAllocated = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let lastRunMb = UserDefaults.standard.integer(forKey: LAST_RUN_MB_KEY)
        
        lastRunText?.text = "Last run: \(lastRunMb)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func startButtonTapped(_ sender: UIButton) {
        sender.isEnabled = false
        
        guard let dirtyMemory = dirtySwitch?.isOn else {
            abort()
        }
        guard let mbString = mbField?.text, let allocMbSize = Int(mbString) else {
            abort()
        }
        guard let timeString = timeField?.text, let timeInterval = Double(timeString) else {
            abort()
        }
        
        let sizeInBytes = allocMbSize * 1024 * 1024
        
        let timer = Timer(timeInterval: timeInterval, repeats: true) { _ in
            let memoryBlock = malloc(sizeInBytes)!
            if dirtyMemory {
                for i in stride(from: 0, to: sizeInBytes, by: Int(self.PAGE_SIZE)) {
                    memoryBlock.storeBytes(of: i, toByteOffset: i, as: type(of: i))
                }
            }
            
            self.currentMbAllocated += allocMbSize
            UserDefaults.standard.set(self.currentMbAllocated, forKey: self.LAST_RUN_MB_KEY)
            self.mbAllocatedField?.text = "\(self.currentMbAllocated)"
        }
        
        RunLoop.current.add(timer, forMode: RunLoopMode.commonModes)
    }
}

