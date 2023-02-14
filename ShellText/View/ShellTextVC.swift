/*
 * Copyright (C) 2023 Recompile.me.
 * All rights reserved.
 */

import UIKit

protocol RulesForPrinting {
    func print(_ text: String, color: UIColor, global: Bool);
    func print(_ text: NSAttributedString, global: Bool);
    func addLine();
    func error(_ text: String);
}

class ShellTextVC: UIViewController, RulesForPrinting {

    @IBOutlet weak var textView: UITextView!
    static var delegate: ShellTextVC?;
    var currentWeather: CurrentWeather?;
    
    var textAppearance: [NSAttributedString.Key: Any] = {
        return [
            .font: UIFont(name: "Menlo", size: 14.0),
            .foregroundColor: UIColor.white
        ].compactMapValues({ $0 })
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad();
        ShellTextVC.delegate = self;
        currentWeather = CurrentWeather();
        currentWeather?.downloadWeatherDetails {
            
        }
        
        // Do any additional setup after loading the view.
    }
    
    func print(_ text: String, color: UIColor, global: Bool) {
        let formattedText = NSMutableAttributedString(string: text)
        formattedText.addAttributes(textAppearance, range: formattedText.range)
        formattedText.addAttribute(.foregroundColor, value: color, range: formattedText.range)
        print(formattedText, global: global)
    }

    func print(_ text: NSAttributedString, global: Bool) {
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
        print(text, color: UIColor.red, global: true);
    }

    func addLine() {
        print("-----------", color: UIColor.red, global: true);
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

