//
//  SearchFriendLIstTableViewCell.swift
//  Aqua_Talk
//
//  Created by Jeongguk Kim on 2021/08/30.
//

import UIKit

class SearchListViewCell: UITableViewCell {
    let userViewModel = UserViewModel()
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
//    var friendId: String?
    var friend: FriendInfo?
    func update(info: FriendInfo) {
        friend = info
        profileImage.setImageUrl(info.profile)
        profileImage.layer.cornerRadius = 20
        nameLabel.text = info.name
//        friendId = info.email
        if userViewModel.userInfo.email == info.email {
            addButton.isEnabled = false
            return
        }
        let isValue = userViewModel.friends.filter{$0.email == info.email}
        if !isValue.isEmpty {
            addButton.isEnabled = false
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func addFriend(_ sender: Any) {
        //여기서 friendId 가지고 서버에 넘겨준후 응답오면 버튼 비활성화시키고 친구배열에 추가시켜야함
        DispatchQueue.main.async {
            URLSessionAPI.addFriend(self.userViewModel.userInfo.email, self.friend!.email) { check in
                if check.check {
                    self.userViewModel.addFriend(self.friend!)
                    self.addButton.isEnabled = false
                }
            }
        }
    }
    
}
