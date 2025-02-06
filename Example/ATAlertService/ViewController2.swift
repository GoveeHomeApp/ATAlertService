//
//  ViewController2.swift
//  ATAlertService_Example
//
//  Created by abiaoyo on 2025/2/6.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

import UIKit
import ATAlertService

class ViewController2: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    let alertService = ATAlertService()
    
    @IBAction func combina(_ sender: Any) {
        let inView:UIView = view
        let operate2 = ATAlertOperate.create(opKey: "test2", title:"测试22", text: "弹框测试22", combined: .cover) { operate in
            let alert = CustomAlert.show(inView:inView, title: operate.title, msg: operate.text) { [weak operate] in
                operate?.finished()
            } cancelBlock: { [weak operate] in
                operate?.finished()
            }
            return alert
        }
        alertService.append(operate: operate2, frequency: .every)
        alertService.show()
    }
    
    @IBAction func showAndHidden(_ sender: Any) {
        let inView:UIView = view
        let operate = ATAlertOperate.create(opKey: "test1", title:"测试1", text: "", combined: .single) { operate in
            return CustomAlert.show(inView:inView, title: "测试1", msg: "弹框测试1") { [weak operate] in
                operate?.finished()
            } cancelBlock: { [weak operate] in
                operate?.finished()
            }
        }
        alertService.append(operate: operate, priority: .low, frequency: .once)
        
        let operate2 = ATAlertOperate.create(opKey: "test2", title:"测试2", text: "弹框测试2", combined: .merged) { operate in
            let alert = CustomAlert.show(inView:inView, title: operate.title, msg: operate.text) { [weak operate] in
                operate?.finished()
            } cancelBlock: { [weak operate] in
                operate?.finished()
            }
            operate.updateAlertBlock = { [weak alert] operate in
                alert?.update(title: operate.title)
                alert?.update(message: operate.text)
            }
            return alert
        }
        alertService.append(operate: operate2, frequency: .every)
        
        let operate3 = ATAlertOperate.create(opKey: "test3",title:"测试3", text: "", combined: .single) { operate in
            return CustomAlert.show(inView:UIApplication.shared.keyWindow!, title: "测试3", msg: "弹框测试3") { [weak operate] in
                operate?.finished()
            } cancelBlock: { [weak operate] in
                operate?.finished()
            }
        }
        alertService.append(operate: operate3, priority: .low, frequency: .once)
        
        alertService.show()
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
