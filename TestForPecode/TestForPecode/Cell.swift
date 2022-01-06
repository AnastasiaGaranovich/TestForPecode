import UIKit
import Kingfisher

final class Cell: UITableViewCell {
    @IBOutlet private weak var icon: UIImageView!
    @IBOutlet private weak var sourceLabel: UILabel!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionTextView: UITextView!
    @IBOutlet private weak var saveButton: UIButton!
    
    func setup(for article: Article) {
        self.icon.kf.setImage(with: article.urlToImage)
        sourceLabel.text = article.source.name
        authorLabel.text = article.author
        titleLabel.text = article.title
        descriptionTextView.text = article.description
    }
}
