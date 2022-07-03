//
//  ViewController.swift
//  Diary
//
//  Created by 이주송 on 2022/07/02.
//

import UIKit

class ViewController: UIViewController{
  
    @IBOutlet weak var collectionVIew: UICollectionView!
    
    private var diaryList = [Diary]()
    // 구조체 파일로 따로 만든 Diary를 초기화
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    private func configureColletionView() {
            self.collectionVIew.collectionViewLayout = UICollectionViewLayout()
            self.collectionVIew.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            self.collectionVIew.delegate = self
            self.collectionVIew.dataSource = self
            // collectionVIew 필수 두가지 옵션임
        } // 콜렉션 뷰 디자인
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let writeDiaryViewController = segue.destination as? WriteDiaryViewController {
            // segue - Push로 뺐으니 prepare 메소드로 받을 준비
             writeDiaryViewController.delegate = self
            // 데이터를 보낸 WriteDiaryVC에 정의된 프로토콜을 채택하기
        }
    } // 보낸 데이터 받을 준비
}



extension ViewController: UICollectionViewDataSource {
    // 아래는 필수 메소드 두개 !
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.diaryList.count
    } // 콜렉션뷰의 위치에 표시할 셀의 "갯수"[필수 메서드]
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiaryCell", for: indexPath) as? DiaryCell else {return UICollectionViewCell() }
        let diary = self.diaryList[indexPath.row]
        cell.titleLabel.text = diary.title
        cell.dateLabel.text = self.dateToString(date: diary.date) // date형식을 데이트포매터를 이용해 문자열로 반환!
        return cell
    } // 콜렉션뷰의 위치에 표시할 셀을 "요청"하는 메소드[필수 메서드]
    
    
} // 콜렉션 뷰로 보여지는 컨텐츠를 관리하는 객체

extension ViewController: WriteDiaryViewDelegate {
    func didSelectRegister(diary: Diary) {
        self.diaryList.append(diary)
        debugPrint(self.diaryList)
    }// 일기가 작성이 되면 그 데이터를 이 VC에서 받고 이 VC에서 함수를 통해 구조체에 대입
    // writeDiaryViewController는 구조체에 담아서 보내는 역할
    // 이 ViewController는 그 데이터를 받아서 후처리 하는 역할(프로토콜에 정의된 함수를 실행하는 역할)
}
// 프로토콜 정의 , 델리게이트 변수 선언 -> 프로토콜 내 필요한 '파라미터'에 이를 담아 '보내기'만
// 델리게이트 위임, 프로토콜에 정의된 함수를 실행(등록 버튼 눌리면 어펜드)
