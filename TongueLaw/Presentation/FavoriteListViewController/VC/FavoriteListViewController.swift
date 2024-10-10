//
//  FavoriteListViewController.swift
//  TongueLaw
//
//  Created by 최승범 on 10/10/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class FavoriteListViewController: UIViewController {
    
    private lazy var favoriteListCollectionView = UICollectionView(frame: .zero,
                                                                   collectionViewLayout: createCollectionViewLayout())
    private let viewModel = FavoriteListViewModel()
    private var swipeAction = PublishSubject<IndexPath>()
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        bind()
    }
    
    private func bind() {
        let load = BehaviorSubject<Void>(value: ())
        
        let input = FavoriteListViewModel.Input(fetchData: load, deleteSwipe: swipeAction)
        let output = viewModel.transform(input)
        
        output.list
            .bind(with: self, onNext: { owner, value in
                owner.favoriteListCollectionView.reloadData()
            })
            .disposed(by: disposeBag)
        
        output.deleteComplete
            .bind(with: self) { owner, value in
                owner.favoriteListCollectionView.deleteItems(at: [value])
            }
            .disposed(by: disposeBag)
    }
}

//MARK: - CollectionViewDelegate, CollectionViewDataSource

extension FavoriteListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.favoriteList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieListCollectionViewCell.identifier, for: indexPath) as? MovieListCollectionViewCell else {
            return MovieListCollectionViewCell()
        }
        
        cell.setFavoriteContent(viewModel.favoriteList[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TitleCollectionViewHeader.identifier, for: indexPath) as? TitleCollectionViewHeader else {
            return UICollectionReusableView()
        }
        
        header.updateContent(title: FavoriteListCollectionViewSections.list(deleteAction: { _ in
           
        }).title)
        
        return header
    }

}

//MARK: - Configuration
extension FavoriteListViewController: BaseViewProtocol {
    
    func configureHierarchy() {
        view.addSubview(favoriteListCollectionView)
    }
    
    func configureUI() {
        view.backgroundColor = .white
        configureCollectionView()
    }
    
    func configureLayout() {
        favoriteListCollectionView.snp.makeConstraints { make in
            make.directionalEdges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func configureCollectionView() {
        favoriteListCollectionView.dataSource = self
        
        favoriteListCollectionView.register(MovieListCollectionViewCell.self, forCellWithReuseIdentifier: MovieListCollectionViewCell.identifier)
        favoriteListCollectionView.register(TitleCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TitleCollectionViewHeader.identifier)
    }
    
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        FavoriteListCollectionViewSections.list { [weak self] indexPath in
            guard let self else { return }
            
            self.swipeAction.onNext(indexPath)
        }.layout
    }
    
}

extension FavoriteListViewController {
    
    enum FavoriteListCollectionViewSections {
        
        case list(deleteAction: (IndexPath) -> ())
        
        var title: String {
            switch self {
            case .list:
                "영화 시리즈"
            }
        }
        
        var layout: UICollectionViewLayout {
            switch self {
            case .list(let delete):
                var layoutConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
                
                layoutConfiguration.trailingSwipeActionsConfigurationProvider = { indexPath in
                    
                    let deleteAction = UIContextualAction(style: .normal,
                                                          title: nil) { action, view, completion in
                        delete(indexPath)
                        completion(true)
                    }
                    
                    deleteAction.image = UIImage(systemName: "trash")
                    deleteAction.backgroundColor = .red
                    
                    let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
                    configuration.performsFirstActionWithFullSwipe = false
                    
                    return configuration
                }
                
                layoutConfiguration.showsSeparators = false
                layoutConfiguration.headerMode = .supplementary
                layoutConfiguration.backgroundColor = .systemBackground
                
                let layout = UICollectionViewCompositionalLayout.list(using: layoutConfiguration)
                
                return layout
            }
        }
        
    }
    
}
