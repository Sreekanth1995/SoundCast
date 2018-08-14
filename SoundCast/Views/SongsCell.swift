//
//  SettingsCell.swift
//  KarHappy
//
//  Created by M sreekanth  on 06/08/18.
//  Copyright © 2018 Green Bird IT Services. All rights reserved.
//

import UIKit
import AlamofireImage

enum SongStatus {
    case notDownloaded
    case downloaded
    case downloading
    case playing
}
class SongsCell: UITableViewCell {
    
    
    var status:SongStatus = .notDownloaded
    var pulsingAnimation:Pulsing?
    
    var iconView:UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleToFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    var label:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16.0)
        return label
    }()
    var statusIcon:UIImageView = {
        let iv = UIImageView()
        iv.tintColor = UIColor.appThemeColor()
        iv.image = UIImage()
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    let animationView:GradientView = {
        let view = GradientView()
        view.alpha = 0.0
        view.vertical = false
        view.firstColor = .clear
        view.secondColor = UIColor.appThemeColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setup()
    }
    func setup() {
        
        self.animationView.frame = CGRect.init(x: -self.frame.size.width, y: 0, width: self.frame.size.width, height: 8+75+8)
        self.addSubview(self.animationView)
        
        self.addSubview(self.iconView)
        self.addSubview(self.label)
        self.addSubview(self.statusIcon)

        self.addConstraintsWithVisualFormat("H:|-8-[v0(75)]-8-[v1]-[v2(30@750)]-22-|", views: self.iconView,self.label,self.statusIcon)
        self.addConstraintsWithVisualFormat("V:|-8-[v0(75)]-8-|", views: self.iconView)
        self.addConstraintsWithVisualFormat("V:|-8-[v0(30@750)]-8-|", views: self.label)
        self.statusIcon.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.statusIcon.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        let line = LineView()
        self.addSubview(line)
        line.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraintsWithVisualFormat("H:|[v0]|", views: line)
        self.addConstraintsWithVisualFormat("V:[v0(2@750)]|", views: line)
        
        
        
        
    }
    func removePulsingAnimation() {
        pulsingAnimation?.removeAllAnimations()
        pulsingAnimation?.removeFromSuperlayer()
        pulsingAnimation = nil
    }
    func setupPulsingAnimation() {
        pulsingAnimation = Pulsing.init(radius: 40/2, position: self.statusIcon.center)
        pulsingAnimation?.animationDuration = 0.5
        self.layer.insertSublayer(pulsingAnimation!, below: self.statusIcon.layer)
    }
    override func layoutSubviews() {
        if pulsingAnimation != nil{
            pulsingAnimation?.position = self.statusIcon.center
        }
    }
    
    public func applyAnimation(){
        
        self.iconView.image = self.iconView.image?.withRenderingMode(.alwaysTemplate)
        self.label.textColor = UIColor.appThemeColor()
        
        self.animationView.alpha = 1.0
        UIView.animate(withDuration: 0.8, animations: {
            
            self.animationView.transform = CGAffineTransform.init(translationX: self.frame.size.width*2, y: 0)
            
        }, completion: {bool in
            
            self.animationView.transform = .identity
            self.animationView.alpha = 0.0
            
        })
        
    }
}
extension UIView{
    
    func addConstraintsWithVisualFormat(_ format:String, views:UIView...) {
        
        var dict = [String:UIView]()
        for (index,view) in views.enumerated(){
            let key = "v\(index)"
            dict[key] = view
        }
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: dict))
        
    }
    
}
