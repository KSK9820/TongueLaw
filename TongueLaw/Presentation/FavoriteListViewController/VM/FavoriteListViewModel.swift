//
//  FavoriteListViewModel.swift
//  TongueLaw
//
//  Created by 김수경 on 10/10/24.
//

import Foundation
import RxSwift
import RxCocoa

final class FavoriteListViewModel {
    
    private let coredataManager = FavoriteManager()
    private let disposeBag = DisposeBag()
    private(set) var favoriteList = [FavoriteContent]()
    
    struct Input {
        let fetchData: BehaviorSubject<Void>
        let deleteSwipe: PublishSubject<IndexPath>
    }
    
    struct Output {
        let list: PublishSubject<Void>
        let deleteComplete: PublishSubject<IndexPath>
    }
    
    func transform(_ input: Input) -> Output {
        var header = BehaviorSubject<String>(value: "")
        var readData = PublishSubject<Void>()
        var deleteData = PublishSubject<IndexPath>()
        
        input.fetchData
            .bind(with: self) { owner, _ in
                if let favoriteContents = owner.coredataManager.fetchAllFavoriteObject() {
                    owner.favoriteList = favoriteContents
                    readData.onNext(())
                }
            }
            .disposed(by: disposeBag)
        
        input.deleteSwipe
            .bind(with: self) { owner, indexPath in
                let content = owner.favoriteList[indexPath.row]
                if owner.coredataManager.deleteFavoriteObject(withId: content.id) {
                    owner.favoriteList.remove(at: indexPath.row)
                    deleteData.onNext(indexPath)
                }
            }
        
        return Output(list: readData, deleteComplete: deleteData)
    }
    
}
