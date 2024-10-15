//
//  HomeViewController.swift
//  TongueLaw
//
//  Created by 최승범 on 10/10/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class HomeViewController: UIViewController {
    
    private lazy var homeCollectionView = UICollectionView(frame: .zero,
                                                           collectionViewLayout: createCollectionViewLayout())
    
    private let viewModel = HomeViewModel()
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        bind()
    }
    
    private func bind() {
        let load = BehaviorSubject<Void>(value: ())
        
        let input = HomeViewModel.Input(fetchData: load)
        let output = viewModel.transform(input)
        
        output.trendMovies
            .bind(with: self, onNext: { owner, value in
                owner.homeCollectionView.reloadData()
            })
            .disposed(by: disposeBag)
        
        output.trendSeries
            .bind(with: self, onNext: { owner, value in
                owner.homeCollectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
}

//MARK: - HomeViewController CollectionViewDelegate, DataSource
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        HomeCollectionViewSections.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch HomeCollectionViewSections(rawValue: section) {
        case .main:
            viewModel.randomMovie.count
        case .recommendMovie:
            viewModel.movies.count
        case .recommendSeries:
            viewModel.tvSeries.count
        default:
            0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch HomeCollectionViewSections(rawValue: indexPath.section) {
        case .main:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainRecommendCollectionViewCell.identifier, for: indexPath) as? MainRecommendCollectionViewCell else {
                return MainRecommendCollectionViewCell()
            }
            cell.addFavoriteListButtonTaped.bind(with: self, onNext: { owner, value in
                owner.viewModel.addFavoriteList(value)
            })
            .disposed(by: disposeBag)
            cell.updateContent(viewModel.randomMovie[indexPath.row])
          
            return cell
            
        case .recommendMovie:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCollectionViewCell.identifier, for: indexPath) as? PosterCollectionViewCell else {
                return PosterCollectionViewCell()
            }
            
            cell.updateContent(viewModel.movies[indexPath.row].posterPath)
            return cell
            
        case .recommendSeries:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCollectionViewCell.identifier, for: indexPath) as? PosterCollectionViewCell else {
                return PosterCollectionViewCell()
            }
            
            cell.updateContent(viewModel.tvSeries[indexPath.row].posterPath)
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TitleCollectionViewHeader.identifier, for: indexPath) as? TitleCollectionViewHeader else {
            return TitleCollectionViewHeader()
        }
        
        if let section = HomeCollectionViewSections(rawValue: indexPath.section),
           let title = section.title {
            header.updateContent(title: title)
        }
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigationController?.pushViewController(DetailViewController(), animated: true)
    }
    
}

//MARK: - HomeViewController Configuration
extension HomeViewController: BaseViewProtocol {
    
    func configureNavigationBar() {
        let searchButton = UIBarButtonItem(image: UIImage(systemName: DesignOfButton.search.imageName),
                                           style: .plain,
                                           target: self,
                                           action: nil)
        searchButton.tintColor = .black

        searchButton.rx.tap
            .subscribe(onNext: { [weak self] in
                if let tabBarController = self?.tabBarController {
                    tabBarController.selectedIndex = 1
                }
            })
            .disposed(by: disposeBag)
        
        navigationItem.rightBarButtonItem = searchButton
    }
    
    func configureHierarchy() {
        view.addSubview(homeCollectionView)
    }
    
    func configureUI() {
        view.backgroundColor = .white
        homeCollectionView.delegate = self
        homeCollectionView.dataSource = self
        homeCollectionView.showsVerticalScrollIndicator = false
        
        homeCollectionView.register(MainRecommendCollectionViewCell.self, forCellWithReuseIdentifier: MainRecommendCollectionViewCell.identifier)
        homeCollectionView.register(PosterCollectionViewCell.self, forCellWithReuseIdentifier: PosterCollectionViewCell.identifier)
        
        homeCollectionView.register(TitleCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TitleCollectionViewHeader.identifier)
    }
    
    func configureLayout() {
        homeCollectionView.snp.makeConstraints { make in
            make.directionalEdges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        let collectioViewCompositonalLayout = UICollectionViewCompositionalLayout {
            (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            return HomeCollectionViewSections(rawValue: sectionIndex)?.layoutSection
        }
        
        return collectioViewCompositonalLayout
    }
    
}

//MARK: - HomeCollectionViewSections
private enum HomeCollectionViewSections: Int, CaseIterable {
    
    case main
    case recommendMovie
    case recommendSeries
    
    var title: String? {
        switch self {
        case .recommendMovie:
            return "지금 뜨는 영화"
        case .recommendSeries:
            return "지금 뜨는 TV 시리즈"
        default:
            return nil
        }
    }
    
    var layoutSection: NSCollectionLayoutSection {
        switch self {
        case .main:
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalWidth(1.3))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                           subitems: [item])
    
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = .init(top: 16,
                                          leading: 16,
                                          bottom: 16,
                                          trailing: 16)
            
            return section
            
        case .recommendMovie, .recommendSeries:
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.24),
                                                   heightDimension: .fractionalWidth(0.32))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                           subitems: [item])
            
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 8
            section.orthogonalScrollingBehavior = .continuous
            section.contentInsets = .init(top: 0,
                                          leading: 16,
                                          bottom: 16,
                                          trailing: 16)
            
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

