//
//  SingUpViewController.swift
//  Aqua_Talk
//
//  Created by Jeongguk Kim on 2021/07/10.
//

import UIKit

class SingUpViewController: UIViewController {
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var passwordCheckTextField: UITextField!
    
    var verification = false
    let regularExpression = RegularExpression()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func idVerification(_ sender: Any) {
        guard let email = emailTextField.text else {
            return
        }
        URLSessionAPI.emailVerification(email) { emails in
            DispatchQueue.main.async {
                //여기에 넘어온 값 emails를 가지고 중복검사확인후 verification에 true or false 넣어주면됨
            }
        }
    }
    @IBAction func createUser(_ sender: Any) {
        var title: String?
        var message: String?
        
        if !verification {
            title = "중복확인"
            message = "이메일 중복확인을 해주세요."
        }
        else if nameTextField.text!.count < 2 {
            title = "이름"
            message = "이름을 2글자 이상 적어 주세요."
        }
        else if !regularExpression.isValidEmail(email: emailTextField.text) {
            title = "이메일"
            message = "이메일 형식에 맞게 입력하세요"
        }
        else if !regularExpression.isValidPassword(password: passwordTextField.text) {
            title = "비밀번호"
            message = "8자 이상, 특수문자 포함, 숫자를 포함해야 합니다."
        }
        else if passwordTextField.text != passwordCheckTextField.text {
            title = "비밀번호"
            message = "비밀번호를 확인해 주세요."
        }else {
            //여기에 서버로 post 하는거 넣어줘
            DispatchQueue.global(qos: .userInteractive).sync {
                URLSessionAPI.createUser(emailTextField.text!, nameTextField.text!, passwordTextField.text!)
            }
            
            title = "회원가입"
            message = "가입 완료!"
        }
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
        
        if title == "회원가입" {
            dismiss(animated: true, completion: nil)
        }
        
    }
}
