//
//  CustomButton.swift
//  KarHappy
//
//  Created by M sreekanth  on 26/07/18.
//  Copyright © 2018 Green Bird IT Services. All rights reserved.
//

import UIKit

@IBDesignable

public class CustomButton:UIButton{
    
    @IBInspectable open var cornerRadius:CGFloat = 3.0{
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
    }


    
    override public var isHighlighted: Bool{
        didSet{
            if isHighlighted{
                self.applyAnimation()
            }
        }
    }
    private func applyAnimation(){
        
        let view = UIView.init(frame: CGRect.init(origin: CGPoint.init(x: (self.frame.size.width/2)-(self.frame.size.height/2), y: 0), size: CGSize.init(width: self.frame.size.height, height: self.frame.size.height)))
        view.backgroundColor = UIColor.init(white: 1.0, alpha: 0.5)
        view.layer.cornerRadius = self.frame.size.height/2
        self.addSubview(view)
        view.alpha = 0.8
        UIView.animate(withDuration: 0.4, animations: {
            view.transform = CGAffineTransform.init(scaleX: 11, y: 11)
            view.alpha = 0.0
        }, completion: {bool in
            view.removeFromSuperview()
        })
        
    }
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
        
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
        
    }    
    
    func setup() {
        
        self.setTitleColor(UIColor.white, for: .normal)
        self.backgroundColor = UIColor.clear
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        
    }
}
