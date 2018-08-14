//
//  SongsPresenter.swift
//  SoundCast
//
//  Created by M sreekanth  on 09/08/18.
//  Copyright © 2018 Green Bird IT Services. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire
import AVFoundation

class SongsPresenter:NSObject{
    
    let thumnailFilter = AspectScaledToFillSizeFilter.init(size: CGSize.init(width: 75, height: 75))
    let placeholderImage = UIImage.init(named: "sample.png")
    let filemanager = FileManager.default
    
    var alamofiremanager:Alamofire.SessionManager?
    var isExcecuting:Bool = false
    
    private var songs:[Song] = [Song]()
    
    private let identifier = "Default"
    
    
    var avAudioPlayer:AVAudioPlayer?
    public var userSelectedIndex:Int?
    
    public func registerTableView(_ table:UITableView) {
        table.register(SongsCell.self, forCellReuseIdentifier: identifier)
    }
    func fetchSongs(_ callback: @escaping (()->Void)) {
        ApiCall().fetchSongs({songs, error in
            
            if let songs = songs{
                self.songs = songs
                callback()
            }
            
        })
        
    }
    
    func song(_ index:Int) -> Song {
        
        self.userSelectedIndex = index
        return self.songs[index]
        
    }
    
    func playSong(at index:Int) -> Song {
        
        if userSelectedIndex == index{
            if avAudioPlayer!.isPlaying{
            }else{
                avAudioPlayer?.play()
            }
            return self.songs[index]
            
        }else if index < 0{
            
            self.userSelectedIndex = 0
            self.playSongWithAudioPlayer(song: self.songs.first!)
            return self.songs.first!
            
        }else if index < self.songs.count{
            
            self.userSelectedIndex = index
            self.playSongWithAudioPlayer(song: self.songs[index])
            return self.songs[index]
            
        }else{
            
            self.userSelectedIndex = self.songs.count - 1
            return self.songs.last!
            
        }
    }
    private func playSongWithAudioPlayer(song:Song){
        
        if avAudioPlayer != nil{
            avAudioPlayer = nil
        }
        if self.checkFilesInDirectory(url: song.link!) {
            do{
                let directory = self.getPath()
                let url = URL.init(string: song.link!)!
                let fileURL = directory.appendingPathComponent(url.lastPathComponent)
                self.avAudioPlayer = try AVAudioPlayer.init(contentsOf: fileURL)
                self.avAudioPlayer?.prepareToPlay()
                self.avAudioPlayer?.play()
                let audioSession = AVAudioSession.sharedInstance()
                do{
                    try audioSession.setCategory(AVAudioSessionCategoryPlayback)
                }catch{
                    
                }
                
            }catch{
                print(error)
            }
        }
    }

    fileprivate func directoryExistsAtPath(_ path: String) -> Bool {
        var isDirectory = ObjCBool(true)
        let exists = filemanager.fileExists(atPath: path, isDirectory: &isDirectory)
        return exists && isDirectory.boolValue
    }
    private func getPath() -> URL{
        
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentsDirectory: AnyObject = paths[0] as AnyObject
        let directoryPath = URL.init(fileURLWithPath: documentsDirectory as! String).appendingPathComponent("SoundCast", isDirectory: true)
        if directoryExistsAtPath(directoryPath.path){
            return directoryPath
        }
        do{
            try filemanager.createDirectory(atPath: directoryPath.path, withIntermediateDirectories: false, attributes: nil)
        }catch{
            print(error.localizedDescription)
        }
        return directoryPath
        
    }
    private func checkFilesInDirectory(url:String) -> Bool{
        if let url:URL = URL.init(string: url){
            
            let directoryPath = self.getPath()
            let datapath = directoryPath.appendingPathComponent(url.lastPathComponent)
            print(datapath)
            return filemanager.fileExists(atPath: datapath.path)
            
        }
        return false
    }
    
    private func downloadSongFromServer(_ urlStr:String, callBack: @escaping () -> Void){
        
        if let audioUrl = URL(string: urlStr) {
            
            let directoryUrl = self.getPath()
            let fileUrl = directoryUrl.appendingPathComponent(audioUrl.lastPathComponent)
            
            if filemanager.fileExists(atPath: fileUrl.path) {
                print("The file already exists at path")
                
            } else {
                
                // you can use NSURLSession.sharedSession to download the data asynchronously
                
                
                let destinationUrl : DownloadRequest.DownloadFileDestination = {_ ,_ in
                    
                    return (fileUrl, [.removePreviousFile])
                }
                let configuration = URLSessionConfiguration.background(withIdentifier: audioUrl.lastPathComponent)
                
                self.alamofiremanager = Alamofire.SessionManager(configuration: configuration)
                
                alamofiremanager?.download(audioUrl, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, to: destinationUrl)
                    
                    
                    .downloadProgress(closure: {progress in
//                        print("File Size:: %@",progress.fileTotalCount)
                        
                    })
                    .responseData(completionHandler: {data in
                        
                        self.isExcecuting = false
                        callBack()
                        
                    })
                    
                    .response(completionHandler: {response in
                        
                        if response.response?.statusCode != 200{
                            self.isExcecuting = false
                        }
                        
                    })
                
            }
        }
    }
}


extension SongsPresenter:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:SongsCell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! SongsCell
        cell.iconView.af_setImage(withURL: URL.init(string: songs[indexPath.row].thumbnail!)!, placeholderImage: placeholderImage, filter: thumnailFilter)
        cell.label.text = songs[indexPath.row].title
        
        
        if userSelectedIndex == indexPath.row{
            if (self.avAudioPlayer?.isPlaying)!{
                cell.status = SongStatus.downloaded
                cell.statusIcon.image = #imageLiteral(resourceName: "pauseIcon").withRenderingMode(.alwaysTemplate)
                cell.setupPulsingAnimation()
            }else{
                cell.status = SongStatus.downloaded
                cell.statusIcon.image = #imageLiteral(resourceName: "playIcon").withRenderingMode(.alwaysTemplate)
                cell.removePulsingAnimation()
            }
        }else{
            if checkFilesInDirectory(url: songs[indexPath.row].link!){
                
                cell.status = SongStatus.downloaded
                cell.statusIcon.image = #imageLiteral(resourceName: "playIcon").withRenderingMode(.alwaysTemplate)
                cell.removePulsingAnimation()
                
            }else{
                cell.status = SongStatus.notDownloaded
                cell.statusIcon.image = #imageLiteral(resourceName: "downloadIcon").withRenderingMode(.alwaysTemplate)
                if !isExcecuting {
                    isExcecuting = true
                    cell.setupPulsingAnimation()
                    cell.status = SongStatus.downloading
                    self.downloadSongFromServer(songs[indexPath.row].link!, callBack: {
                        DispatchQueue.main.async {
                            tableView.reloadData()
                        }
                    })
                }
                
            }
        }
        cell.selectionStyle = .none
        return cell
        
    }
    
}

