import UIKit

class TextFieldContentView: UIView, UIContentView {
    struct Configuration: UIContentConfiguration {
        
        func makeContentView() -> UIView & UIContentView {
            return TextFieldContentView(self)
        }
        
        var text: String? = ""
        var onChange: (String)->Void = { _ in }
        
      
    }
    
    let textField = UITextField()
    
    // 설정 객체가 model data를 가지고 있고, 이는 변화에 따라서 view를 업데이트 해주기 때문에 동기화를 보장한다.
    var configuration: UIContentConfiguration {
        didSet {
            configure(configuration: configuration)
        }
    }
    
    
    // 기본적으로 UIView를 상속하면 그 클래스의 크기는 내용의 크기에 따라 크기가 결정된다. 이에 대해 실제적인 크기를 구현하고 싶다면 intrinsicContentSize를 직접 정의하면 된다.
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: 0, height: 44)
    }
    
    init(_ configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        addPinnedSubview(textField, insets: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
        textField.addTarget(self, action: #selector(didChange(_:)), for: .editingChanged)
        textField.clearButtonMode = .whileEditing
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(configuration: UIContentConfiguration) {
        guard let configuration = configuration as? Configuration else { return }
        textField.text = configuration.text
        
    }
    
    @objc private func didChange(_ sender: UITextField) {
        guard let configuration = configuration as? TextFieldContentView.Configuration else { return }
        configuration.onChange(textField.text ?? "")
    }
    
    
}

extension UICollectionViewListCell {
    func textFieldConfiguration() -> TextFieldContentView.Configuration {
        TextFieldContentView.Configuration()
    }
}
