//
//  BookTableViewCell.swift
//  ReadBook
//
//  Created by Кристина Олейник on 23.08.2025.
//

import UIKit
import SnapKit

final class BookTableViewCell: UITableViewCell {
    
    //MARK: - GUI Variables
    
    private let containerView: UIView = {
        let view = UIView()
        
        view.layer.cornerRadius = 10
        
        return view
    }()
    
    private let coverView: UIImageView = {
        let view = UIImageView()
        
        view.layer.cornerRadius = 10
        view.image = UIImage(named: "mock")
        view.layer.masksToBounds = true
        view.contentMode = .scaleAspectFill
        
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Title"
        label.font = .boldSystemFont(ofSize: 18)
        
        return label
    }()
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Author"
        label.font = .boldSystemFont(ofSize: 18)
        
        return label
    }()
    
    private let starLabel: UILabel = {
        let label = UILabel()
        
        label.text = "★"
        label.textColor = .darkBord
        label.font = .boldSystemFont(ofSize: 18)
        
        return label
    }()
    
    //MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    func set(book: Book) {
        titleLabel.text = "«\(book.title)»"
        titleLabel.textColor = .textColor
        titleLabel.font = .systemFont(ofSize: 18, weight: .medium)
        
        authorLabel.text = book.author
        authorLabel.textColor = .textColor
        authorLabel.font = .systemFont(ofSize: 18, weight: .medium)
        
        if let url = book.imageURL,
           let image = FileManagerPersistent.read(from: url) {
            coverView.image = image
        } else {
            coverView.image = UIImage(named: "mock")
        }
        
        if book.rating == 0 {
            starLabel.isHidden = true
        } else {
            starLabel.isHidden = false
            switch book.rating {
            case 1:
                starLabel.text = "★"
            case 2:
                starLabel.text = "★ ★"
            case 3:
                starLabel.text = "★ ★ ★"
            case 4:
                starLabel.text = "★ ★ ★ ★"
            case 5:
                starLabel.text = "★ ★ ★ ★ ★"
            default:
                starLabel.isHidden = true
            }
        }
    }
    //MARK: - Private Methods
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        addSubview(containerView)
        containerView.addSubviews([coverView,
                                   titleLabel,
                                   authorLabel,
                                   starLabel])
        containerView.backgroundColor = .secondBG
        containerView.layer.cornerRadius = 20
        setupConstraints()
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(5)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        
        coverView.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview().inset(10)
            make.height.equalTo(100)
            make.width.equalTo(70)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.leading.equalTo(coverView.snp.trailing).offset(15)
        }
        
        authorLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.leading.equalTo(coverView.snp.trailing).offset(15)
        }
        
        starLabel.snp.makeConstraints { make in
            make.top.equalTo(authorLabel.snp.bottom).offset(10)
            make.leading.equalTo(coverView.snp.trailing).offset(15)
        }
    }
}
