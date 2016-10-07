//
//  LOLHelper.swift
//  MeiWan
//
//  Created by apple on 15/8/31.
//  Copyright (c) 2015年 apple. All rights reserved.
//

import UIKit

public class LOLHelper: NSObject {
    public static func queryRoleInfo(name:String!,departion:String!,receiver:(lolInfo:LOLInfo,error:NSError?)->())->(){
        request(.GET, "http://lolbox.duowan.com/playerDetail_baidu.php", parameters:["serverName":departion,"playerName":name])
            .response { request, response, data, error in
                //            var s = NSString(data: data!, encoding: NSUTF8StringEncoding)as String!
                //这里解析你收到的数据
                let doc = Ji(data: data, encoding: NSUTF8StringEncoding, isXML: false);
                let lolInfo=LOLInfo();
                let capacity=doc?.xPath("//div[@class='intro']/*[@class='fighting']/p/em/span")?.first?.value
                lolInfo.capacity=capacity;
                let level = doc?.xPath("//div[@class='intro']/*[@class='avatar']/em")?.first?.value;
                lolInfo.level=level;
                let headUrl = doc?.xPath("//*[@class='avatar']/a/img/@src")?.first?.value;
                lolInfo.headUrl=headUrl;
                let rank = doc?.xPath("//*[@class='mod-tabs-bd J_content'][1]/*[@class='mod-tabs-content hide']/table/tr[2]/td[2]/span")?.first?.value;
                lolInfo.rank=rank;
                let point=doc?.xPath("//*[@class='mod-tabs-bd J_content'][1]/*[@class='mod-tabs-content hide']/table/tr[2]/td[3]")?.first?.value;
                lolInfo.point=point;
                let winPercent=doc?.xPath("//*[@class='mod-tabs-bd J_content'][1]/*[@class='mod-tabs-content hide']/table/tr[2]/td[6]")?.first?.value;
                lolInfo.winPercent=winPercent;
                let win=doc?.xPath("//*[@class='mod-tabs-bd J_content'][1]/*[@class='mod-tabs-content hide']/table/tr[2]/td[7]")?.first?.value;
                lolInfo.win=win;
                var allGameEle=doc?.xPath("//*[@class='recent bd-r fl']/table/tr")?.generate();
                allGameEle?.next();
                var gameEle=allGameEle?.next();
                while(gameEle != nil){
                    let data = gameEle!.rawContent!.dataUsingEncoding(NSUTF8StringEncoding)
                    let doc2=Ji(data: data, encoding: NSUTF8StringEncoding, isXML: false);
                    let lolGame=LOLGame();
                    lolGame.heroName=doc2?.xPath("//html/body/tr/td/img/@title")?.first?.value;
                    lolGame.heroHead=doc2?.xPath("//html/body/tr/td/img/@src")?.first?.value;
                    lolGame.mode=doc2?.xPath("//html/body/tr/td[2]")?.first?.value
                    lolGame.result=doc2?.xPath("//html/body/tr/td[3]/em")?.first?.value
                    lolGame.time=doc2?.xPath("//html/body/tr/td[4]")?.first?.value?.stringByReplacingOccurrencesOfString(" ", withString: "").stringByReplacingOccurrencesOfString("\t", withString: "")
                    gameEle=allGameEle?.next();
                    lolInfo.recentGames.append(lolGame);
                    
                }
                receiver(lolInfo:lolInfo, error:error);
        }
    }
}
