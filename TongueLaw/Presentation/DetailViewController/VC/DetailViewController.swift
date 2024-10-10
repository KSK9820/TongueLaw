//
//  DetailViewController.swift
//  TongueLaw
//
//  Created by 최승범 on 10/10/24.
//

import UIKit
import SnapKit

final class DetailViewController: UIViewController {
    
    private let poster = UIImageView()
    private lazy var similarCollectionView = UICollectionView(frame: .zero,
                                                              collectionViewLayout: createCollectionViewLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
}

//MARK: - collectionView Delegate Datasource
extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        var sectionsCount = DetailCollectionViewSections.allCases.count
        
        return sectionsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch DetailCollectionViewSections(rawValue: section) {
        case .collectioViewHeader:
            1
        case .overview:
            1
        case .cast:
            3
        case .similarMovies:
            10
        case .recommendedMovies:
            10
        default:
            0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch DetailCollectionViewSections(rawValue: indexPath.section) {
        case .collectioViewHeader:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailInformationCollectionViewCell.identifier,
                                                                for: indexPath) as? DetailInformationCollectionViewCell else {
                return DetailInformationCollectionViewCell()
            }
            
            return cell
            
        case .overview:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailOverviewCollectionViewCell.identifier,
                                                                for: indexPath) as? DetailOverviewCollectionViewCell else {
                return DetailOverviewCollectionViewCell()
            }
            
            return cell
            
        case .cast:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailCastCollectionViewCell.identifier,
                                                                for: indexPath) as? DetailCastCollectionViewCell else {
                return DetailCastCollectionViewCell()
            }
            
            return cell
            
        case .similarMovies:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCollectionViewCell.identifier,
                                                                for: indexPath) as? PosterCollectionViewCell else {
                return PosterCollectionViewCell()
            }
            
            return cell
            
        case .recommendedMovies:
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCollectionViewCell.identifier,
                                                                for: indexPath) as? PosterCollectionViewCell else {
                return PosterCollectionViewCell()
            }
            
            return cell
            
        default:
            return UICollectionViewCell()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                           withReuseIdentifier: TitleCollectionViewHeader.identifier,
                                                                           for: indexPath) as? TitleCollectionViewHeader else {
            return TitleCollectionViewHeader()
        }
        if let section = DetailCollectionViewSections(rawValue: indexPath.section) {
            header.updateContent(title: section.sectionTitle)
        }
        
        return header
    }
    
}

//MARK: - Configuration
extension DetailViewController: BaseViewProtocol {
    
    func configureHierarchy() {
        view.addSubview(poster)
        view.addSubview(similarCollectionView)
    }
    
    func configureLayout() {
        poster.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.directionalHorizontalEdges.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.25)
        }
        
        similarCollectionView.snp.makeConstraints { make in
            make.top.equalTo(poster.snp.bottom)
            make.bottom.directionalHorizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureUI() {
        poster.backgroundColor = .gray
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        similarCollectionView.delegate = self
        similarCollectionView.dataSource = self
        similarCollectionView.showsVerticalScrollIndicator = false
        
        similarCollectionView.register(DetailInformationCollectionViewCell.self,
                                       forCellWithReuseIdentifier: DetailInformationCollectionViewCell.identifier)
        similarCollectionView.register(DetailOverviewCollectionViewCell.self,
                                       forCellWithReuseIdentifier: DetailOverviewCollectionViewCell.identifier)
        similarCollectionView.register(DetailCastCollectionViewCell.self,
                                       forCellWithReuseIdentifier: DetailCastCollectionViewCell.identifier)
        similarCollectionView.register(PosterCollectionViewCell.self,
                                       forCellWithReuseIdentifier: PosterCollectionViewCell.identifier)
        similarCollectionView.register(TitleCollectionViewHeader.self,
                                       forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                       withReuseIdentifier: TitleCollectionViewHeader.identifier)
    }
    
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        let collectioViewCompositonalLayout = UICollectionViewCompositionalLayout {
            (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            return DetailCollectionViewSections(rawValue: sectionIndex)?.layoutSection
        }
        
        return collectioViewCompositonalLayout
    }
    
}

//MARK: - DetailCollectionViewSections
fileprivate enum DetailCollectionViewSections: Int, CaseIterable {
    
    case collectioViewHeader
    case overview
    case cast
    case similarMovies
    case recommendedMovies
    
    var sectionTitle: String {
        switch self {
        case .overview:
            return "줄거리"
        case .cast:
            return "출연진"
        case .similarMovies:
            return "비슷한 영화"
        case .recommendedMovies:
            return "추천 영화"
        default:
            return ""
        }
    }
    
    var layoutSection: NSCollectionLayoutSection? {
        switch self {
        case .collectioViewHeader:
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .estimated(152))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                           subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            
            section.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                            leading: 16,
                                                            bottom: 16,
                                                            trailing: 16)
            
            return section
            
        case .overview:
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .estimated(200))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .estimated(200))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                           subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            
            section.contentInsets = NSDirectionalEdgeInsets(top: 0,
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
            
        case .cast:
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.2),
                                                   heightDimension: .fractionalWidth(0.35))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                           subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            section.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                            leading: 16,
                                                            bottom: 44,
                                                            trailing: 16)
            section.interGroupSpacing = 4
            
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                    heightDimension: .absolute(44))
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            section.boundarySupplementaryItems = [header]
            
            return section
            
        case .similarMovies, .recommendedMovies:
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.25),
                                                   heightDimension: .fractionalWidth(0.325))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                           subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            section.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                            leading: 16,
                                                            bottom: 0,
                                                            trailing: 0)
            section.interGroupSpacing = 4
            
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
