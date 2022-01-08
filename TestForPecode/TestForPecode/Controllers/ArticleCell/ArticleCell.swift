import UIKit
import Kingfisher

protocol CellDelegate: AnyObject {
    func cellDidPressSave(_ article: Article)
}

final class ArticleCell: UITableViewCell {
    // MARK: Properties
    
    weak var delegate: CellDelegate?
    private var article: Article!
    static let identifier = "ArticleCell"
    
    // MARK: Outlets
    
    @IBOutlet private weak var icon: UIImageView!
    @IBOutlet private weak var sourceLabel: UILabel!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    
    // MARK: Actions
    
    @IBAction func didPressSaveButton(_ sender: Any) {
        delegate?.cellDidPressSave(article)
        saveButton.alpha = article.isSaved ? 1 : 0.28
    }
}

// MARK: - Methods

extension ArticleCell {
    func setup(for article: Article) {
        self.article = article
        if let url = URL(string: article.urlToImage ?? "") {
            icon.kf.setImage(with: url)
        }
        sourceLabel.text = article.source?.name
        authorLabel.text = article.author
        titleLabel.text = article.title
        descriptionLabel.text = article.details
        
        saveButton.alpha = article.isSaved ? 1 : 0.28
    }
}
