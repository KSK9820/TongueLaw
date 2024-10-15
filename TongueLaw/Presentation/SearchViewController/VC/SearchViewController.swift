//
//  SearchViewController.swift
//  TongueLaw
//
//  Created by 최승범 on 10/10/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SearchViewController: UIViewController {
    
    private let viewModel = SearchViewModel()
    
    private let searchBar = UISearchBar()
    private lazy var searchCollectionView = UICollectionView(frame: .zero,
                                                             collectionViewLayout: createCollectionViewLayout())
    private var prefetchAction = PublishSubject<Void>()
    
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        bind()
    }
    
    private func bind() {
        let searchKeyword = searchBar.rx.text
            .orEmpty
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
        let prefetchAction = ControlEvent<Void>(events: prefetchAction)
        let mergedSearchKeyword = Observable.merge(searchKeyword, prefetchAction.withLatestFrom(searchKeyword))
        let noResult = PublishSubject<Void>()
            
        let input = SearchViewModel.Input(searchText: mergedSearchKeyword, emptySearchResult: noResult)
        let output = viewModel.transform(input)
        
        output.search
            .drive(with: self) { owner, value in
                if owner.viewModel.searchResult.count > 0 && owner.viewModel.searchResult[0].totalResults > 0 {
                    owner.searchCollectionView.reloadData()
                    if owner.viewModel.searchResult[0].page == 1 {
                        owner.searchCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
                    }
                } else {
                    noResult.onNext(())
                }
            }
            .disposed(by: disposeBag)
        
        output.trending
            .drive(with: self) { owner, value in
                owner.searchCollectionView.reloadData()
                owner.searchCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
            }
            .disposed(by: disposeBag)
    }
    
}

//MARK: - CollectionViewDelegate, CollectionViewDataSource

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if viewModel.searchResult.count > 0 && viewModel.searchResult[0].searchResponse.count > 0 {
            return viewModel.searchResult[0].searchResponse.count
        } else if viewModel.trendingResult.count > 0 && viewModel.trendingResult[0].trendingResponse.count > 0 {
            return viewModel.trendingResult[0].trendingResponse.count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if viewModel.searchResult.count > 0 && viewModel.searchResult[0].searchResponse.count > 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCollectionViewCell.identifier, for: indexPath) as? PosterCollectionViewCell else {
                return PosterCollectionViewCell()
            }
            
            cell.updateContent(viewModel.searchResult[0].searchResponse[indexPath.row].posterPath)
            
            return cell
        } else if viewModel.trendingResult.count > 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieListCollectionViewCell.identifier, for: indexPath) as? MovieListCollectionViewCell else {
                return MovieListCollectionViewCell()
            }
            
            cell.setTrendingContent(viewModel.trendingResult[0].trendingResponse[indexPath.row])
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TitleCollectionViewHeader.identifier, for: indexPath) as? TitleCollectionViewHeader else {
            return TitleCollectionViewHeader()
        }
        if viewModel.searchResult.count > 0 && viewModel.searchResult[0].totalResults > 0 {
            header.updateContent(title: SearchCollectionViewSections.searchValue.title)
        } else {
            header.updateContent(title: SearchCollectionViewSections.trendValue.title)
        }
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigationController?.pushViewController(DetailViewController(), animated: true)
    }
    
}

//MARK: - UICollectionView DataSource Prefetching
extension SearchViewController: UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for item in indexPaths {
            if viewModel.searchResult.count > 0 {
                let search = viewModel.searchResult[0]
                if search.searchResponse.count > 0 && search.page < search.totalPages {
                    if item.row == search.searchResponse.count - 3 {
                        self.prefetchAction.onNext(())
                    }
                }
            }
        }
    }
    
}

//MARK: - Configuration
extension SearchViewController: BaseViewProtocol {
    
    func configureNavigationBar() {
        navigationItem.titleView = searchBar
    }
    
    func configureHierarchy() {
        view.addSubview(searchCollectionView)
    }
    
    func configureUI() {
        view.backgroundColor = .white
        configureSearchBar()
        configureCollectionView()
    }
    
    func configureLayout() {
        searchCollectionView.snp.makeConstraints { make in
            make.directionalEdges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func configureCollectionView() {
        searchCollectionView.delegate = self
        searchCollectionView.dataSource = self
        searchCollectionView.prefetchDataSource = self
        
        searchCollectionView.register(MovieListCollectionViewCell.self, forCellWithReuseIdentifier: MovieListCollectionViewCell.identifier)
        searchCollectionView.register(PosterCollectionViewCell.self, forCellWithReuseIdentifier: PosterCollectionViewCell.identifier)
        searchCollectionView.register(TitleCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TitleCollectionViewHeader.identifier)
    }
    
    private func configureSearchBar() {
        searchBar.placeholder = "영화, 시리즈를 검색하세요"
        searchBar.autocorrectionType = .no
        searchBar.spellCheckingType = .no
    }
    
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [weak self] (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            guard let self = self else { return nil }
            
            if viewModel.searchResult.count > 0 && viewModel.searchResult[0].totalResults > 0 {
                return SearchCollectionViewSections.searchValue.layoutSection
            } else {
                return SearchCollectionViewSections.trendValue.layoutSection
            }
        }
    }
    
}

//MARK: - SearchCollectionViewSections
enum SearchCollectionViewSections: Int, CaseIterable {
    
    case trendValue
    case searchValue
    
    var title: String {
        switch self {
        case .trendValue:
            "추천 시리즈 & 영화"
        case .searchValue:
            "영화 & 시리즈"
        }
    }
    
    var layoutSection: NSCollectionLayoutSection {
        switch self {
        case .trendValue:
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .absolute(108))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                           subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                    heightDimension: .absolute(44))
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            
            section.boundarySupplementaryItems = [header]
            
            return section
            
        case .searchValue:
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.33),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalWidth(0.42))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                           subitems: [item])
            group.interItemSpacing = .fixed(4)
            
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 4
            section.contentInsets = .init(top: 0,
                                          leading: 4,
                                          bottom: 16,
                                          trailing: 0)
            
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                    heightDimension: .absolute(44))
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            
            section.boundarySupplementaryItems = [header]
            
            return section
        }
    }
}
