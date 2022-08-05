
 <h1 align="center"> ⏰ 일정관리 앱 ⏰</h1>

## ⭐️ 개요
- Swift문법개념을 실제 앱만들기에 적용시키고, 그 과정에서 Apple이 권장하는 Best Practice들을 취득하기 위한 프로젝트
- 일정을 손쉽게 등록하고 관리할 수 있다.

## ⭐️ 앱 화면
<img width="300px" height="600px" src="https://user-images.githubusercontent.com/70146658/180103659-3b4855ef-aedf-4c6d-bc85-f684f18ee3a3.gif"/>


## ⭐️ 알게된 것
- 일반적으로 클래스 앞에는 final 키워드를 붙여줘야 한다. 상속을 해당 클래스단계에서 끝내는 키워드인 final은 table dispatch로 작동하던 클래스를 direct dispatch로 작동하게 만들어준다. 
- 클래스나 구조체 내부에서 변수를 사용할 때 private 키워드를 적극적으로 사용한다.
- // *MARK - 내용* 을 논리적으로 코드를 나눌때 사용해 가독성이 좋게 만든다.
- 변수가 클로저 형태로 작성되면서 let으로 선언되어 있다면 내부에서 선언한 view가 addSubView하는 것이 불가능하다. 
```swift

(X)
private let passwordFieldView: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor.black
    view.addSubView(passwordTextField) // 불가능.
}()

// let이 아닌 lazy var로 선언이 되어있어야 한다. -> 처음 변수를 로드할 때 addSubView를 사용하기 위해서 이전에 변수가 생성되어있는 상태를 보장해야하기때문


(O)
private lazy var passwordFieldView: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor.black
    view.addSubView(passwordTextField) // 가능.
}()

```
- 오토레이아웃을 동적으로 변화시키기 위해서는 해당 속성을 변수로 만들어야 한다.
- ViewController에서 특정 프로토콜을 따르는 로직(ex: 델리게이트 프로토콜)들은 가독성을 위해 확장을 통해 설계한다.
- alert창은 확인이나 취소와 같은 액션들을 추가해주어야 한다. (실제 동작시키는 부분은 present함수)
      
       
         
          
           
             
