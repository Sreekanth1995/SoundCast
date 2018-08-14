//
//  ControlsView.swift
//  SoundCast
//
//  Created by M sreekanth  on 10/08/18.
//  Copyright © 2018 Green Bird IT Services. All rights reserved.
//

import UIKit


class ControlsView: UIView {
    
    var prevBtn:CustomButton = {
        let btn = CustomButton()
        btn.cornerRadius = 30
        btn.setImage(#imageLiteral(resourceName: "prevIcon").withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = UIColor.appThemeColor()
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    var nextBtn:CustomButton = {
        let btn = CustomButton()
        btn.cornerRadius = 30
        btn.setImage(#imageLiteral(resourceName: "nextIcon").withRenderingMode(.alwaysTemplate), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.tintColor = UIColor.appThemeColor()
        return btn
    }()
    var pausBtn:CustomButton = {
        let btn = CustomButton()
        btn.cornerRadius = 30
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(#imageLiteral(resourceName: "pauseIcon").withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = UIColor.appThemeColor()
        return btn
    }()
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    func setup() {
        
        self.addSubview(prevBtn)
        self.addSubview(pausBtn)
        self.addSubview(nextBtn)
        
        self.backgroundColor = UIColor.lightGray.withAlphaComponent(0.85)
        self.layer.shadowOffset = CGSize.init(width: 0, height: -5)
        self.layer.shadowRadius = 5.0
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.masksToBounds = false
        
        
        self.addConstraintsWithVisualFormat("H:[v0(60@750)]-15-[v1(90@1000)]-15-[v2(60@750)]", views: prevBtn,pausBtn,nextBtn)
        
        self.addConstraintsWithVisualFormat("V:[v0(60@750)]", views: prevBtn)
        self.addConstraintsWithVisualFormat("V:[v0(90@750)]", views: pausBtn)
        self.addConstraintsWithVisualFormat("V:[v0(60@750)]", views: nextBtn)
        
        self.pausBtn.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        self.prevBtn.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.pausBtn.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.nextBtn.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
    }
}
