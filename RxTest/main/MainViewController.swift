//
//  ViewController.swift
//  RxTest
//
//  Created by ayur on 20.12.2018.
//  Copyright © 2018 ayur. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MainViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    let disposeBag = DisposeBag()
    
    let cellId = "cell_main"
    
    let segueId = "segue_main"
    
    var tableData: Variable<[MainModel]> = Variable([
            MainModel(text: "Sample1"),
            MainModel(text: "Sample2"),
            MainModel(text: "Sample3"),
            MainModel(text: "Sample4"),
            MainModel(text: "Sample5"),
            MainModel(text: "Sample6"),
            MainModel(text: "Sample7")
        ])
    
    var searchedTableData = [MainModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        setupRx()
    }
    
    func setupView() {
        tableView.dataSource = nil // rxswift bind
        tableView.delegate = self
    }
    
    func setupRx() {
        searchBar
            .rx.text
            .orEmpty
            .debounce(1, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .filter { !$0.isEmpty }
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { (next) in
                print("subscribe - next: " + next)
//                tableData
//                    .asObservable()
                //self.mainFilter(query: next)
                self.tableData
                    .asObservable()
                    .filter { ($0.first?.text?.hasPrefix(next))! }
                    .map({ $0.first?.text?.hasPrefix(($0.first?.text)!) })
                    .subscribe(onNext: { mainModel in
                        //mainModel.first?.text!.hasPrefix(next)
                    }, onError: { (Error) in
                        
                    }, onCompleted: {
                        self.tableView.reloadData()
                    }, onDisposed: {
                        
                    })
                    .disposed(by: self.disposeBag)
            }, onError: { (error) in
                print("subscribe - error: " + error.localizedDescription)
            }, onCompleted: {
                print("subscribe - completed")
            }, onDisposed: {
                print("subscribe - disposed")
            })
            .disposed(by: disposeBag)
        
        tableData
            .asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: cellId, cellType: MainTableViewCell.self)) { row, element, cell in
                cell.mText.text = element.text
            }
            .disposed(by: disposeBag)
    }
    
    
//    func mainFilter(query: String) {
//        searchedTableData = tableData.filter({ mainModel -> Bool in
//            return (mainModel.text?.lowercased().contains(query.lowercased()))!
//        })
//        reloadUI()
//    }
    
    func reloadUI() {
        tableView.reloadData()
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchBar.text?.isEmpty ?? true
    }
}

//extension MainViewController: UITableViewDataSource {
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if (searchBarIsEmpty()) {
//            return tableData.count
//        }
//        return searchedTableData.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MainTableViewCell
//        //let model = tableData[indexPath.row]
//        if (searchBarIsEmpty()) {
//            let model = tableData[indexPath.row]
//            setupCell(cell, model)
//            return cell
//        }
//        let model = searchedTableData[indexPath.row]
//        setupCell(cell, model)
//
//        return cell
//    }
//
//    func setupCell(_ cell: MainTableViewCell, _ model: MainModel) {
//        cell.mText.text = model.text
//    }
//}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension MainViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == segueId,
            let destination = segue.destination as? DetailViewController,
            let cellIndex = tableView.indexPathForSelectedRow?.row
        {
//            destination.content = ClubDetailContent(
//                image: (tableView.cellForRow(at: tableView.indexPathForSelectedRow!) as! ClubTableViewCell).mImage.image!,
//                title: clubs.clubs[cellIndex].name,
//                owner: clubs.clubs[cellIndex].owner.surname,
//                text: clubs.clubs[cellIndex].info)
        }
    }
}
