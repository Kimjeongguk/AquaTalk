//
//  ViewModels.swift
//  Aqua_Talk
//
//  Created by Jeongguk Kim on 2021/07/29.
//

import UIKit

class UserViewModel {
    private let manager = AquaManager.shared
    
    var userInfo: UserInfo { //내정보
        return manager.user!
    }
    var friends: [FriendInfo] { //친구배열
        return (manager.user?.friends)!
    }
    var friendsCount: Int { // 친구수
        return manager.user?.friends?.count ?? 0
    }
    func addFriend(_ friend: FriendInfo) { //친구 추가
        manager.addFriend(friend)
    }
    func friendInfo(at index: Int) -> FriendInfo{ //친구정보
        return (manager.user?.friends![index])!
    }
    func deleteFriend(_ friend: FriendInfo) { //친구제거
        manager.deleteFriend(friend)
    }
    func updateUser(name: String, message: String) { //내정보 업데이트
        manager.updateUser(name: name, message: message)
    }
    func googleUserLoadTask(userInfo: UserInfo){
        manager.googleUserLoad(userInfo: userInfo)
    }
    func loadTasks(_ email:String, _ password: String) { //로그인시 정보 받아오기
//        manager.loadUser(email, password)
    }
    
}
