//
//  TalkViewController.swift
//  Aqua_Talk
//
//  Created by Jeongguk Kim on 2021/08/05.
//

import UIKit

class HomeViewController: UIViewController {
    let userViewModel = UserViewModel()
    var label = UILabel()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editButton: UIButton!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            guard let vc = segue.destination as? DetailViewController else {
                return
            }
            let indexPath = sender as? IndexPath
            vc.modalPresentationStyle = .fullScreen
            vc.section = indexPath?.section
            vc.row = indexPath?.row
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nibName = UINib(nibName: "FriendsTableViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "friendCell")
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tableView.reloadData()
    }
    @IBAction func searchButton(_ sender: Any) {
        guard let VC = self.storyboard?.instantiateViewController(identifier: "SearchViewController") else {
            return
        }
        self.navigationController?.pushViewController(VC, animated: false)
        
    }
    @IBAction func editButton(_ sender: Any) {
        if self.tableView.isEditing {
            self.editButton.setImage(UIImage(systemName: "gearshape"), for: .normal)
            self.tableView.setEditing(false, animated: true)
            
        } else {
            self.editButton.setImage(UIImage(systemName: "gearshape.fill"), for: .normal)
            self.tableView.setEditing(true, animated: true)
        }
    }
    
}


extension HomeViewController: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        }
        let dummyViewHeight = CGFloat(30)
        self.tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: dummyViewHeight))
        self.tableView.contentInset = UIEdgeInsets(top: -dummyViewHeight, left: 0, bottom: 0, right: 0)
        
        let view = UIView(frame: CGRect(x:0, y:0, width: tableView.frame.width, height: tableView.frame.height))
        view.backgroundColor = .clear
        
        label = UILabel(frame: CGRect(x: 30, y: 0, width: view.frame.width, height: 30))
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.text = "친구 \(userViewModel.friendsCount)"
        label.textColor = .systemGray
        view.addSubview(label)
        return view
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 30
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 1 ? 0 : 1
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetail", sender: indexPath)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 80 : 60
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : userViewModel.friendsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath) as? FriendsTableViewCell else {
                return UITableViewCell()
            }
            
            let friendInfo = userViewModel.friendInfo(at: indexPath.row)
            cell.update(info: friendInfo)
            return cell
        }
        else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as? MyTableViewCell else {
                return UITableViewCell()
            }
            cell.update(info: userViewModel.userInfo)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if indexPath.section == 0 {
            return .none
        }else {
            return .delete
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            let friend = userViewModel.friends[indexPath.row]
            DispatchQueue.main.async {
                URLSessionAPI.deleteFriend(self.userViewModel.userInfo.email, friend.email) { Check in
                    if !Check.check {
                        print("실패")
                        return
                    }
                }
            }
            self.userViewModel.deleteFriend(friend)
            label.text = "친구 \(userViewModel.friendsCount)"
            tableView.deleteRows(at: [indexPath], with: .none)
        }
    }
    
}
