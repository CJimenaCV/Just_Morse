//
//  KeyboardViewController.swift
//  Morse
//
//  Created by Jimena De ceballos viadero on 26/9/22.
//

import UIKit
import SwiftUI

class KeyboardViewController: UIInputViewController {

    @IBOutlet var nextKeyboardButton: UIButton!
    @IBOutlet var line: UIButton!
    @IBOutlet var dot: UIButton!
    @IBOutlet var nextKey: UIButton!
    @IBOutlet var space: UIButton!
    @IBOutlet var delete: UIButton!
    @IBOutlet var send: UIButton!
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        // Add custom view sizing constraints here
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Perform custom UI setup here
        self.nextKeyboardButton = UIButton(type: .system)
        self.nextKeyboardButton.setTitle(NSLocalizedString("Next Keyboard", comment: "Title for 'Next Keyboard' button"), for: [])
        self.nextKeyboardButton.sizeToFit()
        self.nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = false
        self.nextKeyboardButton.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
        self.view.addSubview(self.nextKeyboardButton)
        self.nextKeyboardButton.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.nextKeyboardButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        let line = CustomButton(type: .system)
        line.funcion = "-"
        line.setTitle("-", for: .normal)
        line.sizeToFit()
        line.backgroundColor = .systemGray2
        line.layer.cornerRadius = 5
        line.addTarget(self, action: #selector(self.addKey), for: .touchUpInside)
        line.titleLabel?.font = .systemFont(ofSize: 50)
        line.frame = CGRect(x: 90, y: 20, width: 80, height: 80)
        
        let dot = CustomButton(type: .system)
        dot.funcion = "."
        dot.setTitle(".", for: .normal)
        dot.sizeToFit()
        dot.backgroundColor = .systemGray2
        dot.layer.cornerRadius = 5
        dot.addTarget(self, action: #selector(self.addKey), for: .touchUpInside)
        dot.titleLabel?.font = .systemFont(ofSize: 50)
        dot.frame = CGRect(x: 210, y: 20, width: 80, height: 80)

        let nextKey = CustomButton(type: .system)
        nextKey.funcion = "   "
        nextKey.setTitle("next key", for: .normal)
        nextKey.sizeToFit()
        nextKey.backgroundColor = .systemGray2
        nextKey.layer.cornerRadius = 5
        nextKey.addTarget(self, action: #selector(self.addKey), for: .touchUpInside)
        nextKey.titleLabel?.font = .systemFont(ofSize: 20)
        nextKey.frame = CGRect(x: 200, y: 120, width: 120, height: 60)
        
        
        
        let space = CustomButton(type: .system)
        space.funcion = "     "
        space.setTitle("space", for: .normal)
        space.sizeToFit()
        space.backgroundColor = .systemGray2
        space.layer.cornerRadius = 5
        space.addTarget(self, action: #selector(self.addKey), for: .touchUpInside)
        space.titleLabel?.font = .systemFont(ofSize: 20)
        space.frame = CGRect(x: 60, y: 120, width: 120, height: 60)
        
        
        let delete = CustomButton(type: .system)
        delete.funcion = ""
        delete.setTitle("<-", for: .normal)
        delete.sizeToFit()
        delete.backgroundColor = .systemGray2
        delete.layer.cornerRadius = 5
        delete.addTarget(self, action: #selector(self.deleteLastWord), for: .touchUpInside)
        delete.titleLabel?.font = .systemFont(ofSize: 40)
        delete.frame = CGRect(x: 310, y: 20, width: 60, height: 50)
        
        let send = CustomButton(type: .system)
        send.funcion = ""
        send.sizeToFit()
        send.backgroundColor = .systemBlue
        send.layer.cornerRadius = 5
        send.addTarget(self, action: #selector(self.end), for: .touchUpInside)
        send.titleLabel?.font = .systemFont(ofSize: 20)
        send.frame = CGRect(x: 20, y: 130, width: 60, height: 60)
        
        line.setTitleColor(.white, for: [])
        dot.setTitleColor(.white, for: [])
        nextKey.setTitleColor(.white, for: [])
        space.setTitleColor(.white, for: [])
        send.setTitleColor(.white, for: [])
        delete.setTitleColor(.white, for: [])
        
        self.view.addSubview(line)
        self.view.addSubview(dot)
        self.view.addSubview(nextKey)
        self.view.addSubview(space)
        self.view.addSubview(delete)
       
        //self.view.addSubview(send)
        
        self.nextKeyboardButton.setTitle(NSLocalizedString("Next Keyboard", comment: "Title for 'Next Keyboard' button"), for: [])
    }
    
    class CustomButton: UIButton {
        var funcion = ""
    }
    
    @objc func addKey(sender: CustomButton) {
        let proxy = textDocumentProxy
        proxy.insertText(sender.funcion)
    }
    
    @objc func end(sender: CustomButton) {
        
    }
    
    @objc func deleteLastWord(sender: CustomButton) {
        let proxy = textDocumentProxy
        
        if proxy.hasText {
            
            let a = proxy.documentContextBeforeInput?.last
            if a == " "{
                proxy.deleteBackward()
                proxy.deleteBackward()
                proxy.deleteBackward()
                let b = proxy.documentContextBeforeInput?.last
                if b == " "{
                    proxy.deleteBackward()
                    proxy.deleteBackward()
                }
            }
            else{
                proxy.deleteBackward()
            }
            
        }
    }
   
    
    override func viewWillLayoutSubviews() {
        self.nextKeyboardButton.isHidden = !self.needsInputModeSwitchKey
        super.viewWillLayoutSubviews()
    }
    
    override func textWillChange(_ textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
        
        var textColor: UIColor
        let proxy = self.textDocumentProxy
        if proxy.keyboardAppearance == UIKeyboardAppearance.dark {
            textColor = UIColor.white
        } else {
            textColor = UIColor.black
        }
        self.nextKeyboardButton.setTitleColor(textColor, for: [])
        
        
    }

}
