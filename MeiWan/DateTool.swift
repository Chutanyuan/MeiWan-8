//
//  DateTool.swift
//  MeiWan
//
//  Created by apple on 15/8/29.
//  Copyright (c) 2015年 apple. All rights reserved.
//

@objc public class DateTool: NSObject {
    public static func getTimeDescription(time2:Int64)->String{
        let curTime = NSNumber(double: NSDate().timeIntervalSince1970*1000).longLongValue;
        let minute:Int64 = 60*1000
        let hour=60*minute;
        let day=24*hour;
        let month=30*day;
        let year=12*month;
        if(curTime-time2 < 5*minute){
            return "刚刚"
        }else if(curTime-time2 < hour){
            return "\((curTime-time2)/minute)分钟前"
        }else if(curTime-time2 < day){
            return "\((curTime-time2)/hour)小时前"
        }else if(curTime-time2 < month){
            return "\((curTime-time2)/day)天前"
        }else if(curTime-time2 < year){
            return "\((curTime-time2)/month)月前"
        }else{
            return "\((curTime-time2)/year)年前"
        }
    }
}
