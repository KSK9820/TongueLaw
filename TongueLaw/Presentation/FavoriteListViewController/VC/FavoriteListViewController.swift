//
//  FavoriteListViewController.swift
//  TongueLaw
//
//  Created by 최승범 on 10/10/24.
//

import UIKit
import SnapKit

final class FavoriteListViewController: UIViewController {
    
    private lazy var favoriteListCollectionView = UICollectionView(frame: .zero,
                                                                   collectionViewLayout: createCollectionViewLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
}

//MARK: - CollectionViewDelegate, CollectionViewDataSource

extension FavoriteListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieListCollectionViewCell.identifier, for: indexPath) as? MovieListCollectionViewCell else {
            return MovieListCollectionViewCell()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TitleCollectionViewHeader.identifier, for: indexPath) as? TitleCollectionViewHeader else {
            return TitleCollectionViewHeader()
        }
        
        header.updateContent(title: FavoriteListCollectionViewSections.list.title)
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigationController?.pushViewController(DetailViewController(), animated: true)
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
        favoriteListCollectionView.delegate = self
        favoriteListCollectionView.dataSource = self
        
        favoriteListCollectionView.register(MovieListCollectionViewCell.self, forCellWithReuseIdentifier: MovieListCollectionViewCell.identifier)
        favoriteListCollectionView.register(TitleCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TitleCollectionViewHeader.identifier)
    }
    
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        FavoriteListCollectionViewSections.list.layout
    }
    
}

//MARK: - FavoriteListCollectionViewSections
private enum FavoriteListCollectionViewSections {
    
    case list
    
    var title: String {
        switch self {
        case .list:
            "영화 시리즈"
        }
    }
    
    var layout: UICollectionViewLayout {
        switch self {
        case .list:
            var layoutConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
            
            layoutConfiguration.trailingSwipeActionsConfigurationProvider = { indexPath in
                
                let deleteAction = UIContextualAction(style: .normal,
                                                      title: nil) { action, view, completion in
                    // 삭제로직
                    completion(true)
                }
                
                deleteAction.image = UIImage(systemName: "trash")
                deleteAction.backgroundColor = .red
                
                let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
                configuration.performsFirstActionWithFullSwipe = false
                
                return configuration
            }
            
            layoutConfiguration.showsSeparators = false
            let layout = UICollectionViewCompositionalLayout.list(using: layoutConfiguration)
            
            return layout
        }
    }
    
}
