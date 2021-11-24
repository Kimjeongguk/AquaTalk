//
//  UserInfoModel.swift
//  Aqua_Talk
//
//  Created by Jeongguk Kim on 2021/07/11.
//

import UIKit

//struct UserInfo: Codable {
//    let email: String
//    var name: String
////    var password: String
//    var statusMessage: String?
//    var profile: String?
//    var firends: [FriendInfo]?
//    let token: String
//    
//    
//    init(){
//        email="test@emai.com"
//        name = "김정국"
////        password = "testPassword"
//        statusMessage = "test~~~~~"
//        profile = "image"
//        token = "token"
//        firends = [
//            FriendInfo(),
//            FriendInfo(),
//            FriendInfo()
//        ]
//    }
//    mutating func update(name: String,/* password: String,*/ statusMessage: String, profile: String, friends: [FriendInfo]){
//        self.name = name
////        self.password = password
//        self.statusMessage = statusMessage
//        self.profile = profile
//        self.firends = friends
//    }
//    
//    enum CodingKeys: String, CodingKey{
//        case email
//        case name
////        case password
//        case statusMessage
//        case profile
//        case firends
//        case token
//    }
//}
struct LoginResponse: Codable{
    let user: UserInfo
    
    init(){
        user = UserInfo()
    }
    enum CodingKeys: String, CodingKey{
        case user = "user_info"
    }
}
struct UserInfo: Codable {
    let email: String
//    let userid: String
    var name: String
    var statusMessage: String
    let profile: String
//    let token: String
    var friends: [FriendInfo]?
    init(){
        email = "test"
//        userid = ""
        name = "test"
        statusMessage = "test"
        profile = ""
//        token = ""
        friends = [FriendInfo(),FriendInfo(email: "1", name: "1", m: "1", p: "1"),FriendInfo(email: "2", name: "2", m: "2", p: "2")]
    }
    mutating func update(name: String, statusMessage: String){
        self.name = name
        self.statusMessage = statusMessage        
    }
    enum CodingKeys: String, CodingKey {
        case email
//        case userid
        case name = "username"
        case statusMessage = "status_message"
        case profile
//        case token = "gtoken"
        case friends = "friend_list_info"
    }
}

struct FriendInfoListResponse: Codable {
    let friends: [FriendInfo]
    
    enum CodingKeys: String, CodingKey {
        case friends = "friend_list_info"
    }
}
//struct FriendInfoResponse: Codable {
//    let friend: FriendInfo
//    
//    enum CodingKeys: String, CodingKey {
//        case friend = "friend_list_info"
//    }
//}
struct FriendInfo: Equatable, Codable {
    let email: String
    var name: String
    var statusMessage: String
    var profile: String
    
    init(){
        email = "ftest"
        name = "ftest"
        statusMessage = "ftest"
        profile = ""
    }
    init(email: String, name: String, m:String, p:String){
        self.email = email
        self.name = name
        self.statusMessage = m
        self.profile = p
    }
    
    mutating func update(name: String, statusMessage: String, profile: String){
        self.name = name
        self.statusMessage = statusMessage
        self.profile = profile
    }
    
    enum CodingKeys: String, CodingKey {
        case email
        case name = "username"
        case statusMessage = "status_message"
        case profile
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.email == rhs.email
    }
}

struct Check: Codable {
    let check: Bool
    
    init(){
        check = false
    }
    enum CodingKeys: String, CodingKey {
        case check = "is_success"
    }
}


class AquaManager {
    static let shared = AquaManager()
    var user: UserInfo?
    
//    func createFriend(email: String, name: String, statusMessage: String, profile: UIImage) -> FriendInfo{
//        return FriendInfo(email: email, name: name, statusMessage: statusMessage, profile: profile)
//    }
//    func loadUser(_ email: String, _ password: String){
//        URLSessionAPI.loginUserInfo(email, password) { userInfo in
//            print("--------->\(userInfo)")
//            guard userInfo.count != 0 else {
//                print("not value")
//                return
//            }
//            self.user = userInfo[0]
//        }
//        // 서버에서 받아온 정보를 넣어주면됨 대기
//    }
    func googleUserLoad(userInfo: UserInfo){
        user = userInfo
    }
    func updateUser(name: String, message: String){
        user!.update(name: name, statusMessage: message)
    }
    func addFriend(_ friend: FriendInfo) {
        user!.friends?.append(friend)
//        saveFriend()
    }
    func deleteFriend(_ friend: FriendInfo) {
        user!.friends = user!.friends?.filter { $0.email != friend.email}
    }
//    func updateFriend(_ friend: FriendInfo) {
//
//        //여기 서버에서 받아와서 업데이트임 이부분
//        guard let index = friends.firstIndex(of: friend) else {
//            return
//        }
//        friends[index].update(name: friend.name, statusMessage: friend.statusMessage ?? "", profile: friend.profile ?? "")
//        saveFriend()
//    }
//    func saveFriend(){
//        //친구검색해서 추가하면 서버에 등록시켜줘야함
//    }
}



