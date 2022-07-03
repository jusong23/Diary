//
//  WriteDiaryViewController.swift
//  Diary
//
//  Created by 이주송 on 2022/07/02.
//

import UIKit

protocol WriteDiaryViewDelegate: AnyObject {
    func didSelectRegister(diary: Diary)
} // WriteDiary에서 VC의 UIColletionView로 보낼 준비
//  AnyObject를 상속하고 , '등록' 버튼이 눌리면 Diary 객체 보낼 프로토콜 정의

class WriteDiaryViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var confirmButton: UIBarButtonItem!

    private let datePicker = UIDatePicker()
    private var diaryDate: Date? // 데이트픽커에서 선정된 날짜를 저장하는 곳
    weak var delegate: (WriteDiaryViewDelegate)?
    //delegate 프로퍼티 ! 위에 정의 해놓은 프로토콜을 채택하는 것
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureContentsTextView()
        self.configureDatePicker()
//        self.confirmButton.isEnabled = false
    }
    
    @IBAction func tapConfirmButton(_ sender: UIBarButtonItem) {
        guard let title = self.titleTextField.text else {return}
        guard let contents = self.contentsTextView.text else {return}
        guard let date = self.diaryDate else {return}
        // 각 텍스트필드에 적힌 값들을 옵셔널바인딩(없을수도 있으니)

        let diary = Diary(title: title, contents: contents, date: date, isStar: false)
        // 구조체에 그 값들을 넣기
        self.delegate?.didSelectRegister(diary: diary)
        // delegate의 didSelectRegister 메소드에 diary 객체를 넣어줌
        self.navigationController?.popViewController(animated: true)
        // 보낼 준비 끝
        /*  보내는 곳에서 프로토콜(메소드 & 파라미터 삽입) 설정해 놓고 그 프로토콜 내 메소드를 이 WriteDiaryVC내에서 쓰기 위한 작업이 바로
            weak var delegate: (WriteDiaryViewDelegate)? 인 것이다.
         */

    }
    
    
//    private func configureInputField() {
//        self.contentsTextView.delegate = self
        // 제목 내용 날짜 안채워져있으면 못 올리게 ! 근데 얘는 왜 채택함?
//        self.titleTextField.addTarget(self, action: #selector(titleTextFieldDidChange(_:)), for: .valueChanged)
//        self.dateTextField.addTarget(self, action: #selector(dataTextFieldDidChange(_:)), for: .valueChanged)
//    }
    
//    @objc private func titleTextFieldDidChange(_ textField: UITextField) {
//        self.vailddateInputField()
//    }
//
//    @objc private func dataTextFieldDidChange(_ textField: UITextField) {
//        self.vailddateInputField()
//    }
    
    
    private func configureContentsTextView() {
        let borderColor = UIColor(red: 220/225, green: 220/225, blue: 220/225, alpha: 1.0)
        self.contentsTextView.layer.borderColor = borderColor.cgColor
        self.contentsTextView.layer.borderWidth = 0.5
        self.contentsTextView.layer.cornerRadius = 5.0
        // CSS 작업도 할 수 있다 !
    } // 0.0 ~ 1.0 사이의 값을 넣어줘야 하므로 220/225
    
    private func configureDatePicker() {
        self.datePicker.datePickerMode = .date
        self.datePicker.preferredDatePickerStyle = .wheels
        self.datePicker.addTarget(self, action: #selector(dataPickerValueDidChange(_ :)), for: .valueChanged) // @objc로 선택 되었을 때 취할 액션을 작성
        // 데이트피커 값이 변경될때마다
        self.datePicker.locale = Locale(identifier: "ko_KR")
        self.dateTextField.inputView = self.datePicker
    }
    

    
    @objc private func dataPickerValueDidChange(_ dataPicker: UIDatePicker) {
        let formmater = DateFormatter()
        formmater.dateFormat = "yy. MM. dd(EEEEE)"
        // 이런 포맷으로 설정하겠다. 2022년 7월 3일(화)
        formmater.locale = Locale(identifier: "ko_KR")
        self.diaryDate = datePicker.date
        // 데이트피커의 데이트가 diaryDate에 저장
        self.dateTextField.text = formmater.string(from: dataPicker.date)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    } // 터치하면 빠져나오는 메소드
    
//    private func vailddateInputField() {
//        self.confirmButton.isEnabled = !(self.titleTextField.text?.isEmpty ?? true) && !(self.dateTextField.text?.isEmpty ?? true) && !self.contentsTextView.text.isEmpty
//    }
    
    
}

//extension WriteDiaryViewController: UITextViewDelegate {
//    func textViewDidChange(_ textView: UITextView) {
//        self.vailddateInputField()
//    } // text가 입력 될때마다 호출 되는 메소드
//}

// private는 무엇? - 앱 모듈 외부에서 사용하지 못하게
