//
//  ViewController.swift
//  SoundCast
//
//  Created by M sreekanth  on 09/08/18.
//  Copyright © 2018 Green Bird IT Services. All rights reserved.
//

import UIKit
import AVFoundation

class SongsController: UIViewController {
    
    var presenter:SongsPresenter?
    init(_ presenter:SongsPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    lazy var tableView:UITableView = {
        let tv = UITableView()
        tv.dataSource = presenter
        self.presenter?.registerTableView(tv)
        tv.delegate = self
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.separatorStyle = .none
        tv.separatorColor = .clear
        return tv
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Songs"
        self.view.backgroundColor = .white
        self.setupTableView()
        presenter?.fetchSongs({[weak self] in 
            self?.tableView.reloadData()
        })
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "backgroundCallForSongs"), object: nil, queue: nil, using: {notify in
            print("notification")
            self.tableView.reloadData()
        })
    }
    override func viewWillAppear(_ animated: Bool) {
        self.presenter?.avAudioPlayer?.delegate = self
        self.tableView.reloadData()
    }
    private func setupTableView() {
        
        self.view.addSubview(tableView)
        self.view.addConstraintsWithVisualFormat("H:|[v0]|", views: self.tableView)
        self.view.addConstraintsWithVisualFormat("V:|[v0]|", views: self.tableView)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
extension SongsController:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell:SongsCell = tableView.cellForRow(at: indexPath) as! SongsCell
        
        if cell.status == SongStatus.downloaded{
            
            cell.status = SongStatus.playing
            cell.statusIcon.image = #imageLiteral(resourceName: "pauseIcon").withRenderingMode(.alwaysTemplate)
            cell.setupPulsingAnimation()
            let detailsController = DetailsController.init(self.presenter!)
            detailsController.song = self.presenter?.playSong(at: indexPath.row)
            self.navigationController?.pushViewController(detailsController, animated: true)
            
        }else if cell.status == SongStatus.playing{
            let detailsController = DetailsController.init(self.presenter!)
            self.navigationController?.pushViewController(detailsController, animated: true)
        }
    }
    
}
extension SongsController:AVAudioPlayerDelegate{
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag{
            let currentIndex = self.presenter?.userSelectedIndex ?? 0
            _ = self.presenter?.playSong(at: currentIndex + 1)
            self.tableView.reloadData()
        }
    }
    
}
