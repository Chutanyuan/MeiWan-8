//
//  UserConnector.swift
//  Liuwei
//
//  Created by mac on 15/8/27.
//  Copyright (c) 2015年 mac. All rights reserved.
//
//
//  UserConnector.swift
//  Liuwei
//
//  Created by mac on 15/8/27.
//  Copyright (c) 2015年 mac. All rights reserved.
//

import UIKit


@objc public class UserConnector: NSObject {
    
    
    private static var userUrl=setting.getIp()+"peiwan-server/rest/users/"
    private static var orderUrl=setting.getIp()+"peiwan-server/rest/orders/"
    
    
    public static func acceptInvalidSSLCerts() {
        let manager = Manager.sharedInstance
        
        manager.delegate.sessionDidReceiveChallenge = { session, challenge in
            var disposition: NSURLSessionAuthChallengeDisposition = .PerformDefaultHandling
            var credential: NSURLCredential?
            if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
                disposition = NSURLSessionAuthChallengeDisposition.UseCredential
                credential = NSURLCredential(forTrust: challenge.protectionSpace.serverTrust!)
            } else {
                if challenge.previousFailureCount > 0 {
                    disposition = .CancelAuthenticationChallenge
                } else {
                    credential = manager.session.configuration.URLCredentialStorage?.defaultCredentialForProtectionSpace(challenge.protectionSpace)
                    if credential != nil {
                        disposition = .UseCredential
                    }
                }
            }
            return (disposition, credential)
        }
    }
    
    //登陆
    public static func login(username:String,password:String,receiver:(data:NSData?,error:NSError?)->()){
        
        
        request(.GET, userUrl+"login", parameters:["username":username,"password":password])
            .response { request, response, data, error in
                if (error==nil){
                    
                }else{
                    setting .adjustIps()
                    userUrl = setting.getIp()+"peiwan-server/rest/users/"
                }
                
                receiver(data:data!, error:error)
        }
    }
    
    //更新资料
    public static func update(session:String?,parameters:NSDictionary,receiver:(data:NSData?,error:NSError?)->()){
        if(session != nil){
            parameters.setValue(session,forKey:"session")
        }
        request(.GET, userUrl+"update", parameters:parameters as? [String : AnyObject])
            .response { request, r, data, error in
                
                if (error==nil){
                    
                }else{
                    setting .adjustIps()
                    userUrl = setting.getIp()+"peiwan-server/rest/users/"
                }
                
                receiver(data:data!, error:error)
        }
    }
    
    //根据条件查找陪玩
    public static func aroundPeiwan(session:String?,gender:NSNumber?,minPrice:NSNumber?,maxPrice:NSNumber?,isWin:NSNumber?,offset:Int,limit:Int,isRecommend:NSNumber?,mode:NSNumber?,tagIndex:NSNumber?,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        if(session != nil){
            parameters["session"]=session
        }
        if(gender != nil){
            parameters["gender"]=gender
        }
        if(minPrice != nil){
            parameters["minPrice"]=minPrice
        }
        if(maxPrice != nil){
            parameters["maxPrice"]=maxPrice
        }
        if(isWin != nil){
            parameters["isWin"]=isWin
        }
        if(tagIndex != nil){
            parameters["tagIndex"]=tagIndex
        }
        parameters["offset"]=offset
        parameters["limit"]=limit
        if(isRecommend != nil){
            parameters["isRecommend"]=isRecommend
        }
        if(mode != nil){
            parameters["mode"]=mode
        }
        request(.GET, userUrl+"aroundPeiwan", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                
                if (error==nil){
                    
                }else{
                    setting .adjustIps()
                    userUrl = setting.getIp()+"peiwan-server/rest/users/"
                }
                
                receiver(data:data!.gunzippedData(), error:error)
                
                
        }
    }
    
    //注册用户
    public static func register(username:String!,password:String!,verifyCode:String!,nickname:String!,gender:NSNumber!,year:NSNumber!,month:NSNumber!,day:NSNumber!,headUrl:String!,city:String!,district:String!,deviceType:NSNumber!,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        if(username != nil){
            parameters["username"]=username
        }
        if(password != nil){
            parameters["password"]=password
        }
        if(verifyCode != nil){
            parameters["verifyCode"]=verifyCode
        }
        if(nickname != nil){
            parameters["nickname"]=nickname
        }
        if(gender != nil){
            parameters["gender"]=gender
        }
        if(year != nil){
            parameters["year"]=year
        }
        if(month != nil){
            parameters["month"]=month
        }
        if(day != nil){
            parameters["day"]=day
        }
        if(headUrl != nil){
            parameters["headUrl"]=headUrl
        }
        if(city != nil){
            parameters["city"]=city
        }
        if(district != nil){
            parameters["district"]=district
        }
        if (deviceType != nil) {
            parameters["deviceType"] = deviceType
        }
        request(.GET, userUrl+"register", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                
                if (error==nil){
                    
                }else{
                    setting .adjustIps()
                    userUrl = setting.getIp()+"peiwan-server/rest/users/"
                }
                
                receiver(data:data, error:error)
        }
    }
    
    //通过ID寻找陪玩
    public static func findPeiwanById(session:String?,userId:NSNumber!,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        if(session != nil){
            parameters["session"]=session
        }
        if(userId != nil) {
            parameters["userId"]=userId
        }
        request(.GET, userUrl+"findPeiwanById", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                
                if (error==nil){
                    
                }else{
                    setting .adjustIps()
                    userUrl = setting.getIp()+"peiwan-server/rest/users/"
                }
                
                receiver(data:data, error:error)
        }
    }
    
    
    //寻找游戏角色
    public static func findRoles(userId:NSNumber!,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        if (userId != nil) {
            parameters["userId"]=userId
        }
        request(.GET, userUrl+"findRoles", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                
                if (error==nil){
                    
                }else{
                    setting .adjustIps()
                    userUrl = setting.getIp()+"peiwan-server/rest/users/"
                }
                
                receiver(data:data, error:error)
        }
    }
    
    //查询订单评价
    public static func findOrderEvaluationByUserId(peiwanId:NSNumber!,offset:NSNumber!,limit:NSNumber!,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        if (peiwanId != nil) {
            parameters["peiwanId"]=peiwanId
        }
        if (offset != nil) {
            parameters["offset"]=offset
        }
        if (limit != nil) {
            parameters["limit"]=limit
        }
        request(.GET, userUrl+"findOrderEvaluationByUserId2", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                
                if (error==nil){
                    
                }else{
                    setting .adjustIps()
                    userUrl = setting.getIp()+"peiwan-server/rest/users/"
                }
                
                receiver(data:data!.gunzippedData(), error:error)
        }
    }
    
    //查询常去网吧
    public static func peiwanNetbars(peiwanId:NSNumber!,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        if (peiwanId != nil) {
            parameters["peiwanId"]=peiwanId
        }
        request(.GET,userUrl+"peiwanNetbars", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                
                if (error==nil){
                    
                }else{
                    setting .adjustIps()
                    userUrl = setting.getIp()+"peiwan-server/rest/users/"
                }
                
                receiver(data:data, error:error)
        }
    }
    
    //发送验证码（注册）
    public static func sendCode(phone:String!,sign:String!,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        
        if (phone != nil) {
            parameters["phone"]=phone
        }
        if (sign != nil) {
            parameters["sign"]=sign
        }
        
        request(.GET, userUrl+"sendCode", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                
                if (error==nil){
                    
                }else{
                    setting .adjustIps()
                    userUrl = setting.getIp()+"peiwan-server/rest/users/"
                }
                
                receiver(data:data, error:error)
        }
    }
    
    //发送验证码（找回密码）
    public static func sendCode2(phone:String!,sign:String!,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        if (phone != nil) {
            parameters["phone"]=phone
        }
        if (sign != nil) {
            parameters["sign"]=sign
        }
        
        request(.GET, userUrl+"sendCode2", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                
                if (error==nil){
                    
                }else{
                    setting .adjustIps()
                    userUrl = setting.getIp()+"peiwan-server/rest/users/"
                }
                
                receiver(data:data, error:error)
        }
    }
    
    //查找好友列表
    public static func findMyFriends(session:String!,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        if (session != nil) {
            parameters["session"]=session
        }
        
        request(.GET, userUrl+"findMyFriends", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                
                if (error==nil){
                    
                }else{
                    setting .adjustIps()
                    userUrl = setting.getIp()+"peiwan-server/rest/users/"
                }
                
                receiver(data:data, error:error)
        }
    }
    
    //添加好友
    public static func addFriend(session:String!,friendId:NSNumber!,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        if (session != nil) {
            parameters["session"]=session
        }
        if (friendId != nil) {
            parameters["friendId"]=friendId
        }
        request(.GET,userUrl+"addFriend", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                
                if (error==nil){
                    
                }else{
                    setting .adjustIps()
                    userUrl = setting.getIp()+"peiwan-server/rest/users/"
                }
                
                receiver(data:data, error:error)
        }
    }
    
    //删除好友
    public static func deleteFriend(session:String!,friendId:NSNumber!,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        if (session != nil) {
            parameters["session"]=session
        }
        if (friendId != nil) {
            parameters["friendId"]=friendId
        }
        
        request(.GET, userUrl+"deleteFriend", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                
                if (error==nil){
                    
                }else{
                    setting .adjustIps()
                    userUrl = setting.getIp()+"peiwan-server/rest/users/"
                }
                
                receiver(data:data, error:error)
        }
    }
    
    //投诉
    public static func accusation(session:String!,peiwanId:NSNumber!,contentIndex:NSNumber!,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        if (session != nil) {
            parameters["session"]=session
        }
        if (peiwanId != nil) {
            parameters["peiwanId"]=peiwanId
        }
        if (contentIndex != nil) {
            parameters["contentIndex"]=contentIndex
        }
        
        request(.GET, userUrl+"accusation", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                
                if (error==nil){
                    
                }else{
                    setting .adjustIps()
                    userUrl = setting.getIp()+"peiwan-server/rest/users/"
                }
                
                receiver(data:data, error:error)
        }
    }
    
    //查询网吧图片
    public static func findNetbarPhoto(netbarId:NSNumber!,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        if (netbarId != nil) {
            parameters["netbarId"]=netbarId
        }
        
        request(.GET, userUrl+"findNetbarPhoto", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                
                if (error==nil){
                    
                }else{
                    setting .adjustIps()
                    userUrl = setting.getIp()+"peiwan-server/rest/users/"
                }
                
                receiver(data:data, error:error)
        }
    }
    
    //添加游戏角色
    public static func addRole(session:String!,part:String!,name:String!,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        if (session != nil) {
            parameters["session"]=session
        }
        
        if (part != nil) {
            parameters["part"]=part
        }
        
        if (name != nil) {
            parameters["name"]=name
        }
        
        request(.GET, userUrl+"addRole", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                
                if (error==nil){
                    
                }else{
                    setting .adjustIps()
                    userUrl = setting.getIp()+"peiwan-server/rest/users/"
                }
                
                receiver(data:data, error:error)
        }
    }
    
    //删除游戏角色
    public static func deleteRole(session:String!,lolRoleId:NSNumber!,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        if (session != nil) {
            parameters["session"]=session
        }
        if (lolRoleId != nil) {
            parameters["lolRoleId"]=lolRoleId
        }
        
        request(.GET,userUrl+"deleteRole", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                
                if (error==nil){
                    
                }else{
                    setting .adjustIps()
                    userUrl = setting.getIp()+"peiwan-server/rest/users/"
                }
                
                receiver(data:data, error:error)
        }
    }
    
    //我的动态
    public static func findStates(session:String!, userId:NSNumber!,offset:NSNumber!,limit:NSNumber!,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        if (session != nil) {
            parameters["session"] = session
        }
        if (userId != nil) {
            parameters["userId"]=userId
        }
        if (offset != nil) {
            parameters["offset"]=offset
        }
        if (limit != nil) {
            parameters["limit"]=limit
        }
        
        request(.GET, userUrl+"findStates2", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                
                if (error==nil){
                    
                }else{
                    setting .adjustIps()
                    userUrl = setting.getIp()+"peiwan-server/rest/users/"
                }
                
                receiver(data:data!.gunzippedData(), error:error)
        }
    }
    
    //附近动态
    public static func findAroundStates(session:String!,offset:NSNumber!,limit:NSNumber!,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        if (session != nil) {
            parameters["session"] = session
        }
        if (offset != nil) {
            parameters["offset"]=offset
        }
        if (limit != nil) {
            parameters["limit"]=limit
        }
        request(.GET, userUrl+"findAroundStates", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                
                if (error==nil){
                    
                }else{
                    setting .adjustIps()
                    userUrl = setting.getIp()+"peiwan-server/rest/users/"
                }
                
                receiver(data:data!.gunzippedData(), error:error)
        }
    }
    
    //加入动态评论
    public static func insertStateComment(session:String!,toId:NSNumber!,content:String!,stateId:NSNumber!,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        if (session != nil) {
            parameters["session"] = session
        }
        if (toId != nil) {
            parameters["toId"]=toId
        }
        if (content != nil) {
            parameters["content"]=content
        }
        if (stateId != nil) {
            parameters["stateId"]=stateId
        }
        
        request(.GET, userUrl+"insertStateComment", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                
                if (error==nil){
                    
                }else{
                    setting .adjustIps()
                    userUrl = setting.getIp()+"peiwan-server/rest/users/"
                }
                
                receiver(data:data, error:error)
        }
    }
    
    //插入评论回复
    public static func insertStateReplay(session:String!,toId:NSNumber!,content:String!,stateCommentId:NSNumber!,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        
        if (session != nil) {
            parameters["session"] = session
        }
        if (toId != nil) {
            parameters["toId"]=toId
        }
        if (content != nil) {
            parameters["content"]=content
        }
        if (stateCommentId != nil) {
            parameters["stateCommentId"]=stateCommentId
        }
        
        
        request(.GET, userUrl+"insertStateReplay", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                
                if (error==nil){
                    
                }else{
                    setting .adjustIps()
                    userUrl = setting.getIp()+"peiwan-server/rest/users/"
                }
                
                receiver(data:data, error:error)
        }
    }
    
    //全部动态评论
    public static func findStateComment(session:String!,stateId:NSNumber!,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        
        if (session != nil) {
            parameters["session"] = session
        }
        if (stateId != nil) {
            parameters["stateId"]=stateId
        }
        request(.GET,userUrl+"findStateComment", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                
                if (error==nil){
                    
                }else{
                    setting .adjustIps()
                    userUrl = setting.getIp()+"peiwan-server/rest/users/"
                }
                
                receiver(data:data!.gunzippedData(), error:error)
        }
    }
    
    //发表动态
    public static func insertState(session:String!,content:String!,statePhotos:String!,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        
        if (session != nil) {
            parameters["session"] = session
        }
        if (content != nil) {
            parameters["content"]=content
        }
        if (statePhotos != nil) {
            parameters["statePhotos"] = statePhotos
        }
        
        request(.GET, userUrl+"insertState", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                
                if (error==nil){
                    
                }else{
                    setting .adjustIps()
                    userUrl = setting.getIp()+"peiwan-server/rest/users/"
                }
                
                receiver(data:data, error:error)
        }
    }
    
    //删除动态
    public static func deleteState(session:String!,stateId:NSNumber!,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        if (session != nil) {
            parameters["session"] = session
        }
        if (stateId != nil) {
            parameters["stateId"]=stateId
        }
        request(.GET,userUrl+"deleteState", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                
                if (error==nil){
                    
                }else{
                    setting .adjustIps()
                    userUrl = setting.getIp()+"peiwan-server/rest/users/"
                }
                
                receiver(data:data, error:error)
        }
    }
    
    //点赞
    public static func likeUserState(session:String!,toId:NSNumber!,stateId:NSNumber!,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        if (session != nil) {
            parameters["session"] = session
        }
        if (stateId != nil) {
            parameters["stateId"]=stateId
        }
        if (toId != nil) {
            parameters["toId"]=toId
        }
        request(.GET, userUrl+"likeUserState",parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                
                if (error==nil){
                    
                }else{
                    setting .adjustIps()
                    userUrl = setting.getIp()+"peiwan-server/rest/users/"
                }
                
                receiver(data:data, error:error)
        }
    }
    
    //取消点赞
    public static func unlikeUserState(session:String!,toId:NSNumber!,stateId:NSNumber!,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        if (session != nil) {
            parameters["session"] = session
        }
        if (stateId != nil) {
            parameters["stateId"]=stateId
        }
        if (toId != nil) {
            parameters["toId"]=toId
        }
        
        request(.GET, userUrl+"unlikeUserState",parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                
                if (error==nil){
                    
                }else{
                    setting .adjustIps()
                    userUrl = setting.getIp()+"peiwan-server/rest/users/"
                }
                
                receiver(data:data, error:error)
        }
    }
    
    //用户标签
    public static func findUserTags(userId:NSNumber!,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        if (userId != nil) {
            parameters["userId"] = userId
        }
        
        
        request(.GET, userUrl+"findUserTags", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                
                if (error==nil){
                    
                }else{
                    setting .adjustIps()
                    userUrl = setting.getIp()+"peiwan-server/rest/users/"
                }
                
                receiver(data:data!.gunzippedData(), error:error)
        }
    }
    
    //排行榜
    public static func rankUsers(session:String!,offset:NSNumber!,limit:NSNumber!,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        if (session != nil) {
            parameters["session"] = session
        }
        if (offset != nil) {
            parameters["offset"]=offset
        }
        if (limit != nil) {
            parameters["limit"]=limit
        }
        request(.GET, userUrl+"rankUsers", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                
                if (error==nil){
                    
                }else{
                    setting .adjustIps()
                    userUrl = setting.getIp()+"peiwan-server/rest/users/"
                }
                
                receiver(data:data!.gunzippedData(), error:error)
        }
    }
    
    //提交陪玩申请
    public static func createPeiwanForm(session:String!,phone:String!,gameName:String!,gameNickname:String!,headPhoto:String!,idPhoto:String!,address:String!,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        if (session != nil) {
            parameters["session"] = session
        }
        if (phone != nil) {
            parameters["phone"]=phone
        }
        if (gameName != nil) {
            parameters["gameName"]=gameName
        }
        if (gameNickname != nil) {
            parameters["gameNickname"] = gameNickname
        }
        if (headPhoto != nil) {
            parameters["headPhoto"]=headPhoto
        }
        if (address != nil) {
            parameters["address"]=address
        }
        if (idPhoto != nil) {
            parameters["idPhoto"] = idPhoto
        }
        
        request(.GET, userUrl+"createPeiwanForm", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                
                if (error==nil){
                    
                }else{
                    setting .adjustIps()
                    userUrl = setting.getIp()+"peiwan-server/rest/users/"
                }
                
                receiver(data:data, error:error)
        }
    }
    
    //通过名称查询网吧
    public static func findNetbarLikeName(name:String!,offset:NSNumber!,limit:NSNumber!,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        if (name != nil) {
            parameters["name"] = name
        }
        if (offset != nil) {
            parameters["offset"]=offset
        }
        if (limit != nil) {
            parameters["limit"]=limit
        }
        
        request(.GET, userUrl+"findNetbarLikeName", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                
                if (error==nil){
                    
                }else{
                    setting .adjustIps()
                    userUrl = setting.getIp()+"peiwan-server/rest/users/"
                }
                
                receiver(data:data, error:error)
        }
    }
    
    //我的订单
    public static func myOrders(session:String!,offset:NSNumber!,limit:NSNumber!,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        if (session != nil) {
            parameters["session"] = session
        }
        if (offset != nil) {
            parameters["offset"]=offset
        }
        if (limit != nil) {
            parameters["limit"]=limit
        }
        
        request(.GET, orderUrl+"myOrders", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                
                if (error==nil){
                    
                }else{
                    setting .adjustIps()
                    orderUrl=setting.getIp()+"peiwan-server/rest/orders/"
                }
                
                receiver(data:data!.gunzippedData(), error:error)
        }
    }
    
    //接受邀请
    public static func acceptOrder(session:String!,orderId:NSNumber!,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        if (session != nil) {
            parameters["session"] = session
        }
        if (orderId != nil) {
            parameters["orderId"]=orderId
        }
        
        request(.GET, orderUrl+"acceptOrder", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                
                if (error==nil){
                    
                }else{
                    setting .adjustIps()
                    orderUrl=setting.getIp()+"peiwan-server/rest/orders/"
                }
                
                receiver(data:data, error:error)
        }
    }
    
    //邀请我的
    public static func inviteMeOrders(session:String!,offset:NSNumber!,limit:NSNumber!,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        if (session != nil) {
            parameters["session"] = session
        }
        if (offset != nil) {
            parameters["offset"]=offset
        }
        if (limit != nil) {
            parameters["limit"]=limit
        }
        
        request(.GET, orderUrl+"inviteMeOrders", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                
                if (error==nil){
                    
                }else{
                    setting .adjustIps()
                    orderUrl=setting.getIp()+"peiwan-server/rest/orders/"
                }
                
                receiver(data:data!.gunzippedData(), error:error)
        }
    }
    
    //完成订单
    public static func orderOk(session:String!,orderId:NSNumber!,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        if (session != nil) {
            parameters["session"] = session
        }
        if (orderId != nil) {
            parameters["orderId"]=orderId
        }
        request(.GET, orderUrl+"orderOk", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                
                if (error==nil){
                    
                }else{
                    setting .adjustIps()
                    orderUrl=setting.getIp()+"peiwan-server/rest/orders/"
                }
                
                receiver(data:data, error:error)
        }
    }
    
    //订单投诉
    public static func sendComplain(session:String!,orderId:NSNumber!,title:String?,content:String?,photos:String?,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        if (session != nil) {
            parameters["session"] = session
        }
        if (orderId != nil) {
            parameters["orderId"]=orderId
        }
        if (title != nil) {
            parameters["title"]=title
        }
        if (content != nil) {
            parameters["content"]=content
        }
        if (photos != nil) {
            parameters["photos"]=photos
        }
        
        request(.GET, orderUrl+"sendComplain", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                
                if (error==nil){
                    
                }else{
                    setting .adjustIps()
                    orderUrl=setting.getIp()+"peiwan-server/rest/orders/"
                }
                
                receiver(data:data, error:error)
        }
    }
    
    //订单评价
    public static func evaluationOrder(session:String!,orderId:NSNumber!,peiwanId:NSNumber!,point:NSNumber!,tagIndexs:String!,content:String?,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        
        if (session != nil) {
            parameters["session"] = session
        }
        if (orderId != nil) {
            parameters["orderId"]=orderId
        }
        if (peiwanId != nil) {
            parameters["peiwanId"]=peiwanId
        }
        if (point != nil) {
            parameters["point"]=point
        }
        if (tagIndexs != nil) {
            parameters["tagIndexs"]=tagIndexs
        }
        if (content != nil) {
            parameters["content"]=content
        }
        
        request(.GET, orderUrl+"evaluationOrder", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                
                if (error==nil){
                    
                }else{
                    setting .adjustIps()
                    orderUrl=setting.getIp()+"peiwan-server/rest/orders/"
                }
                
                receiver(data:data, error:error)
        }
    }
    
    //申请提现
    public static func createCashRequest(session:String!,money:NSNumber!,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        if (session != nil) {
            parameters["session"]=session
        }
        if (money != nil) {
            parameters["money"]=money
        }
        
        request(.GET, userUrl+"createCashRequest", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                
                if (error==nil){
                    
                }else{
                    setting .adjustIps()
                    userUrl = setting.getIp()+"peiwan-server/rest/users/"
                }
                
                receiver(data:data!.gunzippedData(), error:error)
        }
    }
    
    //查询提现列表
    public static func myCashRequests(session:String!,offset:NSNumber!,limit:NSNumber!,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        if (session != nil) {
            parameters["session"] = session
        }
        if (offset != nil) {
            parameters["offset"]=offset
        }
        if (limit != nil) {
            parameters["limit"]=limit
        }
        
        request(.GET, userUrl+"myCashRequests", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                
                if (error==nil){
                    
                }else{
                    setting .adjustIps()
                    userUrl = setting.getIp()+"peiwan-server/rest/users/"
                }
                
                receiver(data:data!.gunzippedData(), error:error)
        }
    }
    
    //重设密码
    public static func resetPwd(username:String!,password:String!,verifyCode:String!,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        if (username != nil) {
            parameters["username"] = username
        }
        if (password != nil) {
            parameters["password"]=password
        }
        if (verifyCode != nil) {
            parameters["verifyCode"]=verifyCode
        }
        
        request(.GET, userUrl+"resetPassword", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                
                if (error==nil){
                    
                }else{
                    setting .adjustIps()
                    userUrl = setting.getIp()+"peiwan-server/rest/users/"
                }
                
                receiver(data:data, error:error)
        }
    }
    
    //添加标签
    public static func addUserTimeTag(session:String!,tagIndex:NSNumber!,price:NSNumber!,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        if (session != nil) {
            parameters["session"] = session
        }
        if (tagIndex != nil) {
            parameters["tagIndex"]=tagIndex
        }
        if (price != nil) {
            parameters["price"]=price
        }
        
        request(.GET, userUrl+"addUserTimeTag", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                
                if (error==nil){
                    
                }else{
                    setting .adjustIps()
                    userUrl = setting.getIp()+"peiwan-server/rest/users/"
                }
                
                receiver(data:data!.gunzippedData(), error:error)
        }
    }
    
    //删除标签
    public static func deleteUserTimeTag(session:String!,tagIndex:NSNumber!,price:NSNumber!,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        
        if (session != nil) {
            parameters["session"] = session
        }
        if (tagIndex != nil) {
            parameters["tagIndex"]=tagIndex
        }
        if (price != nil) {
            parameters["price"]=price
        }
        
        request(.GET, userUrl+"deleteUserTimeTag", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                
                if (error==nil){
                    
                }else{
                    setting .adjustIps()
                    userUrl = setting.getIp()+"peiwan-server/rest/users/"
                }
                
                receiver(data:data!.gunzippedData(), error:error)
        }
    }
    
    //获取用户动态 粉丝 关注数量
    public static func getLoginedUser(session:String!,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        if (session != nil) {
            parameters["session"]=session
        }
        request(.GET, userUrl+"findMyInfo", parameters:parameters as? [String : NSObject])
            
            .response { request, r, data, error in
                
                if (error==nil){
                    
                }else{
                    setting .adjustIps()
                    userUrl = setting.getIp()+"peiwan-server/rest/users/"
                }
                
                receiver(data:data!.gunzippedData(), error:error)
        }
    }
    /**直接充值*/
    public static func aliRechargeSigh(session:String!,price:NSNumber!,receiver:(data:NSData?,error:NSError?)->()){
        
        var parameters:Dictionary<String,AnyObject> = [:]
        
        if(session != nil){
            parameters["session"]=session
        }
        if(price != nil){
            parameters["price"]=price
        }
        
        request(.GET, orderUrl+"aliRechargeSigh", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                
                if (error==nil){
                    
                }else{
                    setting .adjustIps()
                    orderUrl=setting.getIp()+"peiwan-server/rest/orders/"
                }
                
                receiver(data:data, error:error)
        }
        
        
    }
    
    /** 微信充值 */
    public static func wxRechargeSigh(session:String!,price:NSNumber!,receiver:(data:NSData?,error:NSError?)->()){
        
        var parameters:Dictionary<String,AnyObject> = [:]
        
        if(session != nil){
            parameters["session"]=session
        }
        if(price != nil){
            parameters["price"]=price
        }
        
        request(.GET, orderUrl+"wxRechargeSigh", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                
                if (error==nil){
                    
                }else{
                    setting .adjustIps()
                    orderUrl=setting.getIp()+"peiwan-server/rest/orders/"
                }
                
                receiver(data:data, error:error)
        }
        
        
    }

    /**余额支付*/
    public static func payWithAccountMoney(session:String!,peiwanId:NSNumber!,price:NSNumber!,hours:NSNumber!,tagIndex:NSNumber!,carFee:NSNumber!,userUnionId:NSNumber!,peiwanUnionId:NSNumber!,receiver:(data:NSData?,error:NSError?)->()){
        
        var parameters:Dictionary<String,AnyObject> = [:]
        
        if(session != nil){
            parameters["session"]=session
        }
        if(peiwanId != nil){
            parameters["peiwanId"]=peiwanId
        }
        if(price != nil){
            parameters["price"]=price
        }
        if(hours != nil){
            parameters["hours"]=hours
        }
        if(tagIndex != nil){
            parameters["tagIndex"]=tagIndex
        }
        if(carFee != nil){
            parameters["carFee"]=carFee
        }
        if(userUnionId != nil){
            parameters["userUnionId"]=userUnionId
        }
        if(peiwanUnionId != nil){
            parameters["peiwanUnionId"]=peiwanUnionId
        }
        request(.GET, orderUrl+"payWithAccountMoney", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                
                if (error==nil){
                    
                }else{
                    setting .adjustIps()
                    orderUrl=setting.getIp()+"peiwan-server/rest/orders/"
                }
                
                receiver(data:data!, error:error)
        }
        
        
    }
    /**支付宝支付*/
    public static func aliOrderSign(session:String!,peiwanId:NSNumber!,price:NSNumber!,hours:NSNumber!,tagIndex:NSNumber!,carFee:NSNumber!,userUnionId:NSNumber!,peiwanUnionId:NSNumber!,receiver:(data:NSData?,error:NSError?)->()){
        
        var parameters:Dictionary<String,AnyObject> = [:]
        
        if(session != nil){
            parameters["session"]=session
        }
        if(peiwanId != nil){
            parameters["peiwanId"]=peiwanId
        }
        if(price != nil){
            parameters["price"]=price
        }
        if(hours != nil){
            parameters["hours"]=hours
        }
        if(tagIndex != nil){
            parameters["tagIndex"]=tagIndex
        }
        if(carFee != nil){
            parameters["carFee"]=carFee
        }
        if(userUnionId != nil){
            parameters["userUnionId"]=userUnionId
        }
        if(peiwanUnionId != nil){
            parameters["peiwanUnionId"]=peiwanUnionId
        }
        request(.GET, orderUrl+"aliOrderSign", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                
                if (error==nil){
                    
                }else{
                    setting .adjustIps()
                    orderUrl=setting.getIp()+"peiwan-server/rest/orders/"
                }
                
                receiver(data:data!.gunzippedData(), error:error)
        }
        
        
    }
    
    
    
    /**微信支付*/
    public static func wxOrderSign(session:String!,peiwanId:NSNumber!,price:NSNumber!,hours:NSNumber!,tagIndex:NSNumber!,carFee:NSNumber!,userUnionId:NSNumber!,peiwanUnionId:NSNumber!,receiver:(data:NSData?,error:NSError?)->()){
        
        var parameters:Dictionary<String,AnyObject> = [:]
        
        if(session != nil){
            parameters["session"]=session
        }
        if(peiwanId != nil){
            parameters["peiwanId"]=peiwanId
        }
        if(price != nil){
            parameters["price"]=price
        }
        if(hours != nil){
            parameters["hours"]=hours
        }
        if(tagIndex != nil){
            parameters["tagIndex"]=tagIndex
        }
        if(carFee != nil){
            parameters["carFee"]=carFee
        }
        if(userUnionId != nil){
            parameters["userUnionId"]=userUnionId
        }
        if(peiwanUnionId != nil){
            parameters["peiwanUnionId"]=peiwanUnionId
        }
        request(.GET, orderUrl+"wxOrderSign", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                
                if (error==nil){
                    
                }else{
                    setting .adjustIps()
                    orderUrl=setting.getIp()+"peiwan-server/rest/orders/"
                }
                
                receiver(data:data!.gunzippedData(), error:error)
        }
        
        
    }

    
    
    //查找关注列表
    public static func findMyFocus(session:String!,offset:Int,limit:Int,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        if (session != nil) {
            parameters["session"]=session
        }
        parameters["offset"]=offset
        parameters["limit"]=limit
        
        request(.GET, userUrl+"findFollowersByUserId", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                if (error==nil){
                    
                }else{
                    setting .adjustIps()
                    userUrl = setting.getIp()+"peiwan-server/rest/users/"
                }
                
                receiver(data:data!.gunzippedData(), error:error)
        }
    }
    
    //创建工会
    public static func createUnion(session:String!,name:String!,headUrl:String!, receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        if(session != nil){
            parameters["session"]=session
        }
        if (name != nil) {
            parameters["name"]=name;
        }
        if (headUrl != nil) {
            parameters["headUrl"]=headUrl;
        }
        request(.GET, userUrl+"createUnion", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                
                if (error==nil){
                    
                }else{
                    setting .adjustIps()
                    userUrl = setting.getIp()+"peiwan-server/rest/users/"
                }
                
                receiver(data:data!, error:error)
        }
    }
    
    //查找工会
    public static func findMyUnion(session:String!,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        if (session != nil) {
            parameters["session"]=session
        }
        request(.GET, userUrl+"findMyUnion", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                if (error==nil){
                    
                }else{
                    setting .adjustIps()
                    userUrl = setting.getIp()+"peiwan-server/rest/users/"
                }
                
                receiver(data:data!.gunzippedData(), error:error)
        }
    }
    
    /**公会成员*/
    public static func findMyUnionMembers(session:String?,offset:Int,limit:Int,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        if(session != nil){
            parameters["session"]=session
        }
        parameters["offset"]=offset
        parameters["limit"]=limit
        
        request(.GET, userUrl+"findMyUnionMembers", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                
                if (error==nil){
                    
                }else{
                    setting .adjustIps()
                    userUrl = setting.getIp()+"peiwan-server/rest/users/"
                }
                
                receiver(data:data!.gunzippedData(), error:error)
                
                
        }
    }
    /**达人*/
    public static func findMyUnionDarens(session:String?,offset:Int,limit:Int,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        if(session != nil){
            parameters["session"]=session
        }
        parameters["offset"]=offset
        parameters["limit"]=limit
        
        request(.GET, userUrl+"findMyUnionDarens", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                
                if (error==nil){
                    
                }else{
                    setting .adjustIps()
                    userUrl = setting.getIp()+"peiwan-server/rest/users/"
                }
                
                receiver(data:data!.gunzippedData(), error:error)
                
                
        }
    }
    /**子公会*/
    public static func findMySubUnions(session:String?,offset:Int,limit:Int,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        if(session != nil){
            parameters["session"]=session
        }
        parameters["offset"]=offset
        parameters["limit"]=limit
        
        request(.GET, userUrl+"findMySubUnions", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                
                if (error==nil){
                    
                }else{
                    setting .adjustIps()
                    userUrl = setting.getIp()+"peiwan-server/rest/users/"
                }
                
                receiver(data:data!.gunzippedData(), error:error)
                
                
        }
    }
    
    /**公会排行榜*/
    public static func findUnionsRank(offset:Int,limit:Int,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        
        parameters["offset"]=offset
        parameters["limit"]=limit
        
        request(.GET, userUrl+"findUnionsRank", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                
                if (error==nil){
                    
                }else{
                    setting .adjustIps()
                    userUrl = setting.getIp()+"peiwan-server/rest/users/"
                }
                
                receiver(data:data!.gunzippedData(), error:error)
                
        }
    }
    
    /**隐藏总收益*/
    /**
     isHide 1 隐藏，0不隐藏
     */
    public static func updateUnion(session:String!,isHide:Int,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        if (session != nil) {
            parameters["session"]=session
        }
        parameters["isHide"] = isHide;
        
        request(.GET, userUrl+"updateUnion", parameters:parameters as? [String : NSObject])
            
            .response { request, r, data, error in
                
                if (error==nil){
                    
                }else{
                    setting .adjustIps()
                    userUrl = setting.getIp()+"peiwan-server/rest/users/"
                }
                
                receiver(data:data!, error:error)
                
        }
        
    }
    
    /**公会提现*/
    public static func createUnionCashRequest(session:String!,money:NSNumber!,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        if (session != nil) {
            parameters["session"]=session
        }
        if (money != nil) {
            parameters["money"]=money
        }
        
        request(.GET, userUrl+"createUnionCashRequest", parameters:parameters as? [String : NSObject])
            
            .response { request, r, data, error in
                
                if (error==nil){
                    
                }else{
                    setting .adjustIps()
                    userUrl = setting.getIp()+"peiwan-server/rest/users/"
                }
                
                receiver(data:data!, error:error)
                
        }
        
        
    }
    
    /**公会收益列表*/
    public static func findMyUnionEarn(session:String?,offset:Int,limit:Int,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        if(session != nil){
            parameters["session"]=session
        }
        parameters["offset"]=offset
        parameters["limit"]=limit
        
        request(.GET, userUrl+"findMyUnionEarn", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                
                if (error==nil){
                    
                }else{
                    setting .adjustIps()
                    userUrl = setting.getIp()+"peiwan-server/rest/users/"
                }
                
                receiver(data:data!.gunzippedData(), error:error)
                
                
        }
    }
    /**升级按钮请求*/
    public static func upgradeUnion(session:String?,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        if(session != nil){
            parameters["session"]=session
        }
        request(.GET, userUrl+"upgradeUnion", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                
                if (error==nil){
                    
                }else{
                    setting .adjustIps()
                    userUrl = setting.getIp()+"peiwan-server/rest/users/"
                }
                
                receiver(data:data!, error:error)
        }
        
    }
    
    public static func findShopsByUser(userId:NSNumber!,offset:NSNumber!,limit:NSNumber!,receiver:(data:NSData?,error:NSError?)->()){
        
        var parameters:Dictionary<String,AnyObject> = [:]
        if (userId != nil) {
            parameters["userId"] = userId
        }
        if (offset != nil) {
            parameters["offset"] = offset
        }
        if (limit != nil) {
            parameters["limit"] = limit
        }
        request(.GET, userUrl+"findShopsByUser", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                
                if (error==nil){
                    
                }else{
                    setting .adjustIps()
                    userUrl = setting.getIp()+"peiwan-server/rest/users/"
                }
                
                receiver(data:data!, error:error)
                
                
        }

        
        
    }
    /**
     检查聊天对象和自己de订单联系
     */
    public static func findOrderRelateUser(session:NSString!,userId:NSNumber!,receiver:(data:NSData?,error:NSError?)->()){
        
        var parameters:Dictionary<String,AnyObject> = [:]
        if (session != nil) {
            parameters["session"] = session
        }
        if (userId != nil) {
            parameters["userId"] = userId
        }
        
        request(.GET, orderUrl+"findOrderRelateUser", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                
                if (error==nil){
                    
                }else{
                    setting .adjustIps()
                    orderUrl = setting.getIp()+"peiwan-server/rest/orders/"
                }
                receiver(data:data!, error:error)
        }

    }
    
    /** 拒绝订单 */

    
    public static func rejectOrder(session:String!,orderId:NSNumber!,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        if (session != nil) {
            parameters["session"] = session
        }
        if (orderId != nil) {
            parameters["orderId"]=orderId
        }
        
        request(.GET, orderUrl+"rejectOrder", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                
                if (error==nil){
                    
                }else{
                    setting .adjustIps()
                    orderUrl=setting.getIp()+"peiwan-server/rest/orders/"
                }
                
                receiver(data:data, error:error)
        }
    }
    
    /** 撤回订单 */
    public static func backOrder(session:String!,orderId:NSNumber!,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        if (session != nil) {
            parameters["session"] = session
        }
        if (orderId != nil) {
            parameters["orderId"]=orderId
        }
        
        request(.GET, orderUrl+"backOrder", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                
                if (error==nil){
                    
                }else{
                    setting .adjustIps()
                    orderUrl=setting.getIp()+"peiwan-server/rest/orders/"
                }
                
                receiver(data:data, error:error)
        }
    }

    
    /** 上传图片 */
    public static func updateUserPhoto(session:String!,url:String!,index:NSNumber!,receiver:(data:NSData?,error:NSError?)->()){
        
        
        var parameters:Dictionary<String,AnyObject> = [:]
        if (session != nil) {
            parameters["session"] = session
        }
        if (url != nil) {
            parameters["url"]=url
        }
        if (index != nil) {
            parameters["index"] = index;
        }
        request(.GET, userUrl+"updateUserPhoto", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                
                if (error==nil){
                    
                }else{
                    setting .adjustIps()
                    userUrl=setting.getIp()+"peiwan-server/rest/users/"
                }
                receiver(data:data, error:error)
        }

        
    }
    /** 发现照片 */
    public static func findMyPhotoes(session:String!,receiver:(data:NSData?,error:NSError?)->()){
    
        var parameters:Dictionary<String,AnyObject> = [:]
        if (session != nil) {
            parameters["session"] = session
        }
        request(.GET, userUrl+"findMyPhotoes", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                
                if (error==nil){
                    
                }else{
                    setting .adjustIps()
                    userUrl=setting.getIp()+"peiwan-server/rest/users/"
                }
                receiver(data:data!.gunzippedData(), error:error)
        }
    }
    
    /** 删除照片 */
    public static func deleteUserPhoto(session:String!,userPhotoId:NSNumber!,receiver:(data:NSData?,error:NSError?)->()){
        var parameters:Dictionary<String,AnyObject> = [:]
        if (session != nil) {
            parameters["session"] = session
        }
        if (userPhotoId != nil) {
            parameters["userPhotoId"] = userPhotoId
        }
        request(.GET, userUrl+"deleteUserPhoto", parameters:parameters as? [String : NSObject])
            .response { request, r, data, error in
                
                if (error==nil){
                    
                }else{
                    setting .adjustIps()
                    userUrl=setting.getIp()+"peiwan-server/rest/users/"
                }
                receiver(data:data, error:error)
        }

    
    
    }
}











