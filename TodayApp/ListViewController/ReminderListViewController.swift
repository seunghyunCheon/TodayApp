//
//  ViewController.swift
//  TodayApp
//
//  Created by 천승현 on 2022/08/01.
//

import UIKit

class ReminderListViewController: UICollectionViewController {

    // Diffable Data Source를 사용함으로써 테이블뷰에 데이터가 변화되는 것과 UI가 업데이트 되는 것을 동기화 시킬 수 있다.
    // 즉 기존에는 동기화가 잘 되지 않아 크래시를 막기 위해 reloadData()를 사용했지만 이를 이용하면, apply메서드만으로 동기화가 가능해진다.
    
    
    var dataSource: DataSource!
    var reminders: [Reminder] = Reminder.sampleData
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .black
        let listLayout = listLayout()
        collectionView.collectionViewLayout = listLayout
        
        let cellRegistration = UICollectionView.CellRegistration(handler: cellRegisterationHandler)
        
        dataSource = DataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, itemIdentifier: Reminder.ID) in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        })
        
        // data state를 담는 초기 snapShot을 정의
        var snapshot = SnapShot()
        snapshot.appendSections([0])
        snapshot.appendItems(reminders.map{ $0.id })
        dataSource.apply(snapshot)
        collectionView.dataSource = dataSource
    }

    
    private func listLayout() -> UICollectionViewCompositionalLayout {
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
        listConfiguration.showsSeparators = false
        listConfiguration.backgroundColor = .clear
        return UICollectionViewCompositionalLayout.list(using: listConfiguration)
    }

}

