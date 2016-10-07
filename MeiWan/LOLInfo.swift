//
//  LOLInfo.swift
//  MeiWan
//
//  Created by apple on 15/8/31.
//  Copyright (c) 2015年 apple. All rights reserved.
//

import UIKit

public class LOLInfo: NSObject {
    public var capacity:String?
    public var level:String?
    public var headUrl:String?
    public var point:String?
    public var rank:String?
    public var winPercent:String?
    public var win:String?
    
    public var recentGames:[LOLGame]=[];
}
