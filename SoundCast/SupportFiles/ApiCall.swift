//
//  Singleton.swift
//  SoundCastMVVM
//
//  Created by M sreekanth  on 10/08/18.
//  Copyright © 2018 Green Bird IT Services. All rights reserved.
//

import UIKit
import Alamofire

class ApiCall:NSObject {
    
    static let sharedInstance = ApiCall()
    var alamoFireManager : Alamofire.SessionManager!
    var backgroundCompletionHandler:(()->Void)?{
        get{
            return alamoFireManager.backgroundCompletionHandler
        }
        set{
            alamoFireManager.backgroundCompletionHandler = newValue
        }
    }
    override init() {
        
    }
    func fetchSongs(_ callback: @escaping ([Song]?, Error?) -> Void) {
        guard let url = URL.init(string: "https://www.jasonbase.com/things/zKWW.json") else{
            callback(nil, nil)
            return
        }
        
        Alamofire.request(url, method: .get, parameters: nil, encoding:URLEncoding.default, headers: nil)
            .responseJSON(completionHandler: {response in
                if response.result.isSuccess{
                    guard let data = response.data else{
                        callback(nil, response.error)
                        return
                    }
                    
                    
                    do{
                        let songObject = try JSONDecoder().decode(SongObject.self, from: data)
                        callback(songObject.songs, nil)
                        
                    }
                    catch{
                        callback(nil, error)
                    }
                    
                }else{
                    callback(nil, response.error)
                }
                
            })
        
    }
    
//    func downLoadSong(with url:URL){
//        let configuration = URLSessionConfiguration.background(withIdentifier: "background")
//        self.alamoFireManager = Alamofire.SessionManager(configuration: configuration)
//
//        self.alamoFireManager.download(<#T##url: URLConvertible##URLConvertible#>, method: <#T##HTTPMethod#>, parameters: <#T##Parameters?#>, encoding: <#T##ParameterEncoding#>, headers: <#T##HTTPHeaders?#>, to: <#T##DownloadRequest.DownloadFileDestination?##DownloadRequest.DownloadFileDestination?##(URL, HTTPURLResponse) -> (destinationURL: URL, options: DownloadRequest.DownloadOptions)#>)
//        self.alamoFireManager.download(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, to: nil)
//            .downloadProgress(closure: {progress in
//                
//                print(progress)
//            })
//            .response(completionHandler: {dowanloadResponse in
//                debugPrint(dowanloadResponse.temporaryURL)
//            })
//
//        self.alamoFireManager.backgroundCompletionHandler = {
//
//        }
//    }
    
}















