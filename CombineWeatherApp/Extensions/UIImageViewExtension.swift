//
//  UIImageViewExtension.swift
//  CombineWeatherApp
//
//  Created by Alina Protsiuk on 18.02.2020.
//  Copyright © 2020 CoreValue. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension UIImageView {
    func load(by icon: String) {
        guard let url = URL(string: "http://openweathermap.org/img/w/" + icon + ".png") else { return }
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
    
    func loadWithRx(by icon: String) -> Observable<Bool> {
        let url = URL(string: "http://openweathermap.org/img/w/" + icon + ".png")
        return Observable<Bool>.create { (observer)  in
            DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: url!) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self?.image = image
                            observer.onNext(true)
                        }
                    }
                } else {
                    observer.onNext(false)
                }
            }
            return Disposables.create()
        }
    }
}
