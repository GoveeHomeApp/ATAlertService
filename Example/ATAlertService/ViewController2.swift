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
    
    @IBAction func clickOnce(_ sender: Any) {
        let inView:UIView = view
        let operate = ATAlertOperate.create(opKey: "test1", title:"测试标题11", text: "测试内容11", combined: .single) { operate in
            let alert = CustomAlert.show(inView:inView, title: operate.title, msg: operate.text) { [weak operate] in
                operate?.finished()
            } cancelBlock: { [weak operate] in
                operate?.finished()
            }
            return alert
        }
        alertService.append(operate: operate, priority: .low, frequency: .once)
        alertService.show()
    }
    @IBAction func clickCover(_ sender: Any) {
        let operate3 = ATAlertOperate.create(opKey: "test3",title:"测试标题33", text: "测试标题33", data: 3, combined: .cover) { operate in
            let alert = CustomAlert.show(inView:UIApplication.shared.keyWindow!, title: operate.title, msg: operate.text) { [weak operate] in
                operate?.finished()
            } cancelBlock: { [weak operate] in
                operate?.finished()
            }
            return alert
        }
        alertService.append(operate: operate3, priority: .low, frequency: .every)
        alertService.show()
    }
    @IBAction func clickMerge(_ sender: Any) {
        let inView:UIView = view
        let operate2 = ATAlertOperate.create(opKey: "test2", title:"测试22", text: "弹框测试22", data: 2, combined: .merged) { operate in
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
    
    @IBAction func show(_ sender: Any) {
        let inView:UIView = view
        let operate = ATAlertOperate.create(opKey: "test1", title:"测试标题1", text: "测试内容1", combined: .single) { operate in
            let alert = CustomAlert.show(inView:inView, title: operate.title, msg: operate.text) { [weak operate] in
                operate?.finished()
            } cancelBlock: { [weak operate] in
                operate?.finished()
            }
            return alert
        }
        alertService.append(operate: operate, priority: .low, frequency: .once)
        
        let operate2 = ATAlertOperate.create(opKey: "test2", title:"测试2", text: "弹框测试2", data: 1, combined: .merged) { operate in
            let alert = CustomAlert.show(inView:inView, title: operate.title, msg: operate.text) { [weak operate] in
                operate?.finished()
            } cancelBlock: { [weak operate] in
                operate?.finished()
            }
            operate.updateAlertBlock = { [weak alert] operate in
                alert?.update(title: operate.title)
                alert?.update(message: operate.text)
                print("operate2.mergedDatas:\(operate.mergedDatas)")
            }
            return alert
        }
        alertService.append(operate: operate2, frequency: .every)
        
        let operate3 = ATAlertOperate.create(opKey: "test3",title:"测试标题3", text: "测试标题3", combined: .cover) { operate in
            let alert = CustomAlert.show(inView:UIApplication.shared.keyWindow!, title: operate.title, msg: operate.text) { [weak operate] in
                operate?.finished()
            } cancelBlock: { [weak operate] in
                operate?.finished()
            }
            operate.updateAlertBlock = { [weak alert] operate in
                alert?.update(title: operate.title)
                alert?.update(message: operate.text)
                print("operate3.data:\(operate.data)")
            }
            return alert
        }
        alertService.append(operate: operate3, priority: .low, frequency: .every)
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
