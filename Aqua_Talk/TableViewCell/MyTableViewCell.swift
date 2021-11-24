//
//  TableViewCell.swift
//  Aqua_Talk
//
//  Created by Jeongguk Kim on 2021/08/07.
//

import UIKit

class MyTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statusMessage: UILabel!
    @IBOutlet weak var nameProfileCenterY: NSLayoutConstraint!
    
    func update(info: UserInfo) {
        profileImage.setImageUrl(info.profile) //****************
//        profileImage.image = UIImage(named: "luffy.jpg")//여기 지워야함 *****************
        profileImage.layer.cornerRadius = 20
        nameLabel.text = info.name
        statusMessage.text = info.statusMessage
        if statusMessage.text == ""{
            nameProfileCenterY.constant = 0
        }
    }

}

class ImageCacheManager {
    static let shared = NSCache<NSString, UIImage>()
    
    private init(){}
}

extension UIImageView {
    
    func setImageUrl(_ url: String) {
        let cacheKey = NSString(string: url)
        if let cachedImage = ImageCacheManager.shared.object(forKey: cacheKey){
            self.image = cachedImage
            return
        }
        DispatchQueue.global(qos: .background).async {
            if let url = URL(string: url) {
                URLSession.shared.dataTask(with: url) { (data, res, err) in
                    if let _ = err {
                        DispatchQueue.main.async {
                            self.image = UIImage()
                        }
                        return
                    }
                    DispatchQueue.main.async {
                        if let data = data, let image = UIImage(data: data) {
                            ImageCacheManager.shared.setObject(image, forKey: cacheKey)
                            self.image = image
                        }
                    }
                }.resume()
            }
        }
    }
 }
