//
//  ViewController.swift
//  Aqua_Talk
//
//  Created by Jeongguk Kim on 2021/06/28.
//

import UIKit
import GoogleSignIn
import Alamofire

class LoginViewController: UIViewController {

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var errorLabel: UILabel!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var singupLabel: UILabel!
    
    
    let userViewModel = UserViewModel()
    let loginStyoryboard = UIStoryboard(name: "Main", bundle: nil)
    let regularExpression = RegularExpression()
    var errorHeight: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self // 로그인화면 불러오기
        GIDSignIn.sharedInstance()?.restorePreviousSignIn() // 자동로그인
        
        loginButton.isEnabled = false
        errorHeight = errorLabel.heightAnchor.constraint(equalToConstant: 0)
        errorHeight.isActive = true
        passwordTextField.addTarget(self, action: #selector(passwordLength), for: .editingChanged)
        let tab: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(moveToSingup))
        singupLabel.isUserInteractionEnabled = true
        singupLabel.addGestureRecognizer(tab)
    }

    
    @IBAction func googleSignIn(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    @IBAction func loginButton(_ sender: UIButton) {
        let emailText = emailTextField.text
        let passwordText = passwordTextField.text

//        if !regularExpression.isValidEmail(email: emailText) {
//            errorLabel.text = "이메일 형식을 확인하세요."
//            errorHeight.isActive = false
//            return
//        }
//        if !regularExpression.isValidPassword(password: passwordText) {
//            errorLabel.text = "비밀번호를 확인하세요."
//            errorHeight.isActive = false
//            return
//        }
        

        //여기부터 서버에 정보를 보내서 true false 값 받아와서 결과 리턴
        userViewModel.loadTasks(emailText!, passwordText!)//임시
        //이런 느낌 정확한거아님...
        errorHeight.isActive = true
        //여기에 조건문 userViewModel의 값이 null이면 실패 아니면 성공으로 조건걸어두고 alert으로 실패했으면 띄워주는거까지 작성해야함
        
        guard let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") else {
            return
        }
        self.navigationController?.pushViewController(homeVC, animated: true)
    }
    
    @objc func moveToSingup(){
        
        let singUpVC = loginStyoryboard.instantiateViewController(identifier: "SingUpVC")
        self.show(singUpVC, sender: self)
    }
    
    @objc func passwordLength() {
        if passwordTextField.text!.count >= 4 {
            loginButton.backgroundColor = UIColor.darkGray
            loginButton.setTitleColor(UIColor.white, for: .normal)
            loginButton.isEnabled = true
        }else {
            loginButton.isEnabled = false
        }
    }
}

class RegularExpression {
    
    func isValidEmail(email: String?) -> Bool {
        let emailPattern = #"^\S+@\S+\.\S+$"#
        let result = email?.range(
            of: emailPattern,
            options: .regularExpression
        )

        return result != nil
    }
    
    func isValidPassword(password: String?) -> Bool {
        let passwordPattern =
            // At least 8 characters 8자 이상
            #"(?=.{8,})"# +
            // At least one capital letter 하나 이상의 대문자
//            #"(?=.*[A-Z])"# +
            // At least one lowercase letter 하나 이상의 소문자
            #"(?=.*[a-z])"# +
            // At least one digit 한 자리 이상
            #"(?=.*\d)"# +
            // At least one special character 하나 이상의 특수 문자
            #"(?=.*[ !@#$%^&*?._-])"#
        
        let result = password?.range(
            of: passwordPattern,
            options: .regularExpression
        )

        return result != nil
    }
}


extension LoginViewController: GIDSignInDelegate {
    public static var user: GIDGoogleUser!
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            if(error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("not signed in before or signed out")
            } else {
                print(error.localizedDescription)
            }
        }

        // singleton 객체 - user가 로그인을 하면, AppDelegate.user로 다른곳에서 사용 가능
        LoginViewController.user = user
        print(user!.profile.email!)
        let loginParameter = [
            "email": user!.profile.email!,
            "userid": user!.userID!,
            "username": user!.profile.name!,
            "gtoken": user!.authentication.accessToken!
        ]
        //======================
        self.userViewModel.googleUserLoadTask(userInfo: UserInfo())// 여기에 유저받아온거 넣어주면됨 나중에 수정해 줘야함****************
        print("friendCount===>\(userViewModel.friendsCount)")
        guard let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") else {
            return
        }

        self.navigationController?.pushViewController(homeVC, animated: true)
        //======================
        print(loginParameter)
//        Alamofire.request("http://3.35.70.131:3002/api/login/info", method: .post, parameters: loginParameter)
//                            .validate(statusCode: 200..<300)
//                    .responseJSON { (response) in switch response.result {
//                    case .success(let jsonvalue):
//                        do{
//                            let data = try JSONSerialization.data(withJSONObject: jsonvalue, options: .prettyPrinted)
//                            let value = LoginViewController.parseGUserInfo(data)
//                            print(value)
//                            self.userViewModel.googleUserLoadTask(userInfo: value.user)
//                            //====================== 화면 전환
//                            guard let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") else {
//                                return
//                            }
//
//                            self.navigationController?.pushViewController(homeVC, animated: true)
//                            //======================
//                        }
//                        catch let error{
//                            print("-->parsing error: \(error.localizedDescription)")
//                        }
//                    case .failure(let error):
//                        print("===========\(error.localizedDescription)")
//                    }
//                }
//        return
    }
    
    static func parseGUserInfo(_ data: Data) -> LoginResponse {
        let decoder = JSONDecoder()
        do {
            let response = try decoder.decode(LoginResponse.self, from: data)
            let user = response
            print("******\(user)")
            return user
        }catch let error {
            print("-->parsing error: \(error.localizedDescription)")
            return LoginResponse();
        }
    }
}



