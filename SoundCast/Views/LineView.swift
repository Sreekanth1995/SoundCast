//
//  LineView.swift
//  KarHappy
//
//  Created by M sreekanth  on 26/07/18.
//  Copyright © 2018 Green Bird IT Services. All rights reserved.
//

import UIKit


@IBDesignable
open class LineView:UIView{
    
    

    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 1.0
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        self.backgroundColor = UIColor.appThemeColor()
        
        
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.layer.cornerRadius = 1.0
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        self.backgroundColor = UIColor.appThemeColor()
        
    }
    
    
}
