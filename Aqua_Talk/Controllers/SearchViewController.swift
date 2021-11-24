//
//  SearchViewController.swift
//  Aqua_Talk
//
//  Created by Jeongguk Kim on 2021/08/28.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    let userViewModel = UserViewModel()
    var friendList: [FriendInfo] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    

    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: false)
    }
}

extension SearchViewController: UITableViewDelegate{
    
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "friendListCell", for: indexPath) as? SearchListViewCell else {
            return UITableViewCell()
        }
        cell.update(info: friendList[indexPath.row])
        return cell
    }
    
    
}

extension SearchViewController: UISearchBarDelegate {
    private func dismissKeyboard(){
        searchBar.resignFirstResponder() //키보드 내려가게
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        friendList = []
        dismissKeyboard()
        guard let searchTrem = searchBar.text, searchTrem.isEmpty == false else { return }
        URLSessionAPI.friendSearch(searchTrem) { friends in
            DispatchQueue.main.async {
                self.friendList = friends.filter{$0.email != self.userViewModel.userInfo.email}
                self.friendList = self.friendList.filter{!self.userViewModel.friends.contains($0)}
                self.tableView.reloadData()
            }
        }

    }
}
