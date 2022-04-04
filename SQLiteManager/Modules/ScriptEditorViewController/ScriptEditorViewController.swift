//
//  ScriptEditorViewController.swift
//  SQLiteManager
//
//  Created by Vladyslav Baranov on 30.01.2022.
//

import UIKit

protocol ScriptEditorViewControllerDelegate: AnyObject {
    func finishWithError(_ error: String)
    func finishSuccess()
}

final class ScriptEditorViewController: UIViewController {
    
    weak var delegate: ScriptEditorViewControllerDelegate!
   
    var dbFile: DatabaseFile?
    
    private var replacementText = ""
    
    private var filterKey: String = ""
    private var symbolStart = 0
    private var workingRange = NSRange(location: 0, length: 0)
    
    private var allSymbols: [Symbol] = []
    private var suggestedSymbols: [Symbol] = []
    
    var syntaxStorage: SyntaxTextStorage!
    var textContainer: NSTextContainer!
    var textView: UITextView!
    
    var runButton: UIButton!
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSymbols()
        setupUI()
        
        setupCollectionView()
        symbolStart = textView.selectedRange.location
        // NotificationCenter.default.addObserver(
            // self, selector: #selector(keyboardFrameWillChangeNotification(_:)), name: UITextView.keyboardWillChangeFrameNotification, object: nil)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIView.animate(withDuration: 0.5) { [unowned self] in
            runButton.isHidden = true
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.5) { [unowned self] in
            runButton.isHidden = false
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        textContainer?.size = textView?.bounds.size ?? .zero
    }
}

extension ScriptEditorViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        let selectedRange = textView.selectedRange
        if selectedRange.location < workingRange.location {
            filterKey = ""
            symbolStart = selectedRange.location
        }
        if selectedRange.location > workingRange.location + workingRange.length + 1 {
            filterKey = ""
            symbolStart = selectedRange.location
        }
        
        // debugPrint("CHANGED SELECTION", filterKey, workingRange, symbolStart)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // debugPrint(filterKey, range, symbolStart)
        
        if trimmedText.isEmpty {
            if range.length > 0 {
                if filterKey.count >= range.length {
                    filterKey.removeLast(range.length)
                }
            } else {
                filterKey = trimmedText
                symbolStart = range.location
            }
        } else {
            if filterKey.isEmpty {
                symbolStart = range.location
            }
        }
        
        filterKey.append(trimmedText)
        
        var keywords = allSymbols.filter({ $0.value.starts(with: filterKey.lowercased()) })
        if keywords.isEmpty {
            keywords = allSymbols.filter({ $0.value.contains(filterKey.lowercased()) })
        }
        suggestedSymbols = keywords
        collectionView.reloadData()
        workingRange = range
        
        return true
    }
    
}
extension ScriptEditorViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if filterKey.isEmpty {
            return allSymbols.count
        } else {
            return suggestedSymbols.count
        }
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "id", for: indexPath) as! ScriptEditorViewCell
        let symbol = filterKey.isEmpty ? allSymbols[indexPath.row] : suggestedSymbols[indexPath.row]
        cell.symbol = symbol
        cell.layer.cornerRadius = 5
        cell.clipsToBounds = true
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let symbol = filterKey.isEmpty ? allSymbols[indexPath.row].value : suggestedSymbols[indexPath.row].value
        
        return .init(width: symbol.count > 10 ? 300 : 220, height: 30)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let symbolName = filterKey.isEmpty ? allSymbols[indexPath.row].value : suggestedSymbols[indexPath.row].value
        
        let newSelectedLocation = symbolStart + symbolName.count
        let start = textView.text.index(textView.text.startIndex, offsetBy: symbolStart)
        let end = textView.text.index(start, offsetBy: filterKey.count)
        
        textView.text.replaceSubrange(start..<end, with: symbolName)
        
        textView.selectedRange = .init(location: newSelectedLocation, length: 0)
    }
}

private extension ScriptEditorViewController {
    func loadSymbols() {
        let keywords = SymbolFactory.shared.keywords
        let types = SymbolFactory.shared.types
        let functions = SymbolFactory.shared.functions
        allSymbols.append(contentsOf: keywords.map { .init(value: $0, type: .keyword) })
        allSymbols.append(contentsOf: types.map { .init(value: $0, type: .datatype) })
        allSymbols.append(contentsOf: functions.map { .init(value: $0, type: .function) })
        allSymbols.sort { $0.value < $1.value }
    }
    func setupUI() {
        setupNavigationBar()
        setupTextView()
        setupRunButton()
        view.backgroundColor = .systemBackground
    }
    func setupTextView() {
        
        let syntaxStorage = SyntaxTextStorage()
        syntaxStorage.allSymbols = allSymbols
        
        let layoutManager = NSLayoutManager()
        
        textContainer = NSTextContainer(size: .zero)
        textContainer.widthTracksTextView = true
        
        layoutManager.addTextContainer(textContainer)
        syntaxStorage.addLayoutManager(layoutManager)
        
        textView = UITextView(frame: .zero, textContainer: textContainer)
        textView.text = "/* SELECT sqlite_version() */"
        textView.textColor = .label
        textView.backgroundColor = .systemBackground
        textView.delegate = self
        textView.font = .monospacedSystemFont(ofSize: 20, weight: .medium)
        view.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.autocorrectionType = .no
        textView.autocapitalizationType = .none
        textView.smartQuotesType = .no
        textView.smartDashesType = .no
        textView.smartInsertDeleteType = .no
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            textView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    func setupRunButton() {
        runButton = UIButton()
        runButton.layer.cornerRadius = 25
        runButton.backgroundColor = UIColor(red: 1, green: 1, blue: 0, alpha: 0.6)
        runButton.translatesAutoresizingMaskIntoConstraints = false
        let symbolConfig = UIImage.SymbolConfiguration(scale: .large)
        runButton.setImage(UIImage(systemName: "play.fill", withConfiguration: symbolConfig), for: .normal)
        runButton.tintColor = .systemYellow
        runButton.addTarget(self, action: #selector(runCode), for: .touchUpInside)
        view.addSubview(runButton)
        
        NSLayoutConstraint.activate([
            runButton.heightAnchor.constraint(equalToConstant: 50),
            runButton.widthAnchor.constraint(equalToConstant: 50),
            runButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            runButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
    func setupNavigationBar() {
        navigationItem.title = "Script Editor"
    }
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout() // UICollectionViewCompositionalLayout(section: createSection())
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView(
            frame: .init(x: 0, y: 0, width: 100, height: 40),
            collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(ScriptEditorViewCell.self, forCellWithReuseIdentifier: "id")
        collectionView.contentInset = .init(top: 0, left: 8, bottom: 0, right: 8)
        textView.inputAccessoryView = collectionView
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    @objc func runCode() {
        UIView.animate(withDuration: 0.3) { [unowned self] in
            view.layoutIfNeeded()
        }
        guard let script = textView.text else { return }
        guard let res = dbFile?.db?.execute(sql: script) else { return }
        switch res {
        case .success(_):
            delegate?.finishSuccess()
        case .failure(let err):
            switch err {
            case .common(let errorString):
                delegate?.finishWithError(errorString)
            }
        }
    }
    @objc func keyboardFrameWillChangeNotification(_ notification: Notification) {
        // guard let endRect = notification.userInfo?[UITextView.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        // guard let beginRect = notification.userInfo?[UITextView.keyboardFrameBeginUserInfoKey] as? CGRect else { return }
        // print(endRect, beginRect)
        //
        // let constant = endRect.origin.y < beginRect.origin.y ? endRect.height : 0
        // runButtonBottomAnchor.constant = -constant
        // UIView.animate(withDuration: 0.25) { [unowned self] in
        //     view.layoutIfNeeded()
        // }
    }
}
