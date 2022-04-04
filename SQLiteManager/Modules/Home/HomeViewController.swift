//
//  ViewController.swift
//  SQLiteManager
// Sample Database
//  Created by Vladyslav Baranov on 29.01.2022.
//

import UIKit

class HomeViewController: UICollectionViewController {

    private var emptyLabel: UILabel!
    
    private let layoutManager = ViewControllerLayoutManager()

    var items: [DatabaseFile] = []
    
    func createSection(windowFrame: CGRect, traitCollection: UITraitCollection) -> NSCollectionLayoutSection {
        let cellsPerRow = layoutManager.cellsForRow(windowFrame: windowFrame, traitCollection: traitCollection)
        
        let fraction: CGFloat = 1 / CGFloat(cellsPerRow)
        let inset = layoutManager.cellSpacing
        // Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(fraction), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        item.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
        // Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(fraction / 2))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
        return section
    }
    
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [unowned self] sectionIndex, environment in
            return createSection(windowFrame: view.frame, traitCollection: environment.traitCollection)
        }
        return layout
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // reloadSizes()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        prepareDatabases()
        NotificationCenter.default.addObserver(self, selector: #selector(handlePasscodeLockNotification(notification:)), name: .passcodeLockToBeDismissed, object: nil)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        emptyLabel.center = view.center
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "id", for: indexPath) as! CollectionViewCell
        let db = items[indexPath.row]
        cell.indexPath = indexPath
        cell.set(dbName: db.dbName ?? "--", date: db.creationDate ?? .init(), size: db.sizeInBytes ?? 0)
        cell.delegate = self
        cell.backgroundColor = RandomColorGenerator.getColor(interfaceStyle: traitCollection.userInterfaceStyle) // .black
        cell.layer.cornerCurve = .continuous
        cell.layer.cornerRadius = 10
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // let vc = ScriptPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: [:])
        // navigationController?.pushViewController(vc, animated: true)
        
        let vc = PasscodeLockViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
        
        
    }
    
}

@objc extension HomeViewController {
    func createDatabase() {
        let vc = DatabaseCRUDViewController(style: .insetGrouped)
        vc.mode = .create
        vc.delegate = self
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true, completion: nil)
    }
    func handlePasscodeLockNotification(notification: Notification) {
        if let integer = notification.object as? Int {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) { [unowned self] in
                let vc = DatabaseInfoViewController(collectionViewLayout: UICollectionViewFlowLayout())
                vc.dbFile = items[integer]
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

private extension HomeViewController {
    func setupUI() {
        navigationController?.navigationBar.tintColor = .label
        navigationItem.title = "Databases"
        navigationItem.backButtonTitle = ""
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "id")
        // collectionView.contentInset = .init(top: 0, left: layoutManager.cellSpacing, bottom: 0, right: layoutManager.cellSpacing)
        collectionView.collectionViewLayout = createLayout()
        
        let createItem = UIBarButtonItem(
            image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(createDatabase))
        createItem.tintColor = .systemYellow
        
        let editItem = UIBarButtonItem(
            image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: nil, action: nil)
        editItem.tintColor = .systemYellow
        navigationItem.rightBarButtonItems = [editItem, createItem]
        
        emptyLabel = UILabel()
        emptyLabel.text = "There are no databases yet"
        emptyLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        emptyLabel.sizeToFit()
        view.addSubview(emptyLabel)
        // Do any additional setup after loading the view.
    }
    
    func prepareDatabases() {
        let dbNames = DatabaseFileManager.shared.getDatabaseNames()
        
        switch dbNames {
        case .success(let names):
            if names.isEmpty {
                emptyLabel.isHidden = false
            } else {
                emptyLabel.isHidden = true
                items = names.map { .init(name: $0) }.compactMap { $0 }
                collectionView.reloadData()
            }
        case .failure(_):
            break
        }
    }
    func reloadSizes() {
        for file in items {
            file.reloadSize()
        }
        collectionView.reloadData()
        print("RELOAD SIZES")
    }
}

extension HomeViewController: DatabaseCRUDViewControllerDelegate {
    func databaseCreated(name: String) {
        items.insert(.init(name: name)!, at: 0)
        collectionView.reloadSections(.init(integer: 0))
        emptyLabel.isHidden = !items.isEmpty
    }
    func didDeleteDatabase(name: String) {
        items.removeAll { $0.dbName == name }
        collectionView.reloadSections(.init(integer: 0))
        emptyLabel.isHidden = !items.isEmpty
    }
}

extension HomeViewController: CollectionViewCellDelegate {
    func didTapInfoButton(for indexPath: IndexPath) {
        print(indexPath)
        let vc = DatabaseCRUDViewController(style: .insetGrouped)
        vc.delegate = self
        vc.dbFile = items[indexPath.row]
        vc.mode = .edit
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true, completion: nil)
    }
}
