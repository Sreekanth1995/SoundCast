//
//  DetailsController.swift
//  SoundCast
//
//  Created by M sreekanth  on 09/08/18.
//  Copyright © 2018 Green Bird IT Services. All rights reserved.
//

import UIKit
import AVFoundation

class DetailsController: UIViewController {
    
    var presenter:SongsPresenter?
    init(_ presenter:SongsPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        
    }
    var song:Song? {
        didSet{
            self.setImage(song!.thumbnail!)
            self.title = song!.title
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    let thumbNail:UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleToFill
        return iv
    }()
    var controlview:ControlsView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter?.avAudioPlayer?.delegate = self
        self.view.backgroundColor = .white
        setupViews()
        
    }
    func setImage(_ link:String) {
        if let url = URL.init(string: link){
            thumbNail.af_setImage(withURL: url, placeholderImage: self.presenter?.placeholderImage)
        }
    }
    func setupViews() {
        
        self.view.addSubview(thumbNail)
        self.view.addConstraintsWithVisualFormat("H:|[v0]|", views: self.thumbNail)
        self.view.addConstraintsWithVisualFormat("V:|[v0]|", views: self.thumbNail)
        
        self.controlview = ControlsView.init(frame: CGRect.init(x: 0, y: self.view.frame.size.height-100, width: self.view.frame.size.width, height: 100))
        self.view.addSubview(self.controlview!)
        
        self.view.addConstraintsWithVisualFormat("H:|[v0]|", views: self.controlview!)
        self.view.addConstraintsWithVisualFormat("V:[v0(100@750)]|", views: self.controlview!)
        self.controlview?.prevBtn.addTarget(self, action: #selector(previousButtonAction), for: .touchUpInside)
        self.controlview?.pausBtn.addTarget(self, action: #selector(pauseButtonAction(_:)), for: .touchUpInside)
        self.controlview?.nextBtn.addTarget(self, action: #selector(nextButtonAction), for: .touchUpInside)
        
    }
    @objc func previousButtonAction(){
        
        let currentIndex = self.presenter?.userSelectedIndex ?? 0
        self.song = self.presenter?.playSong(at: currentIndex - 1)
        
    }
    @objc func pauseButtonAction(_ sender: CustomButton){
        if (self.presenter!.avAudioPlayer?.isPlaying)!{
            self.presenter?.avAudioPlayer?.pause()
            sender.setImage(#imageLiteral(resourceName: "playIcon").withRenderingMode(.alwaysTemplate), for: .normal)
            
        }else{
            self.presenter?.avAudioPlayer?.play()
            sender.setImage(#imageLiteral(resourceName: "pauseIcon").withRenderingMode(.alwaysTemplate), for: .normal)
            
        }
        
    }
    @objc func nextButtonAction(){
        let currentIndex = self.presenter?.userSelectedIndex ?? 0
        self.song = self.presenter?.playSong(at: currentIndex + 1)
    }
}
extension DetailsController: AVAudioPlayerDelegate{
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag{
            let currentIndex = self.presenter?.userSelectedIndex ?? 0
            self.song = self.presenter?.playSong(at: currentIndex + 1)
        }
    }
}
