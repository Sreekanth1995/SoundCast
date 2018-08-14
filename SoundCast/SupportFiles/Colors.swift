//
//  Extentions.swift
//  SoundCast
//
//  Created by M sreekanth  on 09/08/18.
//  Copyright © 2018 Green Bird IT Services. All rights reserved.
//

import UIKit
extension UIColor
{
    class func appThemeColor() -> UIColor
    {
        
        //        return UIColor.init(red: 40/255.0, green: 77.0/255.0, blue: 108.0/255.0, alpha: 1)
        return UIColor.init(red: 0/255.0, green: 102.0/255.0, blue: 204.0/255.0, alpha: 1.0)
        return UIColor.init(red: 252.0/255.0, green: 135.0/255.0, blue: 115.0/255.0, alpha: 1)
        
    }
    class func optionsTableViewColor() -> UIColor
    {
        return UIColor.init(red: 249.0/255.0, green: 249.0/255.0, blue: 249.0/255.0, alpha: 1)
        
        
    }
    
    class func secondaryColor() -> UIColor{
        return UIColor.init(red: 108.0/255.0, green: 109.0/255.0, blue: 111.0/255.0, alpha: 1)
    }
    
    class func tertiaryColor() -> UIColor{
        
        return UIColor.colorWith(17.0, 117.0, 149.0)
        
    }
    class func colorWith(_ red:CGFloat, _ green:CGFloat, _ blue:CGFloat) -> UIColor{
        return UIColor.init(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: 1)
    }
    
}
