//
//  MainRecommendCollectionViewCell.swift
//  TongueLaw
//
//  Created by 최승범 on 10/9/24.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

final class MainRecommendCollectionViewCell: UICollectionViewCell {
    
    var playButtonTaped = PublishRelay<Void>()
    var addFavoriteListButtonTaped = PublishRelay<FavoriteContent>()
    
    private var movie: TrendingMovieResponse?
    private let poster = UIImageView()
    private let genreLabel = UILabel()
    private let buttonStackView = UIStackView()
    private let playButton = UIButton()
    private let addFavoriteListButton = UIButton()
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - MainRecommendCollectionViewCell Method
extension MainRecommendCollectionViewCell {
    
    func updateContent(_ movie: TrendingMovieResponse) {
        self.movie = movie
        poster.kf.setImage(with: TMDBRouter.image(imagePath: movie.posterPath).baseURL)
    }
    
}

//MARK: - MovieListCollectionViewCell Configuration
extension MainRecommendCollectionViewCell: BaseViewProtocol {
    
    func configureHierarchy() {
        contentView.addSubview(poster)
        contentView.addSubview(genreLabel)
        contentView.addSubview(buttonStackView)
        buttonStackView.addArrangedSubview(playButton)
        buttonStackView.addArrangedSubview(addFavoriteListButton)
    }
    
    func configureUI() {
        poster.backgroundColor = .gray
        poster.layer.cornerRadius = 12
        
        playButton.buttonStyle(type: .play)
        addFavoriteListButton.buttonStyle(type: .favorite)
        
        genreLabel.text = "애니메이션 가족 코미디 드라마"
        genreLabel.textAlignment = .center
        
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 8
    }
    
    func configureLayout() {
        poster.snp.makeConstraints { make in
            make.directionalEdges.equalToSuperview()
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.bottom.equalTo(poster.snp.bottom).inset(12)
            make.centerX.equalTo(contentView.snp.centerX)
            make.width.equalTo(contentView.snp.width).inset(8)
            make.height.equalTo(36)
        }
        
        genreLabel.snp.makeConstraints { make in
            make.bottom.equalTo(buttonStackView.snp.top)
            make.directionalHorizontalEdges.equalToSuperview().inset(20)
        }
    }
    
    func configureGestureAndButtonActions() {
        addFavoriteListButton.rx.tap.bind(with: self) { owner, _ in
            guard let movie = owner.movie else { return }
            if let imageData = owner.poster.image?.pngData() {
                let favoriteContent = FavoriteContent(id: "\(movie.id)", title: movie.title, image: imageData)
                owner.addFavoriteListButtonTaped.accept(favoriteContent)
            }
        }.disposed(by: disposeBag)
    }
    
}

