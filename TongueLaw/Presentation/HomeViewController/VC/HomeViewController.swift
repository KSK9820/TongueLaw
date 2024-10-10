//
//  HomeViewController.swift
//  TongueLaw
//
//  Created by 최승범 on 10/10/24.
//

import UIKit
import SnapKit

final class HomeViewController: UIViewController {
    
    private lazy var homeCollectionView = UICollectionView(frame: .zero,
                                                           collectionViewLayout: createCollectionViewLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
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
            1
        case .recommendMovie:
            10
        case .recommendSeries:
            10
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
            
            return cell
            
        case .recommendMovie:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCollectionViewCell.identifier, for: indexPath) as? PosterCollectionViewCell else {
                return PosterCollectionViewCell()
            }
            
            return cell
            
        case .recommendSeries:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCollectionViewCell.identifier, for: indexPath) as? PosterCollectionViewCell else {
                return PosterCollectionViewCell()
            }
            
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TitleHeaderView.identifier, for: indexPath) as? TitleHeaderView else {
            return TitleHeaderView()
        }
        
        if let section = HomeCollectionViewSections(rawValue: indexPath.section),
           let title = section.title {
            header.updateContent(title: title)
        }
        
        return header
    }
    
}

//MARK: - HomeViewController Configuration
extension HomeViewController: BaseViewProtocol {
    
    func configureNavigationBar() {
        
    }
    
    func configureHierarchy() {
        view.addSubview(homeCollectionView)
    }
    
    func configureUI() {
        homeCollectionView.delegate = self
        homeCollectionView.dataSource = self
        homeCollectionView.showsVerticalScrollIndicator = false
        
        homeCollectionView.register(MainRecommendCollectionViewCell.self, forCellWithReuseIdentifier: MainRecommendCollectionViewCell.identifier)
        homeCollectionView.register(PosterCollectionViewCell.self, forCellWithReuseIdentifier: PosterCollectionViewCell.identifier)
        
        homeCollectionView.register(TitleHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TitleHeaderView.identifier)
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
            "지금 뜨는 영화"
        case .recommendSeries:
            "지금 뜨는 TV 시리즈"
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

