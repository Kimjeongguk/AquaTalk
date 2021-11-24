//
//  ProfileUpdateViewController.swift
//  Aqua_Talk
//
//  Created by Jeongguk Kim on 2021/09/02.
//

import UIKit

class ProfileUpdateViewController: UIViewController {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statusMessage: UILabel!
    @IBOutlet weak var cameraImage: UIImageView!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var messageView: UIView!
    
    let userViewModel = UserViewModel()
    
    var image = UIImage()
    var name: String?
    var message: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImage.layer.cornerRadius = 40
        cameraImage.layer.cornerRadius = 10
        profileImage.image = image
        nameLabel.text = name
        
        
        nameView.labelAddBottomBorderWithColor(color: UIColor.gray, width: CGFloat(1))
        messageView.labelAddBottomBorderWithColor(color: UIColor.gray, width: CGFloat(1))
        let nameTab: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(nameChange))
        let messaageTab: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(messageChange))
        nameView.isUserInteractionEnabled = true
        nameView.addGestureRecognizer(nameTab)
        messageView.isUserInteractionEnabled = true
        messageView.addGestureRecognizer(messaageTab)
        
    }
    override func viewWillAppear(_ animated: Bool) {
            if let updateName = name {
                nameLabel.text = updateName
            }
            if message == ""{
                statusMessage.text = "상태메시지를 입력해 주세요."
            } else {
                statusMessage.text = message
            }
        }
    
    @objc func nameChange(){
        print("name")
        guard let VC = self.storyboard?.instantiateViewController(withIdentifier: "textChangeController") as? TextChangeViewController else {
            return
        }
        VC.modalPresentationStyle = .fullScreen
        VC.count = 20
        VC.text = name
        self.present(VC, animated: true, completion: nil)
    }
    @objc func messageChange(){
        print("message")
        guard let VC = self.storyboard?.instantiateViewController(withIdentifier: "textChangeController") as? TextChangeViewController else {
            return
        }
        VC.modalPresentationStyle = .fullScreen
        VC.count = 60
        VC.text = message
        self.present(VC, animated: true, completion: nil)
    }
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func updateInfo(_ sender: Any) {
        DispatchQueue.main.async {
            URLSessionAPI.updateFriend(self.userViewModel.userInfo.email, self.nameLabel.text!, self.statusMessage.text ?? ""){ Check in
                if Check.check {
                    self.userViewModel.updateUser(name: self.nameLabel.text!, message: self.statusMessage.text ?? "")
                }else {
                    print("실패")
                }
            }
            
        }
    }
}

extension UIView {
    func labelAddBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
      }
}
