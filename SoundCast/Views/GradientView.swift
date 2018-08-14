//
//  GradientView.swift
//  KarHappy
//
//  Created by M sreekanth  on 03/08/18.
//  Copyright © 2018 Green Bird IT Services. All rights reserved.
//

import UIKit

@IBDesignable
class GradientView:UIView{
    
    @IBInspectable var firstColor: UIColor = UIColor.appThemeColor(){
        didSet{
            self.updateColors()
        }
    }
    @IBInspectable var secondColor: UIColor = UIColor.white{
        didSet{
            self.updateColors()
        }
    }
    
    @IBInspectable var imageWidth:CGFloat = 200.0
    
    @IBInspectable var vertical: Bool = true{
        didSet{
            self.updateGradientDirection()
        }
    }
    
    lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [firstColor.cgColor, secondColor.cgColor]
        layer.startPoint = CGPoint.zero
        return layer
    }()
    lazy var imageLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [secondColor.cgColor, firstColor.cgColor]
        layer.startPoint = CGPoint.zero
        return layer
    }()
    //MARK: -
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        applyGradient()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        applyGradient()
        
        
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        applyGradient()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateGradientFrame()
    }
    
    //MARK: - gradientView methods....
    
    func applyGradient() {
        updateGradientDirection()
        layer.sublayers = [gradientLayer,imageLayer]
    }
    func updateColors(){
        
        gradientLayer.colors = [firstColor.cgColor, secondColor.cgColor]
        
    }
    func updateGradientFrame() {
        gradientLayer.frame = bounds
    }
    
    func updateGradientDirection() {
        gradientLayer.endPoint = vertical ? CGPoint(x: 0, y: 1) : CGPoint(x: 1, y: 0)
    }
    
    
}



