//
//  DatabaseInfoViewController.swift
//  SQLiteManager
//
//  Created by Vladyslav Baranov on 31.01.2022.
// NotificationCenter


import SwiftUI

final class DatabaseInfoViewController: UICollectionViewController {
    
    struct Category {
        
        struct Entity {
            var name: String
            var numberOfColumns: Int?
            var numberOfRecordings: Int?
        }
        
        let title: String
        var entities: [TableInfoEntity]
    }
    
    private let layoutManager = ViewControllerLayoutManager()
    
    var categories: [Category] = [
        .init(title: "Tables", entities: []),
        .init(title: "Views", entities: []),
        .init(title: "Triggers", entities: []),
        .init(title: "Indexes", entities: [])
    ]

    var dbFile: DatabaseFile?
    
    func createSection(windowFrame: CGRect, traitCollection: UITraitCollection, cellHeightRatio: CGFloat) -> NSCollectionLayoutSection {
        
        let cellsPerRow = layoutManager.cellsForRow(windowFrame: windowFrame, traitCollection: traitCollection)

        let fraction: CGFloat = 1 / CGFloat(cellsPerRow)
        let inset = 10.0
        // Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(fraction), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        item.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
        // Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(fraction * cellHeightRatio))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
        
        let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50))
        let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize, elementKind: "header", alignment: .top)
        section.boundarySupplementaryItems = [headerItem]
        return section
    }
    
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [unowned self] sectionIndex, environment in
            return createSection(
                windowFrame: view.frame,
                traitCollection: environment.traitCollection,
                cellHeightRatio: sectionIndex < 1 ? 0.5 : 0.25)
        }
        return layout
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = dbFile?.dbName
        navigationController?.navigationBar.prefersLargeTitles = true
        collectionView.register(DatabaseInfoCollectionViewCell.self, forCellWithReuseIdentifier: "id")
        collectionView.register(DatabaseInfoHeaderView.self, forSupplementaryViewOfKind: "header", withReuseIdentifier: "header")
        collectionView.collectionViewLayout = createLayout()
        
        openDatabase()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshData()
        collectionView.reloadData()
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! DatabaseInfoHeaderView
        view.title = categories[indexPath.section].title
        view.section = indexPath.section
        if indexPath.section == 0 {
            view.trailingItemType = .writeScript
        } else {
            view.trailingItemType = .none
        }
        view.delegate = self
        return view
    }
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        categories.count
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categories[section].entities.isEmpty ? 0 : categories[section].entities.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "id", for: indexPath) as! DatabaseInfoCollectionViewCell
        
        let entities = categories[indexPath.section].entities
        if entities.isEmpty {
            cell.title = "Trigger"
        } else {
            let item = entities[indexPath.row]
            cell.title = item.name
            if let tableInfo = item as? TableInfo {
                cell.value1 = "Number of columns: \(tableInfo.fields.count)"
                cell.value2 = "Number of recordings: \(tableInfo.numberOfRows)"
            }
        }
    
        if indexPath.section == 0 {
            cell.mode = .titleTwoValues
        } else {
            cell.mode = .title
        }
        
        // cell.titleLabel.text = item
        // cell.backgroundColor = RandomColorGenerator.getColor(interfaceStyle: traitCollection.userInterfaceStyle)
        //
        // if entities.isEmpty {
        //     cell.setDefaultContent()
        //     if indexPath.section <= 1 {
        //         cell.mode = .titleTwoValues
        //     } else {
        //         cell.mode = .title
        //     }
        //     cell.backgroundColor = .systemGray5
        // } else {
        //     let item = entities[indexPath.row]
        //     print("DEQ VALUE: ", item)
        //     cell.mode = .titleTwoValues
        //     cell.titleLabel.text = item
        cell.backgroundColor = RandomColorGenerator.getColor(interfaceStyle: traitCollection.userInterfaceStyle)
        //
        // }
        
        cell.layer.cornerCurve = .continuous
        cell.layer.cornerRadius = 10
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = indexPath.section
        if section == 0 {
            if let table = categories[indexPath.section].entities[indexPath.row] as? TableInfo {
                let hostingController = UIHostingController<TableInfoView>(rootView: TableInfoView(tableInfo: table))
                present(hostingController, animated: true)
            }
        } else {
            if let entity = categories[indexPath.section].entities[indexPath.row] as? SingleNamedInfo {
                let hostingController = UIHostingController<ViewTriggerIndexView>(rootView: ViewTriggerIndexView(entity: entity))
                present(hostingController, animated: true)
            }
        }
    }
    deinit {
        closeDatabase()
        print(type(of: self), "deinit")
    }
}

private extension DatabaseInfoViewController {
    func refreshData() {
        guard let db = dbFile?.db else { return }
        
        let tables = db.fetchTables()
        categories[0].entities = tables
        
        let views = db.fetchEntities(type: "view")
        categories[1].entities = views
        
        let triggers = db.fetchEntities(type: "trigger")
        categories[2].entities = triggers
        
        let indexes = db.fetchEntities(type: "index")
        categories[3].entities = indexes
    }
    func openDatabase() {
        guard let db = dbFile?.db else { return }
        db.open()
    }
    func closeDatabase() {
        dbFile?.db?.close()
    }
}

extension DatabaseInfoViewController: DatabaseInfoHeaderViewDelegate {
    func didTapTrailingButton(section: Int) {
        let vc = ScriptPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: [:])
        vc.dbFile = dbFile
        navigationController?.pushViewController(vc, animated: true)
    }
}
