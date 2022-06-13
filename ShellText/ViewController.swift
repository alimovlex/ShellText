//
//  ViewController.swift
//  ShellText
//
//  Created by robot on 4/22/21.
//  Copyright © 2021 robot. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    var textAppearance: [NSAttributedString.Key: Any] = {
        return [
            .font: UIFont(name: "Menlo", size: 14.0),
            .foregroundColor: UIColor.white
        ].compactMapValues({ $0 })
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        print("TESTING THE CONSOLE MODE!!!", color: .red, global: true);
        
        // Do any additional setup after loading the view.
    }
    
    func print(_ text: String, color: UIColor = UIColor.white, global: Bool = true) {
        let formattedText = NSMutableAttributedString(string: text)
        formattedText.addAttributes(textAppearance, range: formattedText.range)
        formattedText.addAttribute(.foregroundColor, value: color, range: formattedText.range)
        print(formattedText, global: global)
    }

    func print(_ text: NSAttributedString, global: Bool = true) {
        // When we leave this method and global is true, we want to print it to console
        defer {
            if global {
                Swift.print(text.string)
            }
        }
        
        DispatchQueue.main.async {
            let timeStamped = NSMutableAttributedString(string: "\(DateFormatter().string(from: Date())) ")
            let range = NSRange(location: 0, length: timeStamped.length)
            
            timeStamped.addAttributes(self.textAppearance, range: range)
            timeStamped.append(text)
            timeStamped.append(.breakLine())
            
            let newText = NSMutableAttributedString(attributedString: self.textView.attributedText)
            newText.append(timeStamped)
            
            self.textView.attributedText = newText
            self.scrollToBottom()
        }
    }

    func error(_ text: String) {
        print(text, color: UIColor.red)
    }

    func addLine() {
        print("-----------", color: UIColor.red)
    }
    
    func scrollToBottom() {
        textView.layoutManager.ensureLayout(for: textView.textContainer)
        let offset = CGPoint(x: 0, y: (textView.contentSize.height - textView.frame.size.height))
        textView.setContentOffset(offset, animated: true)
    }
    
    func clear() {
        DispatchQueue.main.async {
            self.textView.text.removeAll();
            self.scrollToBottom()
        }
    }
    
}

internal extension NSAttributedString {
    static func breakLine() -> NSAttributedString {
        return NSAttributedString(string: "\n")
    }
    
    var range: NSRange {
        return NSRange(location: 0, length: length)
    }
}

