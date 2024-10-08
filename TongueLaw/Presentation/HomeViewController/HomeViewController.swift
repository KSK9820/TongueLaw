//
//  HomeViewController.swift
//  TongueLaw
//
//  Created by 최승범 on 10/8/24.
//

import UIKit
import SnapKit

final class HomeViewController: UIViewController {
    
    private let playButton = UIButton()
    private let downloadButton = UIButton()
    private let savebutton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
}

extension HomeViewController: BaseViewProtocol {
    
    func configureHierarchy() {
        view.addSubview(playButton)
        view.addSubview(downloadButton)
        view.addSubview(savebutton)
    }
    
    func configureUI() {
        playButton.buttonStyle(type: .play)
        downloadButton.buttonStyle(type: .downloadList)
        savebutton.buttonStyle(type: .save)
    }
    
    func configureLayout() {
        playButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(100)
            make.width.equalTo(200)
        }
        
        downloadButton.snp.makeConstraints { make in
            make.top.equalTo(playButton.snp.bottom).offset(100)
            make.width.equalTo(200)
        }
        
        savebutton.snp.makeConstraints { make in
            make.top.equalTo(downloadButton.snp.bottom).offset(100)
            make.directionalHorizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
    }
    
}
