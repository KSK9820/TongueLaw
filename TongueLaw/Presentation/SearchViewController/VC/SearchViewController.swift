//
//  SearchViewController.swift
//  TongueLaw
//
//  Created by 최승범 on 10/10/24.
//

import UIKit
import SnapKit
import RxSwift

final class SearchViewController: UIViewController {
    
    private let viewModel = SearchViewModel()
    
    private var searchResult = [SearchResponse]()
    private var trendResult  = [TrendingMovieResponse]()
    private var searchTextKeyword = PublishSubject<String>()
    private var disposeBag = DisposeBag()
    
    private let searchBar = UISearchBar()
    private lazy var searchCollectionView = UICollectionView(frame: .zero,
                                                             collectionViewLayout: createCollectionViewLayout())
    
    var searchText: String = "" {
        didSet {
            searchCollectionView.reloadData()
        }
    }
    
    var collectionViewSection: SearchCollectionViewSections {
        searchText.isEmpty ? .emptyValue : .existValue
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        bind()
    }
    
    private func bind() {
        
        searchBar.rx.text
            .orEmpty
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] query in
                self?.searchTextKeyword.onNext(query)
            })
            .disposed(by: disposeBag)
            
        let noResult = PublishSubject<Void>()
            
        let input = SearchViewModel.Input(searchText: searchTextKeyword, emptySearchResult: noResult)
        let output = viewModel.transform(input)
        
        output.search
            .drive(with: self) { owner, value in
                if value.0.count > 0 {
                    if value.1 == true {
                        owner.searchResult = value.0
                        owner.searchCollectionView.reloadData()
                        owner.trendResult = []
                    } else {
                        owner.searchResult += value.0
                        owner.searchCollectionView.reloadData()
                        owner.trendResult = []
                    }
                } else {
                    noResult.onNext(())
                    owner.searchResult = []
                }
            }
            .disposed(by: disposeBag)
        
        output.trending
            .drive(with: self) { owner, value in
                if value.count > 0 {
                    owner.trendResult = value
                    owner.searchCollectionView.reloadData()
                }
            }
            .disposed(by: disposeBag)
    }
    
}

//MARK: - CollectionViewDelegate, CollectionViewDataSource

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searchResult.count > 0 {
            return searchResult.count
        } else if trendResult.count > 0 {
            return trendResult.count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieListCollectionViewCell.identifier, for: indexPath) as? MovieListCollectionViewCell else {
            return MovieListCollectionViewCell()
        }
        
        if searchResult.count > 0 {
            cell.setSearchContent(searchResult[indexPath.row])
        } else {
            cell.setTrendingContent(trendResult[indexPath.row])
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TitleCollectionViewHeader.identifier, for: indexPath) as? TitleCollectionViewHeader else {
            return TitleCollectionViewHeader()
        }
        
        header.updateContent(title: collectionViewSection.title)
        
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
            if searchResult.count > 0 {
                if item.row == searchResult.count - 10 {
                    searchBar.rx.text
                        .orEmpty
                        .debounce(.seconds(1), scheduler: MainScheduler.instance)
                        .distinctUntilChanged()
                        .subscribe(onNext: { [weak self] query in
                            self?.searchTextKeyword.onNext(query)
                        })
                        .disposed(by: disposeBag)
                }
            }
        }
    }
    
}

//MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        
        searchText = text
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
        searchCollectionView.register(TitleCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TitleCollectionViewHeader.identifier)
    }
    
    private func configureSearchBar() {
        searchBar.placeholder = "영화, 시리즈를 검색하세요"
        searchBar.delegate = self
        searchBar.autocorrectionType = .no
        searchBar.spellCheckingType = .no
    }
    
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [weak self] (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            guard let self = self else { return nil }
            
            if self.searchText.isEmpty {
                return SearchCollectionViewSections.emptyValue.layoutSection
            } else {
                return SearchCollectionViewSections.existValue.layoutSection
            }
        }
    }
    
}

//MARK: - SearchCollectionViewSections
enum SearchCollectionViewSections: Int, CaseIterable {
    
    case emptyValue
    case existValue
    
    var title: String {
        switch self {
        case .emptyValue:
            "추천 시리즈 & 영화"
        case .existValue:
            "영화 & 시리즈"
        }
    }
    
    var layoutSection: NSCollectionLayoutSection {
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
    }
    
}
