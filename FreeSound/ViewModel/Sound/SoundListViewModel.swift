//
//  SoundListViewModel.swift
//  FreeSound
//
//  Created by Anton Shcherba on 3/9/18.
//  Copyright © 2018 Anton Shcherba. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SoundListViewModel {
    
    let bag = DisposeBag()
    
    let searchText = Variable("")
    
    let filterParameter: Variable<FilterParameter?> = Variable(nil)
    
    let sortParameter: Variable<SortParameter?> = Variable(nil)
    
    let loader = SoundLoader()
    
    lazy var sounds: Driver<[SoundInfo]> = {
        return Observable.combineLatest(searchText.asObservable(), sortParameter.asObservable(), filterParameter.asObservable())
            .throttle(1, scheduler: MainScheduler.instance)
            .flatMapLatest({
                self.searchSoundWith(text: $0, sortParameter: $1, filterParameter: $2)
            }).asDriver(onErrorJustReturn: [])
        
//        return self.searchText.asObservable().flatMapLatest {
//            self.searchSoundWith(text: $0, sortParameter: nil, filterParameter: nil)
//        }.asDriver(onErrorJustReturn: [])
    }()
    
    func searchSoundWith(text: String, sortParameter: SortParameter?, filterParameter: FilterParameter?) -> Observable<[SoundInfo]> {
        let aaa = PublishSubject<[SoundInfo]>()
        
        loader.searchSoundWith(text, sortParameter: sortParameter, filterParameter: filterParameter) { (sounds) in
            if sounds.count <= 0 {
                return
            }
            //            self.sounds = sounds
//            self.sounds.value = sounds
            
            aaa.onNext(sounds)
//            DispatchQueue.main.async(execute: { [unowned self] in
//                UIApplication.shared.isNetworkActivityIndicatorVisible = false
//                self.tableView.reloadData()
            
//            }
        }
        
        return aaa.asObservable()
    }
}
