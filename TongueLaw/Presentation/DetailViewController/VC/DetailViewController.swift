//
//  DetailViewController.swift
//  TongueLaw
//
//  Created by 최승범 on 10/10/24.
//

import UIKit
import SnapKit
import Kingfisher
import Moya

final class DetailViewController: UIViewController {
    
    private let poster = UIImageView()
    private lazy var similarCollectionView = UICollectionView(frame: .zero,
                                                              collectionViewLayout: createCollectionViewLayout())
    var resultMovieData: TrendingMovieResponse?
    var resultTvData: TrendingTvResponse?
    
    private var castData: [Cast] = []
    private var similarMovies: [SimilarMovieResponse] = []
    private var similarTVShows: [SimilarTvResponse] = []
    private var genreList: [Int: String] = [:]
    private let provider = MoyaProvider<TMDBRouter>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        similarCollectionView.reloadData()
        fetchMovieCredits()
        fetchSimilarMovie()
        fetchSimilarTv()
        fetchGenres()
    }
    private func fetchMovieCredits() {
        guard let movieId = resultMovieData?.id else { return }

        provider.request(.creditsMovie(movieId: String(movieId))) { [weak self] result in
            switch result {
            case .success(let response):
                do {
                    let creditsResponse = try JSONDecoder().decode(CreditsDTO.self, from: response.data)
                    self?.castData = creditsResponse.cast
                    DispatchQueue.main.async {
                        guard let self = self else { return }
                        if !self.castData.isEmpty {
                            self.similarCollectionView.reloadData()
                        }
                    }
                } catch {
                    print("Failed to decode: \(error.localizedDescription)")
                }
            case .failure(let error):
                print("Network request failed: \(error.localizedDescription)")
            }
        }
    }
    
    private func fetchSimilarMovie() {
            if let movieId = resultMovieData?.id {
                provider.request(.similarMovie(movieId: String(movieId))) { [weak self] result in
                    switch result {
                    case .success(let response):
                        do {
                            let similarResponse = try JSONDecoder().decode(SimilarMovieDTO.self, from: response.data)
                            self?.similarMovies = similarResponse.similarMovieResponse
                            DispatchQueue.main.async {
                                self?.similarCollectionView.reloadData()
                            }
                        } catch {
                            print("Failed to decode: \(error.localizedDescription)")
                        }
                    case .failure(let error):
                        print("Network request failed: \(error.localizedDescription)")
                    }
                }
            }
    }
    
    private func fetchSimilarTv(){
        provider.request(.similarTV(seriesId: String("84773"))) { [weak self] result in
            switch result {
            case .success(let response):
                do {
                    let similarResponse = try JSONDecoder().decode(SimilarTvDTO.self, from: response.data)
                    self?.similarTVShows = similarResponse.similarTvResponse
                    DispatchQueue.main.async {
                        self?.similarCollectionView.reloadData()
                    }
                } catch {
                    print("Failed to decode: \(error.localizedDescription)")
                }
            case .failure(let error):
                print("Network request failed: \(error.localizedDescription)")
            }
        }
    }
    
    private func fetchGenres() {
            let group = DispatchGroup()

            group.enter()
            provider.request(.genreMovie) { [weak self] result in
                switch result {
                case .success(let response):
                    do {
                        let genreResponse = try JSONDecoder().decode(GenreDTO.self, from: response.data)
                        genreResponse.genres.forEach { self?.genreList[$0.id] = $0.name }
                    } catch {
                        print("Failed to decode movie genres: \(error.localizedDescription)")
                    }
                case .failure(let error):
                    print("Failed to fetch movie genres: \(error.localizedDescription)")
                }
                group.leave()
            }

            group.enter()
            provider.request(.genreTV) { [weak self] result in
                switch result {
                case .success(let response):
                    do {
                        let genreResponse = try JSONDecoder().decode(GenreDTO.self, from: response.data)
                        genreResponse.genres.forEach { self?.genreList[$0.id] = $0.name }
                    } catch {
                        print("Failed to decode TV genres: \(error.localizedDescription)")
                    }
                case .failure(let error):
                    print("Failed to fetch TV genres: \(error.localizedDescription)")
                }
                group.leave()
            }

            group.notify(queue: .main) {
                print("Genres fetched successfully")
                self.similarCollectionView.reloadData()
            }
        }
}

//MARK: - collectionView Delegate Datasource
extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let sectionsCount = DetailCollectionViewSections.allCases.count
        
        return sectionsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch DetailCollectionViewSections(rawValue: section) {
        case .collectioViewHeader:
            1
        case .overview:
            1
        case .cast:
            castData.count
        case .similarMovies:
            similarMovies.count
        case .similarTv:
            similarTVShows.count
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
            if let movie = resultMovieData {
                cell.updateContent(
                    title: movie.title,
                    date: movie.releaseDate,
                    genreIDs: movie.genreIDs,
                    voteAverage: movie.voteAverage,
                    genreList: genreList 
                )
            }
            return cell
            
        case .overview:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailOverviewCollectionViewCell.identifier,
                                                                for: indexPath) as? DetailOverviewCollectionViewCell else {
                return DetailOverviewCollectionViewCell()
            }
            if let movie = resultMovieData {
                cell.updateContent(data: movie.overview)
            }
            
            return cell
            
        case .cast:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailCastCollectionViewCell.identifier,
                                                                for: indexPath) as? DetailCastCollectionViewCell else {
                return DetailCastCollectionViewCell()
            }
            let cast = castData[indexPath.row]
            cell.updateContent(
                profileImage: cast.profilePath ?? "",
                name: cast.name,
                character: cast.character ?? ""
            )
            
            return cell
            
        case .similarMovies:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCollectionViewCell.identifier,
                                                                for: indexPath) as? PosterCollectionViewCell else {
                return PosterCollectionViewCell()
            }
            let movie = similarMovies[indexPath.row]
            cell.updateContent(movie.posterPath ?? "")
            
            return cell
            
        case .similarTv:
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCollectionViewCell.identifier,
                                                                for: indexPath) as? PosterCollectionViewCell else {
                return PosterCollectionViewCell()
            }
            let tvShow = similarTVShows[indexPath.row]
            cell.updateContent(tvShow.posterPath ?? "")
            
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
        view.backgroundColor = .white
        poster.contentMode = .scaleAspectFill
        if let movieData = resultMovieData {
            poster.kf.setImage(with: TMDBRouter.image(imagePath: movieData.backdropPath).baseURL)
        } else {
            poster.image = UIImage(systemName: "star")
        }
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
    case similarTv
    
    var sectionTitle: String {
        switch self {
        case .overview:
            return "줄거리"
        case .cast:
            return "출연진"
        case .similarMovies:
            return "비슷한 영화"
        case .similarTv:
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
                                                   heightDimension: .estimated(160))
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
                                                  heightDimension: .estimated(100))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .estimated(100))
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
            
        case .similarMovies, .similarTv:
            
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
