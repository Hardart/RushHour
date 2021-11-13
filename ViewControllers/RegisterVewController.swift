//
//  MainVCViewController.swift
//  RushHour
//
//  Created by Артем Шакиров on 10.11.2021.
//

import UIKit

class RegisterVewController: UIViewController {
    
    //MARK: -Элементы
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.clipsToBounds = true
        return view
    }()
    
    private let logo: UIImageView = {
        let logo = UIImageView()
        logo.image = UIImage(systemName: "globe")
        logo.tintColor = .systemGray4
        return logo
    }()
    
    private let firstName: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.backgroundColor = .white
        field.layer.cornerRadius = 6
        field.layer.borderWidth = 1
        field.placeholder = "Введите ваше имя"
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.layer.borderColor = UIColor.cyan.cgColor
        return field
    }()
    
    private let lastName: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.backgroundColor = .white
        field.layer.cornerRadius = 6
        field.layer.borderWidth = 1
        field.placeholder = "Введите вашу фамилию"
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.layer.borderColor = UIColor.cyan.cgColor
        return field
    }()
    
    private let login: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.backgroundColor = .white
        field.layer.cornerRadius = 6
        field.layer.borderWidth = 1
        field.placeholder = "Укажите ваш логин"
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.layer.borderColor = UIColor.cyan.cgColor
        return field
    }()
    
    private let email: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.backgroundColor = .white
        field.layer.cornerRadius = 6
        field.layer.borderWidth = 1
        field.placeholder = "Укажите вашу почту"
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.layer.borderColor = UIColor.cyan.cgColor
        return field
    }()
    
    private let password: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .done
        field.backgroundColor = .white
        field.layer.cornerRadius = 6
        field.layer.borderWidth = 1
        field.placeholder = "Пароль"
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.layer.borderColor = UIColor.cyan.cgColor
        field.isSecureTextEntry = true
        return field
    }()
    
    private let loginButton: IconTextButton = {
        let button = IconTextButton()
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 6
        return button
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("регистрация", for: UIControl.State.normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitleColor(.systemGray, for: .highlighted)
        button.titleLabel?.font = button.titleLabel?.font.withSize(15)
//        button.backgroundColor = .systemGreen
        button.sizeToFit()
        return button
    }()
     
    //MARK: -Свойства
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Регистрация"
        view.backgroundColor = .systemGray5
        
        login.delegate = self
        firstName.delegate = self
        lastName.delegate = self
        email.delegate = self
        password.delegate = self
        
        scrollViewSetup()
        logoSetup()
        loginSetup()
        loginButtonSetup()
        registerButtonSetup()
        
        loginButton.addTarget(self, action: #selector(registerButtonTaped), for: .touchUpInside)
//        registerButton.addTarget(self, action: #selector(toRegisterVC), for: .touchUpInside)
        logo.isUserInteractionEnabled = true
        let logoTap = UITapGestureRecognizer(target: self, action: #selector(changeProfileImg))
        logo.addGestureRecognizer(logoTap)
    }
    
    
    //MARK: -Действия кнопок
    
    
    @objc private func registerButtonTaped(){
        print("...REGISTER...")
    }
    
    @objc private func changeProfileImg() {
        print("...LOGO...")
        presentPhotoActionSheet()
    }
    
    //MARK: -Размещение элементов
    
    func scrollViewSetup(){
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func logoSetup(){
        scrollView.addSubview(logo)
        logo.translatesAutoresizingMaskIntoConstraints = false
        logo.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        logo.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 50).isActive = true
        logo.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.3).isActive = true
        logo.heightAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.3 ).isActive = true
    }
    
    func loginSetup(){
        let fieldHeight: CGFloat = 40
        let spaceBetweenFields: CGFloat = 10
        let fieldWith: CGFloat = 0.7
        
        scrollView.addSubview(login)
        login.translatesAutoresizingMaskIntoConstraints = false
        login.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        login.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: 80).isActive = true
        login.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: fieldWith).isActive = true
        login.heightAnchor.constraint(equalToConstant: fieldHeight).isActive = true
        
        scrollView.addSubview(firstName)
        firstName.translatesAutoresizingMaskIntoConstraints = false
        firstName.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        firstName.topAnchor.constraint(equalTo: login.bottomAnchor, constant: spaceBetweenFields).isActive = true
        firstName.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: fieldWith).isActive = true
        firstName.heightAnchor.constraint(equalToConstant: fieldHeight).isActive = true
        
        scrollView.addSubview(lastName)
        lastName.translatesAutoresizingMaskIntoConstraints = false
        lastName.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        lastName.topAnchor.constraint(equalTo: firstName.bottomAnchor, constant: spaceBetweenFields).isActive = true
        lastName.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: fieldWith).isActive = true
        lastName.heightAnchor.constraint(equalToConstant: fieldHeight).isActive = true
        
        scrollView.addSubview(email)
        email.translatesAutoresizingMaskIntoConstraints = false
        email.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        email.topAnchor.constraint(equalTo: lastName.bottomAnchor, constant: spaceBetweenFields).isActive = true
        email.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: fieldWith).isActive = true
        email.heightAnchor.constraint(equalToConstant: fieldHeight).isActive = true
        
        scrollView.addSubview(password)
        password.translatesAutoresizingMaskIntoConstraints = false
        password.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        password.topAnchor.constraint(equalTo: email.bottomAnchor, constant: spaceBetweenFields).isActive = true
        password.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: fieldWith).isActive = true
        password.heightAnchor.constraint(equalToConstant: fieldHeight).isActive = true
    }
    
    func loginButtonSetup(){
        loginButton.config(with: IconButtonModel(
            icon: UIImage(systemName: "rectangle.portrait.and.arrow.right"),
            title: "Зарегистрироваться",
            background: .systemGray4,
            iconSize: 30
        ))
        scrollView.addSubview(loginButton)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        loginButton.topAnchor.constraint(equalTo: password.bottomAnchor, constant: 50).isActive = true
        loginButton.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.7).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func registerButtonSetup(){
        scrollView.addSubview(registerButton)
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        registerButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        registerButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor).isActive = true
        registerButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 20).isActive = true
        registerButton.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.25).isActive = true
        registerButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    //MARK: -Размер клавиатуры для ScrollView
    
    @objc func keyboardWasShown(notification: Notification) {
        // Получаем размер клавиатуры
        let info = notification.userInfo! as NSDictionary
        let kbSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbSize.height, right: 0.0)
        // Добавляем отступ внизу UIScrollView, равный размеру клавиатуры
        self.scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets }
    
    @objc func keyboardWillBeHidden(notification: Notification) {
        // Устанавливаем отступ внизу UIScrollView, равный 0
        let contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Подписываемся на два уведомления: одно приходит при появлении клавиатуры
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        // Второе — когда она пропадает
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
}

//MARK: -Расширения

extension RegisterVewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case login:
            firstName.becomeFirstResponder()
        case firstName:
            lastName.becomeFirstResponder()
        case lastName:
            email.becomeFirstResponder()
        case email:
            password.becomeFirstResponder()
        case password:
            registerButtonTaped()
        default:
            break
        }
        return true
    }
}

extension RegisterVewController: UIImagePickerControllerDelegate {
    
    func presentPhotoActionSheet(){
        let actionSheet = UIAlertController(
            title: "Изображение профиля",
            message: "Варианты выбора изображения",
            preferredStyle: .actionSheet
        )
        actionSheet.addAction(UIAlertAction(
            title: "Отмена",
            style: .cancel,
            handler: nil)
        )
        actionSheet.addAction(UIAlertAction(
            title: "Сделать фото",
            style: .default,
            handler: nil)
        )
        actionSheet.addAction(UIAlertAction(
            title: "Выбрать из галереи",
            style: .default,
            handler: nil)
        )
        
        present(actionSheet, animated: true)
    }
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        <#code#>
//    }
//
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        <#code#>
//    }
}

