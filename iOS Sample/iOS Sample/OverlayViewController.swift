//
//  OverlayViewController.swift
//  iOS Sample
//
//  Copyright (c) 2017 Kazuhiro Hayashi
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import UIKit
import PagingKit

class OverlayViewController: UIViewController {
    
    let dataSource: [(menu: String, content: UIViewController)] = ["New", "Hot", "Birthday", "Justin", "Justin", "Justin", "Justin", "Justin", "Justin", "End"].map {
        let title = $0
        let vc = UIStoryboard(name: "ContentTableViewController", bundle: nil).instantiateInitialViewController() as! ContentTableViewController
        return (menu: title, content: vc)
    }
    
    /*
     let dataSource: [(menu: (title: String, subTitle: String?, isEnabledPoo: Bool), content: UIViewController)] = [(title: "Martinez", subTitle: nil, isEnabledPoo: true), (title: "Alfred", subTitle: nil, isEnabledPoo: false), (title: "Louis", subTitle: "owner", isEnabledPoo: false), (title: "Justin", subTitle: nil, isEnabledPoo: false)].map {
     let title = $0.title
     let vc = UIStoryboard(name: "ContentTableViewController", bundle: nil).instantiateInitialViewController() as! ContentTableViewController
     return (menu: $0, content: vc)
     }
     
     lazy var firstLoad: (() -> Void)? = { [weak self, menuViewController, contentViewController] in
     menuViewController?.reloadData()
     contentViewController?.reloadData()
     self?.firstLoad = nil
     }
     */
    
    var menuViewController: PagingMenuViewController!
    var contentViewController: PagingContentViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
         menuViewController?.register(nib: UINib(nibName: "TwoLineMenuCell", bundle: nil), forCellWithReuseIdentifier: "identifier")
         menuViewController?.registerFocusView(view: OverlayFocusView(), isBehindCell: true)
         */
        
        menuViewController?.register(type: OverlayMenuCell.self, forCellWithReuseIdentifier: "identifier")
        menuViewController?.registerFocusView(view: OverlayFocusView(), isBehindCell: true)
        menuViewController?.reloadData(with: 0, completionHandler: { [weak self] (vc) in
            (self?.menuViewController.currentFocusedCell as! OverlayMenuCell)
                .updateMask(animated: false)

        })
        
        menuViewController.menuView.contentInset = UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 18)
        
        contentViewController?.scrollView.bounces = false
        //menuViewController.scrollView.contentInset = UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 18)
        contentViewController?.reloadData(with: 0)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // firstLoad?()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? PagingMenuViewController {
            menuViewController = vc
            menuViewController?.dataSource = self
            menuViewController?.delegate = self
        } else if let vc = segue.destination as? PagingContentViewController {
            contentViewController = vc
            contentViewController?.delegate = self
            contentViewController?.dataSource = self
        }
    }
}

extension OverlayViewController: PagingMenuViewControllerDataSource {
    
    func menuViewController(viewController: PagingMenuViewController, cellForItemAt index: Int) -> PagingMenuViewCell {
        
        let cell = viewController.dequeueReusableCell(withReuseIdentifier: "identifier", for: index)  as! OverlayMenuCell
        
        cell.configure(title: dataSource[index].menu, currentIndex: index)
        
        cell.referencedFocusView = viewController.focusView
        cell.referencedMenuView = viewController.menuView
        
        cell.currentTaga = index
        cell.updateMask()
        
        if index == 0 {
            cell.setBackgroundColor(getColor: .clear)
        } else {
            cell.setBackgroundColor(getColor: UIColor(red: 243/255, green: 241/255, blue: 244/255, alpha: 1))
        }
        
        /*
         let cell = viewController.dequeueReusableCell(withReuseIdentifier: "identifier", for: index)  as! TwoLineMenuCell
         cell.imageView.image = dataSource[index].menu.isEnabledPoo ? #imageLiteral(resourceName: "Poo") : nil
         cell.imageView.isHidden = !dataSource[index].menu.isEnabledPoo
         cell.titleLabel.text = dataSource[index].menu.title
         cell.subTitleLabel.text = dataSource[index].menu.subTitle
         */
        return cell
    }
    
    func menuViewController(viewController: PagingMenuViewController, widthForItemAt index: Int) -> CGFloat {
        
        if index == 0 {
            return 100
        } else if index == 1 {
            return 100
        }
        
        print("width \(OverlayMenuCell .sizingCell .calculateWidth(from: viewController.view.bounds.height, title: dataSource[index].menu, getIndex: index))")
        
        return OverlayMenuCell
            .sizingCell
            .calculateWidth(from: viewController.view.bounds.height, title: dataSource[index].menu, getIndex: index)
    }
    
    func numberOfItemsForMenuViewController(viewController: PagingMenuViewController) -> Int {
        return dataSource.count
    }
}


extension OverlayViewController: PagingContentViewControllerDataSource {
    func numberOfItemsForContentViewController(viewController: PagingContentViewController) -> Int {
        return dataSource.count
    }
    
    func contentViewController(viewController: PagingContentViewController, viewControllerAt index: Int) -> UIViewController {
        return dataSource[index].content
    }
}

extension OverlayViewController: PagingMenuViewControllerDelegate {
    func menuViewController(viewController: PagingMenuViewController, didSelect page: Int, previousPage: Int) {
        contentViewController?.scroll(to: page, animated: true)
    }
    
    func menuViewController(viewController: PagingMenuViewController, willAnimateFocusViewTo index: Int, with coordinator: PagingMenuFocusViewAnimationCoordinator) {
        
        viewController.visibleCells.compactMap { $0 as? OverlayMenuCell }.forEach { cell in
            cell.updateMask()
            
            if index == cell.currentTaga {
                cell.setBackgroundColor(getColor: .clear)
            } else {
                cell.setBackgroundColor(getColor: UIColor(red: 243/255, green: 241/255, blue: 244/255, alpha: 1))
            }
        }
        
        coordinator.animateFocusView(alongside: { coordinator in
            viewController.visibleCells.compactMap { $0 as? OverlayMenuCell }.forEach { cell in
                cell.updateMask()
                
                if index == cell.currentTaga {
                    cell.setBackgroundColor(getColor: .clear)
                } else {
                   cell.setBackgroundColor(getColor: UIColor(red: 243/255, green: 241/255, blue: 244/255, alpha: 1))
                }
            }
        }, completion: nil)
        
    }
    
    func menuViewController(viewController: PagingMenuViewController, willDisplay cell: PagingMenuViewCell, forItemAt index: Int) {
        
        (cell as? OverlayMenuCell)?.updateMask()
    }
}

extension OverlayViewController: PagingContentViewControllerDelegate {
    func contentViewController(viewController: PagingContentViewController, didManualScrollOn index: Int, percent: CGFloat) {
        
        print("selected index \(index) percent \(percent * 100)")
        
        menuViewController.scroll(index: index, percent: percent, animated: false)
        menuViewController.visibleCells.forEach {
            let cell = $0 as! OverlayMenuCell
            
            cell.updateMask()
            
            if index == cell.currentTaga {
                cell.setBackgroundColor(getColor: .clear)
            } else {
                cell.setBackgroundColor(getColor: UIColor(red: 243/255, green: 241/255, blue: 244/255, alpha: 1))
            }
        }
    }
}
