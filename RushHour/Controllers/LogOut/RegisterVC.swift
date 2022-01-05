//
//  MainVCViewController.swift
//  RushHour
//
//  Created by Артем Шакиров on 10.11.2021.
//

import UIKit
import FirebaseAuth
import JGProgressHUD

class RegisterVC: UIViewController {
    
    //MARK: -Элементы
    private let spinner = JGProgressHUD(style: .dark)
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.clipsToBounds = true
        return view
    }()
    
    private let profileImg: UIImageView = {
        let logo = UIImageView()
        logo.image = UIImage(systemName: "person.circle.fill")
        logo.tintColor = .systemGray4
        logo.clipsToBounds = true
        logo.contentMode = .scaleAspectFill
        logo.layer.borderColor = UIColor.systemGray.cgColor
        logo.layer.borderWidth = 5.0
        return logo
    }()
    
    private let firstName: TextFieldTemplate = {
        let field = TextFieldTemplate()
        field.placeholder = "Введите ваше имя"
        return field
    }()
    
    private let lastName: TextFieldTemplate = {
        let field = TextFieldTemplate()
        field.placeholder = "Введите вашу фамилию"
        return field
    }()
    
    private let login: TextFieldTemplate = {
        let field = TextFieldTemplate()
        field.placeholder = "Укажите ваш логин"
        return field
    }()
    
    private let email: TextFieldTemplate = {
        let field = TextFieldTemplate()
        field.placeholder = "Укажите вашу почту"
        return field
    }()
    
    private let password = PasswordField()
    
    private let loginButton: IconTextButton = {
        let button = IconTextButton()
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 6
        return button
    }()
    
    //MARK: -ViewDidLoad
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
        profileImageSetup()
        registrFieldsSetup()
        loginButtonSetup()
        
        
        
        loginButton.addTarget(self, action: #selector(registerButtonTaped), for: .touchUpInside)
        profileImg.isUserInteractionEnabled = true
        let logoTap = UITapGestureRecognizer(target: self, action: #selector(changeProfileImg))
        profileImg.addGestureRecognizer(logoTap)
    }
    
    //MARK: -Действия кнопок
    @objc private func registerButtonTaped() {
        
        guard let email = email.text,
              let nickname = login.text,
              let firstName = firstName.text,
              let lastName = lastName.text,
              let password = password.text,
              !email.isEmpty,
              !nickname.isEmpty,
              !firstName.isEmpty,
              !lastName.isEmpty,
              !password.isEmpty else {
                  alertSomeFieldIsEmpty()
                  return
                  
              }
        
        let chatUser = UserFullData( nick_name: nickname,
                                    first_name: firstName,
                                    last_name: lastName,
                                    email: email,
                                    conversations: nil )
        
        spinner.show(in: view, animated: true)
        
        
        /// Firebase регистрация
        DatabaseManager.shared.doesUserExist(with: email, completion: {[weak self] exist in
            guard let self = self else {return}

            if exist == true {
                DispatchQueue.main.async {
                    self.spinner.dismiss(animated: true)
                }
                self.alertUserAlreadyExist()
            } else {
                successRegistration()
            }
        })
        
        
        func successRegistration() {
            
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: {[weak self] result, err in
                DispatchQueue.main.async {
                    self?.spinner.dismiss(animated: true)
                }
                guard let result = result, err == nil else {
                    print("Error creating user: \(err!)")
                    return
                }
                /// Добавляем пользователя в базу
                DatabaseManager.shared.insertUser(with: chatUser, uid: result.user.uid, completion: { [weak self] success in
                    if success  {
                        
                        guard let image = self?.profileImg.image,
                              let data = image.pngData() else {
                                  return
                              }
                        let userUID = result.user.uid
                        UserDataCache.shared.saveUIDToUserData(uid: userUID, url: "")
                        // Загружаем фото профиля в базу если пользователь добавил его при регистрации
                        if !image.isSymbolImage {
                            
                            let profileImageName = result.user.uid + "_profile_image.png"
                            StorageManager.shared.uploadImage(with: data, fileName: profileImageName, completion: { result in
                                switch result {
                                case .success(let urlString):
                                    UserDataCache.shared.saveUIDToUserData(uid: userUID, url: urlString)
                                case .failure(let error):
                                    print("Storage manager error: \(error)")
                                }
                                
                            })
                        }
                    }
                    
                })
                let vc = TabBarVC()
                vc.modalPresentationStyle = .fullScreen
                vc.modalTransitionStyle = .crossDissolve
                self?.present(vc, animated: true)
            })
        }
    }
    
    // меню выбора фото для профиля
    @objc private func changeProfileImg() {
        presentPhotoActionSheet()
    }
    
    //MARK: -Размещение элементов
    func scrollViewSetup(){
        view.addSubview(scrollView)
        scrollView.anchors(
            centerX: view.centerXAnchor,
            top: view.topAnchor,
            bottom: view.bottomAnchor,
            width: view.widthAnchor
        )
    }
    
    func profileImageSetup(){
        let multiplayer = 0.4
        scrollView.addSubview(profileImg)
        profileImg.anchors(
            centerX: scrollView.centerXAnchor,
            top: scrollView.topAnchor,
            paddingTop: 50,
            width: scrollView.widthAnchor,
            widthMultiplayer: multiplayer,
            height: scrollView.widthAnchor,
            heightMultiplayer: multiplayer
        )
        profileImg.layoutIfNeeded()
        profileImg.layer.cornerRadius = profileImg.width / 2
    }
    
    func registrFieldsSetup(){
        let fieldHeight: CGFloat = 40
        let spaceBetweenFields: CGFloat = 10
        let fieldWith: CGFloat = 0.7
        
        scrollView.addSubview(login)
        login.anchors(
            centerX: scrollView.centerXAnchor,
            top: profileImg.bottomAnchor,
            paddingTop: 80,
            width: scrollView.widthAnchor,
            widthMultiplayer: fieldWith,
            heightConst: fieldHeight
        )
        
        scrollView.addSubview(firstName)
        firstName.anchors(
            centerX: scrollView.centerXAnchor,
            top: login.bottomAnchor,
            paddingTop: spaceBetweenFields,
            width: scrollView.widthAnchor,
            widthMultiplayer: fieldWith,
            heightConst: fieldHeight
        )
        
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
            iconSize: 30,
            spaceBetween: 5
        ))
        
        scrollView.addSubview(loginButton)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        loginButton.topAnchor.constraint(equalTo: password.bottomAnchor, constant: 50).isActive = true
        loginButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 20).isActive = true
        loginButton.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.7).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    //MARK: -Размер клавиатуры для ScrollView
    @objc func keyboardWasShown(notification: Notification) {
        // Получаем размер клавиатуры
        let info = notification.userInfo! as NSDictionary
        let kbSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbSize.height, right: 0.0)
        // Добавляем отступ внизу UIScrollView, равный размеру клавиатуры
        self.scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
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
extension RegisterVC: UITextFieldDelegate {
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

extension RegisterVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func alertUserAlreadyExist(){
        let actionSheet = UIAlertController(
            title: "Внимание!",
            message: "Пользователь с таким E-mail уже зарегистрирован",
            preferredStyle: .alert
        )
        actionSheet.addAction(UIAlertAction(
            title: "Ok",
            style: .cancel,
            handler: nil)
        )
        
        present(actionSheet, animated: true)
    }
    
    func alertSomeFieldIsEmpty(){
        let actionSheet = UIAlertController(
            title: "Внимание!",
            message: "Необходимо заполнить все поля",
            preferredStyle: .alert
        )
        actionSheet.addAction(UIAlertAction(
            title: "Ok",
            style: .cancel,
            handler: nil)
        )
        
        present(actionSheet, animated: true)
    }
    
    func presentPhotoActionSheet(){
        let actionSheet = UIAlertController(
            title: "Изображение профиля",
            message: "Вы можете изменить изображение своего профиля",
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
            handler: {[weak self] _ in
                self?.presentCamera()
            })
        )
        actionSheet.addAction(UIAlertAction(
            title: "Выбрать фото",
            style: .default,
            handler: {[weak self] _ in
                self?.presentPhotoPicker()
            })
        )
        
        present(actionSheet, animated: true)
    }
    
    func presentCamera(){
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func presentPhotoPicker(){
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {return}
        
        self.profileImg.image = selectedImage
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

