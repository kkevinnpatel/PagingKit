//
//  OverlayMenuCell.swift
//  iOS Sample
//
//  Copyright (c) 2017 Kazuhiro Hayashi
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import UIKit

public class OverlayMenuCell: PagingMenuViewCell {
    
    public weak var referencedMenuView: PagingMenuView?
    public weak var referencedFocusView: PagingMenuFocusView?
    
    var currentIndex = 0
    
    public var hightlightTextColor: UIColor? {
        set {
            highlightLabel.textColor = newValue
        }
        get {
            return highlightLabel.textColor
        }
    }
    
    public var normalTextColor: UIColor? {
        set {
            titleLabel.textColor = newValue
        }
        get {
            return titleLabel.textColor
        }
    }
    
    public static let sizingCell = OverlayMenuCell()
    
    let maskInsets = UIEdgeInsets(top: 6, left: 8, bottom: 6, right: 8)
    //let maskInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    
    let textMaskView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    let highlightLabel = UILabel()
    let titleLabel = UILabel()
    let backgroundContentView = UIView()
    
    public var currentTaga = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addConstraints()
        highlightLabel.mask = textMaskView
        highlightLabel.textColor = .white //UIColor(red: 179/255, green: 131/255, blue: 170/255, alpha: 1)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addConstraints()
        highlightLabel.mask = textMaskView
        highlightLabel.textColor = .white // UIColor(red: 179/255, green: 131/255, blue: 170/255, alpha: 1)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        textMaskView.bounds = bounds.inset(by: maskInsets)
    }
    
    public func configure(title: String, currentIndex: Int) {
        
        titleLabel.text = title
        
        if currentIndex == 0 {
            titleLabel.addImageWith(name: "icNew", behindText: false)
        } else if currentIndex == 1 {
            titleLabel.addImageWith(name: "icHot", behindText: false)
        }
        
        titleLabel.textColor = UIColor(red: 179/255, green: 131/255, blue: 170/255, alpha: 1)
        
        titleLabel.layer.cornerRadius = 7
        titleLabel.clipsToBounds = true
        
        highlightLabel.text = title
        
        if currentIndex == 0 {
            highlightLabel.addImageWith(name: "icNewAc", behindText: false)
        } else if currentIndex == 1 {
            highlightLabel.addImageWith(name: "icHotAc", behindText: false)
        }
        
        //highlightLabel.addImageWith(name: "Poo", behindText: false)
        
        highlightLabel.layer.cornerRadius = 7
        highlightLabel.clipsToBounds = true
        
        backgroundContentView.layer.cornerRadius = 7
        backgroundContentView.clipsToBounds = true
        backgroundContentView.backgroundColor = .red
    }
    
    public func setBackgroundColor(getColor: UIColor) {
        
        if getColor == UIColor.clear {
            
        } else {
            
        }
        backgroundContentView.backgroundColor = getColor
    }
    
    public func updateMask(animated: Bool = true) {
        guard let menuView = referencedMenuView, let focusView = referencedFocusView else {
            return
        }
        
        setFrame(menuView, maskFrame: focusView.frame, animated: animated)
    }
    
    func setFrame(_ menuView: PagingMenuView, maskFrame: CGRect, animated: Bool) {
        textMaskView.frame = menuView.convert(maskFrame, to: highlightLabel).inset(by: maskInsets)
    }
    
    public func calculateWidth(from height: CGFloat, title: String, getIndex: Int) -> CGFloat {
        
        configure(title: title, currentIndex: getIndex)
        var referenceSize = UIView.layoutFittingCompressedSize
        referenceSize.height = height
        let size = systemLayoutSizeFitting(referenceSize, withHorizontalFittingPriority: UILayoutPriority.defaultLow, verticalFittingPriority: UILayoutPriority.defaultHigh)
        return size.width
    }
}

extension OverlayMenuCell {
    
    private func addConstraints() {
        
        addSubview(backgroundContentView)
        backgroundContentView.translatesAutoresizingMaskIntoConstraints = false
        
        let trailingConstraint = NSLayoutConstraint(
            item: self,
            attribute: .trailing,
            relatedBy: .equal,
            toItem: backgroundContentView,
            attribute: .trailing,
            multiplier: 1,
            constant: 8)
        let leadingConstraint = NSLayoutConstraint(
            item: backgroundContentView,
            attribute: .leading,
            relatedBy: .equal,
            toItem: self,
            attribute: .leading,
            multiplier: 1,
            constant: 8)
        let centerConstraint = NSLayoutConstraint(
            item: self,
            attribute: .centerY,
            relatedBy: .equal,
            toItem: backgroundContentView,
            attribute: .centerY,
            multiplier: 1,
            constant: 0)
        let hightConstraint = NSLayoutConstraint(
            item: backgroundContentView,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .height,
            multiplier: 1,
            constant: 32)
        
        addConstraints([centerConstraint, trailingConstraint, leadingConstraint])
        backgroundContentView.addConstraint(hightConstraint)
        
        addSubview(titleLabel)
        addSubview(highlightLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        highlightLabel.translatesAutoresizingMaskIntoConstraints = false
        
        [titleLabel, highlightLabel].forEach {
            
            let trailingConstraint = NSLayoutConstraint(
                item: self,
                attribute: .trailing,
                relatedBy: .equal,
                toItem: $0,
                attribute: .trailing,
                multiplier: 1,
                constant: 16)
            
            let leadingConstraint = NSLayoutConstraint(
                item: $0,
                attribute: .leading,
                relatedBy: .equal,
                toItem: self,
                attribute: .leading,
                multiplier: 1,
                constant: 16)
            
            let bottomConstraint = NSLayoutConstraint(
                item: self,
                attribute: .top,
                relatedBy: .equal,
                toItem: $0,
                attribute: .top,
                multiplier: 1,
                constant: 8)
            
            let topConstraint = NSLayoutConstraint(
                item: $0,
                attribute: .bottom,
                relatedBy: .equal,
                toItem: self,
                attribute: .bottom,
                multiplier: 1,
                constant: 8)
            
            addConstraints([topConstraint, bottomConstraint, trailingConstraint, leadingConstraint])
        }
    }
}

extension UILabel {
    
    func addImageWith(name: String, behindText: Bool) {
        
        let attachment = NSTextAttachment()
        attachment.image = UIImage(named: name)
        attachment.bounds = CGRect(x: 9, y: 0, width: 18, height: 18)
        
        let attachmentString = NSAttributedString(attachment: attachment)
        
        guard let txt = self.text else {
            return
        }
        
        if behindText {
            let strLabelText = NSMutableAttributedString(string: txt)
            strLabelText.append(attachmentString)
            self.attributedText = strLabelText
        } else {
            let strLabelText = NSAttributedString(string: txt)
            let mutableAttachmentString = NSMutableAttributedString(attributedString: attachmentString)
            mutableAttachmentString.append(strLabelText)
            self.attributedText = mutableAttachmentString
        }
    }
    
    func removeImage() {
        let text = self.text
        self.attributedText = nil
        self.text = text
    }
}
