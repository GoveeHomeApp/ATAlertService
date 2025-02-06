//
//  CustomAlert.swift
//  ATAlertService_Example
//
//  Created by abiaoyo on 2025/2/6.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

class CustomAlert: UIView {
    
    private let titleLabel = UILabel()
    private let messageLabel = UILabel()
    private let cancelButton = UIButton(type: .system)
    private let confirmButton = UIButton(type: .system)
    
    var onConfirm: (() -> Void)?
    var onCancel: (() -> Void)?
    
    init(title: String, message: String) {
        super.init(frame: .zero)
        
        // 设置背景颜色和圆角
        self.backgroundColor = .white
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        
        // 设置阴影效果
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 4
        
        // 标题标签
        titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titleLabel)
        
        // 消息标签
        messageLabel.text = message
        messageLabel.font = UIFont.systemFont(ofSize: 16)
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(messageLabel)
        
        // 取消按钮
        cancelButton.setTitle("取消", for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(cancelButton)
        
        // 确认按钮
        confirmButton.setTitle("确定", for: .normal)
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(confirmButton)
        
        // 设置约束
        NSLayoutConstraint.activate([
            // 标题标签约束
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            
            // 消息标签约束
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            
            // 按钮容器视图约束
            cancelButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            cancelButton.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            cancelButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5),
            cancelButton.heightAnchor.constraint(equalToConstant: 50),
            
            confirmButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            confirmButton.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            confirmButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5),
            confirmButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func cancelButtonTapped() {
        onCancel?()
        removeFromSuperview()
    }
    
    @objc private func confirmButtonTapped() {
        onConfirm?()
        removeFromSuperview()
    }
    func update(title:String) {
        titleLabel.text = title
    }
    func update(message:String) {
        messageLabel.text = message
    }
    
    static func show(inView:UIView, title:String, msg:String, okBlock:(() -> Void)?, cancelBlock:(() -> Void)?) -> CustomAlert {
        let dialog = CustomAlert(title: title, message: msg)
        dialog.layer.borderWidth = 0.5
        dialog.layer.borderColor = UIColor.black.cgColor
        
        // 设置回调闭包
        dialog.onConfirm = {
            print("确定按钮被点击")
            okBlock?()
        }
        
        dialog.onCancel = {
            print("取消按钮被点击")
            cancelBlock?()
        }
        
        // 将对话框添加到主视图
        inView.addSubview(dialog)
        
        // 设置对话框的约束使其居中显示
        dialog.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dialog.centerXAnchor.constraint(equalTo: inView.centerXAnchor),
            dialog.centerYAnchor.constraint(equalTo: inView.centerYAnchor),
            dialog.widthAnchor.constraint(equalToConstant: 300),
            dialog.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        // 添加动画效果
        dialog.alpha = 0
        UIView.animate(withDuration: 0.3) {
            dialog.alpha = 1
        }
        return dialog
    }
    
}
