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
    
//    lazy var sounds: Driver<[SoundInfo]> = {
//        return Observable.combineLatest(searchText.asObservable(), sortParameter.asObservable(), filterParameter.asObservable())
//            .throttle(1, scheduler: MainScheduler.instance)
//            .flatMapLatest({
//                self.searchSoundWith(text: $0, sortParameter: $1, filterParameter: $2)
//            }).asDriver(onErrorJustReturn: [])
//        
////        return self.searchText.asObservable().flatMapLatest {
////            self.searchSoundWith(text: $0, sortParameter: nil, filterParameter: nil)
////        }.asDriver(onErrorJustReturn: [])
//    }()
    
    lazy var sounds: Driver<[Result]> = {
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
        
        let obs: Observable<[SoundInfo]> = loader.searchSoundWith(text, sortParameter: sortParameter, filterParameter: filterParameter)
        
        obs.subscribe(onNext: ({ (sounds) in
            if sounds.count <= 0 {
                return
            }
            
            aaa.onNext(sounds)
        })).disposed(by: bag)
        
        return aaa.asObservable()
    }
    
    func searchSoundWith(text: String, sortParameter: SortParameter?, filterParameter: FilterParameter?) -> Observable<[Result]> {
        let aaa = PublishSubject<[Result]>()
        
        let obs: Observable<[Result]> = loader.searchSoundWith(text, sortParameter: sortParameter, filterParameter: filterParameter)
        
        obs.subscribe(onNext: ({ (sounds) in
            if sounds.count <= 0 {
                return
            }
            
            aaa.onNext(sounds)
        })).disposed(by: bag)
        
        return aaa.asObservable()
    }
}
