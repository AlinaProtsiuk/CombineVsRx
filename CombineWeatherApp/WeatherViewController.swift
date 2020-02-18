//
//  NewViewController.swift
//  CombineWeatherApp
//
//  Created by Alina Protsiuk on 14.02.2020.
//  Copyright © 2020 CoreValue. All rights reserved.
//

import UIKit
import Combine
import RxSwift
import RxCocoa

class WeatherViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel = WeatherViewModel()
    var searchBarCancellable: AnyCancellable?
    var fetcherCancellable: AnyCancellable?
    
    private let disposeBag = DisposeBag()
    
    private var dataSource: UITableViewDiffableDataSource<Section, WeatherRowViewModel>!
    
    var data = [WeatherRowViewModel]() {
        didSet {
            createSnapshot()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: - UITableViewDiffableDataSource
//        dataSource = UITableViewDiffableDataSource<Section, WeatherRowViewModel>(tableView: tableView, cellProvider: { (tableView, indexPath, item) -> UITableViewCell? in
//            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
//            cell?.textLabel?.text = item.fullDescription
//            cell?.detailTextLabel?.text = item.temperature
//            if let iconName = item.icon {
//                cell?.imageView?.load(by: iconName)
//            }
//            return cell
//        })
        
        //MARK: - Combine Framework
//        fetcherCancellable = viewModel.$data
//            .print("ViewModel")
//            .assign(to: \.data, on: self)
//
//        searchBarCancellable = NotificationCenter.Publisher(center: .default, name: UITextField.textDidChangeNotification, object: searchBar.searchTextField)
//            .map({ ($0.object as? UITextField)?.text ?? ""})
//            .sink(receiveValue: { (value) in
//                self.viewModel.fetchData(for: value)
//            })
        
        //MARK: - RxSwift Framework
        
        searchBar.rx.text.orEmpty
            .throttle(.microseconds(3000), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] (text) in
                self?.viewModel.fetchRxData(for: text)
            }).disposed(by: disposeBag)


        viewModel.listData.bind(to: tableView.rx.items(cellIdentifier: "Cell")) { (index, model, cell) in
            cell.textLabel?.text = model.fullDescription
            cell.detailTextLabel?.text = model.temperature
            if let iconName = model.icon {
                cell.imageView?.loadWithRx(by: iconName)
                    .map({ $0 == true })
                    .subscribeOn(MainScheduler.instance)
                    .subscribe({ (_) in
                        self.tableView.reloadData()
                    })
                    .disposed(by: self.disposeBag)
            }
        }.disposed(by: disposeBag)
        
    }
    
    func createSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, WeatherRowViewModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(data)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

//MARK: - UITableViewDataSource
//extension WeatherViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return data.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
//        let item = data[indexPath.row]
//        cell?.textLabel?.text = item.weather?.first?.description
//        cell?.detailTextLabel?.text =  String(format: "%.1f", item.temp?.day ?? 0)
//        return cell!
//    }
//}

extension WeatherViewController {
    fileprivate enum Section {
        case main
    }
}



