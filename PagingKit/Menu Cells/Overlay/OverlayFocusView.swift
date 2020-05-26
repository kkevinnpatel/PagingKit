//
//  OverlayFocusView.swift
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

public class OverlayFocusView: UIView {
    public var contentBackgroundColor: UIColor? {
        set {
            contentView.backgroundColor = newValue
        }
        get {
            return contentView.backgroundColor
        }
    }
    
    let contentView = UIView()
    
    static let gradientFirst = UIColor(red: 178/255, green: 35/255, blue: 233/255, alpha: 1) // rgb 178 35 233
    static let gradientSecond = UIColor(red: 209/255, green: 43/255, blue: 201/255, alpha: 1) // rgb 209 43 201
    static let gradientThird = UIColor(red: 247/255, green: 50/255, blue: 162/255, alpha: 1) // rgb 247 50 162
    static let gradientFourth = UIColor(red: 254/255, green: 94/255, blue: 124/255, alpha: 1) // rgb 254 94 124
    static let gradientFifth = UIColor(red: 255/255, green: 156/255, blue: 80/255, alpha: 1)
    
    let colorArray = [gradientFirst,
    gradientSecond,
    gradientThird,
    gradientFourth,
    gradientFifth]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addConstraints()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        //contentView.layer.cornerRadius = contentView.bounds.height / 2
        
        contentView.layer.addSublayer(addGradientLayer())
        contentView.layer.cornerRadius = 7
        contentView.clipsToBounds = true
    }
    
    func addGradientLayer() -> CAGradientLayer {
        
        removeSublayer(contentView, layerIndex: 0)

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: contentView.frame.size.width, height: contentView.frame.size.height)
        gradientLayer.colors =  colorArray.map{$0.cgColor}
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        
        return gradientLayer
    }
    
    func removeSublayer(_ view: UIView, layerIndex index: Int) {
        guard let sublayers = view.layer.sublayers else {
            print("The view does not have any sublayers.")
            return
        }
        if sublayers.count > index {
            view.layer.sublayers!.remove(at: index)
        } else {
            print("There are not enough sublayers to remove that index.")
        }
    }
    
    
    private func addConstraints() {
        //contentView.backgroundColor = .red
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        let trailingConstraint = NSLayoutConstraint(
            item: self,
            attribute: .trailing,
            relatedBy: .equal,
            toItem: contentView,
            attribute: .trailing,
            multiplier: 1,
            constant: 8)
        let leadingConstraint = NSLayoutConstraint(
            item: contentView,
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
            toItem: contentView,
            attribute: .centerY,
            multiplier: 1,
            constant: 0)
        let hightConstraint = NSLayoutConstraint(
            item: contentView,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .height,
            multiplier: 1,
            constant: 32)
        
        addConstraints([centerConstraint, trailingConstraint, leadingConstraint])
        contentView.addConstraint(hightConstraint)
    }
}
