
 <h1 align="center"> ⏰ 일정관리 앱 ⏰</h1>

## ⭐️ 개요
- Swift문법개념을 실제 앱만들기에 적용시키고, 그 과정에서 Apple이 권장하는 Best Practice들을 취득하기 위한 프로젝트
- 일정을 손쉽게 등록하고 관리할 수 있는 앱.

## ⭐️ 앱 화면
<img width="300px" height="600px" src="https://user-images.githubusercontent.com/70146658/183013257-ccfeeb87-9aa8-4f01-a6d9-28b009342505.gif"/>


## ⭐️ 알게된 것

### ✍🏻 Diffable DataSource
- 기존의 DataSource에서 reloadData를 수동적으로 해야하고, UI 업데이트가 깜빡거리게 되는 현상을 방지하 나온 제네릭 클래스.
#### 사용방법
1. Diffable Data Source와 collection view 연결
2. 컬렉션 뷰의 셀을 구성하기 위한 cell Provider 구현 (사전에 register 필수)
3. 현재 데이터 상태를 생성. -> snapshot에 넣고, apply
4. UI에서 Display
<br/>
<br/>
  
  
### ✍🏻 ColorSet
- ColorSet을 사전에 정의하여 유지보수 및 디자인 프로세스를 일관성있게 맞추는 역할.

### 사용방법
1. asset에 colorSet폴더를 만들고 색상 삽입 -> 이름 변경
2. extension UIColor를 해서 변수명 정의 후 리턴.
```swift
extension UIColor {
    static var viewBackGround: UIColor {
        UIColor(named: "viewBackGround") ?? .tintColor
    }
    
    static var todayListCellBackground: UIColor {
        UIColor(named: "TodayListCellBackground") ?? .secondarySystemBackground
    }
}
```
3. 사용
```swift
override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .viewBackGround
}
```
<br/>
<br/> 

### ✍🏻 didSet의 사용
- 속성이 변화되었을 때 실행하는 메서드.
- ex) 기존의 VC에서 리스트의 아이템 하나를 클릭 시 디테일 VC로 이동할 때 reminder의 속성이 변경되면서 실행
- reminder는 일정관리의 셀의 데이터모델로 비즈니스 로직의 핵심모델

1. 셀 클릭 시 shouldSelectItemAt 실행.
```swift
// viewListController.swift
override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
    let id = filteredReminders[indexPath.item].id
    showDetail(for: id)
    return false
}
```
2. showDetail실행하면서 디테일 VC객체 생성과 동시에 클로저 전달.(클로저는 처음 디테일VC가 생성될 때 "등록"만 하고 클로저 내부의 실행은 직접 호출할때만 실행된다. 즉 여기서는 등록만 된 상태) 
```swift
// viewListController.swift
func showDetail(for id: Reminder.ID) {
    let reminder = reminder(for: id)
    let viewController = ReminderViewController(reminder: reminder) { [weak self] reminder in
        self?.update(reminder, with: reminder.id)
        self?.updateSnapShot(reloading: [reminder.id])
    }
    navigationController?.pushViewController(viewController, animated: true)
}
```

3. reminder가 변경되었을 때 didSet호출하고 저장되어있던 클로저 호출.(이때, 2번에서 정의한 클로저가 호출되는데 이는 변경된 reminder를 받아 snapshot을 업데이트해서 UI를 업데이트함.
```swift
var reminder: Reminder {
    didSet {
        onChange(reminder)
    }
}
```

<br/>
<br/>

### ✍🏻 접근성의 사용
- Collectionview의 cell내에서 접근성을 부여하는 것은 accessibilityCustomActions, accessabilityValue 2가지를 기억하면 된다.
- accessibilityCustomActions에는 지정한 접근성 커스텀 액션을 담아주고, accessabilityValue에는 조건에 따라서 VoiceOver로 들려줄 값을 설정하면 된다.
```swift
// 접근 커스텀 값 정의
var reminderCompletedValue: String {
    NSLocalizedString("Completed", comment: "Reminder completed value")
}
var reminderNotCompletedValue: String {
    NSLocalizedString("Not completed", comment: "Reminder not completed value")
}


// 접근 커스텀 액션 정의
 private func doneButtonAccessibilityAction(for reminder: Reminder) -> UIAccessibilityCustomAction {
    let name = NSLocalizedString("Toggle completion", comment: "Reminder done button accessibility label")
    let action = UIAccessibilityCustomAction(name: name) { [weak self] action in
        self?.completeReminder(with: reminder.id)
        return true
    }
    return action
}

// 셀 등록하는 함수 내부에서 셀에 속성 부여.
func cellRegistrationHandler(cell: UICollectionViewListCell, indexPath: IndexPath, id: Reminder.ID) {
    // code
    cell.accessibilityCustomActions = [ doneButtonAccessibilityAction(for: reminder) ]
    cell.accessibilityValue = reminder.isComplete ? reminderCompletedValue : reminderNotCompletedValue
    // code
```

<br/>
<br/>

### ✍🏻 array의 확장
- id값을 받아 인덱스 값을 리턴하는 배열 확장
```swift
extension Array where Element == Reminder {
    func indexOfReminder(with id: Reminder.ID) -> Self.Index {
        guard let index = firstIndex(where: { $0.id == id }) else {
            fatalError()
        }
        return index
    }
}

```
