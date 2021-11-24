//
//  FriendsViewController.swift
//  Aqua_Talk
//
//  Created by Jeongguk Kim on 2021/08/04.
//

import UIKit

class FriendsViewController: UIViewController {
    
    @IBOutlet weak var titleButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
    }
}


extension FriendsViewController: UITableViewDelegate{
    
}

extension FriendsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}


