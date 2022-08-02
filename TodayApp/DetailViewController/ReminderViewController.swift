import UIKit

class ReminderViewController: UICollectionViewController {
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Row>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Row>
    
    var reminder: Reminder
    private var dataSource: DataSource!
    
    
    init(reminder: Reminder) {
        self.reminder = reminder
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        listConfiguration.showsSeparators = false
        listConfiguration.backgroundColor = .clear
        let listLayout = UICollectionViewCompositionalLayout.list(using: listConfiguration)
        super.init(collectionViewLayout: listLayout)
    }
    
    // viewController가 성공적으로 initialize가 되지 않는다면 결과가 nil을 담아 fatalError를 호출하도록 실행.
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 셀 등록 후 DataSource에 컬렉션 뷰에 등록시키면서 재사용 셀을 리턴시키게 설정.
        let cellRegistration = UICollectionView.CellRegistration(handler: cellRegistrationHandler)
        dataSource = DataSource(collectionView: collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: Row) in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        }
        collectionView.backgroundColor = .black
        
        navigationItem.title = NSLocalizedString("Reminder", comment: "Reminder view controller title")
        updateSnapshotForViewing()
    }
    
    func cellRegistrationHandler(cell: UICollectionViewListCell, indexPath: IndexPath, row: Row) {
        // 셀 속성
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = text(for: row)
        contentConfiguration.textProperties.color = .white
        contentConfiguration.textProperties.font = UIFont.preferredFont(forTextStyle: row.textStyle)
        contentConfiguration.image = row.image
        cell.contentConfiguration = contentConfiguration
        
        // 셀 배경색
        var backgroundConfiguration = UIBackgroundConfiguration.listGroupedCell()
        backgroundConfiguration.backgroundColor =  #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
        cell.backgroundConfiguration = backgroundConfiguration
        
//        cell.tintColor = .white
    }
    
    private func updateSnapshotForEditting() {
        var snapshot = Snapshot()
        snapshot.appendSections([.title, .date, .notes])
        dataSource.apply(snapshot)
    }
    
    private func updateSnapshotForViewing() {
        var snapshot = Snapshot()
        snapshot.appendSections([.view])
        snapshot.appendItems([.viewTitle, .viewDate, .viewTime, .viewNotes], toSection: .view)
        dataSource.apply(snapshot)
    }
    
    private func section(for indexPath: IndexPath) -> Section {
        let sectionNumber = isEditing ? indexPath.section + 1 : indexPath.section
        guard let section = Section(rawValue: sectionNumber) else {
            fatalError("Unable to find matching section")
        }
        return section
    }
    
    func text(for row: Row) -> String? {
        switch row {
        case .viewDate: return reminder.dueDate.dayText
        case .viewNotes: return reminder.notes
        case .viewTime: return reminder.dueDate.formatted(date: .omitted, time: .shortened)
        case .viewTitle: return reminder.title
        }
    }
}
