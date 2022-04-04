//
//  ScriptPageViewController.swift
//  SQLiteManager
//
//  Created by Vladyslav Baranov on 30.01.2022.
//

import UIKit

final class ScriptPageViewController: UIPageViewController {
    
    var dbFile: DatabaseFile?
    
    var topLabel: UILabel!
    var pageControl: UIPageControl!
    var orderedViewControllers: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
        
        // navigationController?.navigationBar.prefersLargeTitles = false
        // navigationItem.title = "Script Editor"
        view.backgroundColor = .systemBackground
        dataSource = self
        delegate = self
        if let firstVC = orderedViewControllers.first {
            setViewControllers(
                [firstVC],
                direction: .forward,
                animated: true,
                completion: nil)
        }
        setupPageControl()
        
        topLabel = UILabel()
        topLabel.text = "Script Editor"
        topLabel.font = .boldSystemFont(ofSize: UIFont.labelFontSize)
        view.addSubview(topLabel)
        topLabel.sizeToFit()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        topLabel.center = .init(
            x: view.bounds.midX,
            y: navigationController?.navigationBar.bounds.midY ?? 40 - topLabel.bounds.height / 2)
    }
    func setupViewControllers() {
        let vc1 = ScriptEditorViewController()
        vc1.delegate = self
        vc1.dbFile = dbFile
        
        let vc2 = ScriptResultViewController()
        orderedViewControllers = [vc1, vc2]
    }
    func setupPageControl() {
        pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = .label
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.numberOfPages = 2
        pageControl.currentPage = 0
        view.addSubview(pageControl)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
    }
}
extension ScriptPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else {
            return nil
        }
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        return orderedViewControllers[nextIndex]
    }
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let currentVC = pageViewController.viewControllers?.first else { return }
        guard let index = orderedViewControllers.firstIndex(of: currentVC) else { return }
        pageControl.currentPage = index

        if completed {
            let transition = CATransition()
            transition.type = .push
            transition.subtype = index == 0 ? .fromLeft : .fromRight
            transition.duration = 0.3
            topLabel.layer.add(transition, forKey: "transition")
            topLabel.text = index == 0 ? "Script Editor" : "Output"
            topLabel.sizeToFit()
        }
    }
}
extension ScriptPageViewController: ScriptEditorViewControllerDelegate {
    func finishWithError(_ error: String) {
        let resultsVC = orderedViewControllers[1]
        setViewControllers(
            [resultsVC],
            direction: .forward,
            animated: true) { _ in
                (resultsVC as? ScriptResultViewController)?.displayError(error: error)
            }
        
    }
    func finishSuccess() {
        let resultsVC = orderedViewControllers[1]
        setViewControllers(
            [resultsVC],
            direction: .forward,
            animated: true) { _ in
                (resultsVC as? ScriptResultViewController)?.displayResult()
            }
    }
}
