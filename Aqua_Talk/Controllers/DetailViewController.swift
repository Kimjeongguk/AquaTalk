//
//  DetailViewController.swift
//  Aqua_Talk
//
//  Created by Jeongguk Kim on 2021/08/27.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statusMessage: UILabel!
    @IBOutlet weak var talkAndProfile: UIButton!
    
    let userViewModel = UserViewModel()
    var section: Int?
    var row: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImage.layer.cornerRadius = 40
        updateUI()
    }
    
    func updateUI(){
        if section == 0{
            talkAndProfile.setTitle("프로필 편집", for: .normal)
            talkAndProfile.setImage(UIImage(systemName: "pencil"), for: .normal)
            profileImage.setImageUrl(userViewModel.userInfo.profile)
            nameLabel.text = userViewModel.userInfo.name
            statusMessage.text = userViewModel.userInfo.statusMessage
        }else {
            profileImage.setImageUrl(userViewModel.userInfo.friends![row!].profile)
            nameLabel.text = userViewModel.userInfo.friends?[row!].name
            statusMessage.text = userViewModel.userInfo.friends![row!].statusMessage
        }
    }
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func talkAndupdateButton(_ sender: Any) {
        if section == 0 {
            guard let updateVC = self.storyboard?.instantiateViewController(withIdentifier: "updateViewController") as? ProfileUpdateViewController  else {
                return
            }
            updateVC.modalPresentationStyle = .fullScreen
            updateVC.image = profileImage.image!
            updateVC.name = nameLabel.text
            updateVC.message = statusMessage.text
            
            self.present(updateVC, animated: false, completion: nil)
        }else {
            
        }
    }
}
