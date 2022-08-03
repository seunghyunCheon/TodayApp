import UIKit

class TextFieldContentView: UIView {
    let textField = UITextField()
    
    
    // 기본적으로 UIView를 상속하면 그 클래스의 크기는 내용의 크기에 따라 크기가 결정된다. 이에 대해 실제적인 크기를 구현하고 싶다면 intrinsicContentSize를 직접 정의하면 된다.
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: 0, height: 44)
    }
    
    init() {
        super.init(frame: .zero)
        addPinnedSubview(textField, insets: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
        textField.clearButtonMode = .whileEditing
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
