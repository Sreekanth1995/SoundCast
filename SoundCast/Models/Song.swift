//
//  Song.swift
//  SoundCast
//
//  Created by M sreekanth  on 09/08/18.
//  Copyright © 2018 Green Bird IT Services. All rights reserved.
//

import UIKit

struct Song:Decodable{
    
    var id:Int?
    var title:String?
    var link:String?
    var thumbnail:String?
}

struct SongObject:Decodable{

    var songs:[Song]?
}


