import UIKit

class PokemonTableViewCell: UITableViewCell {

    private let customView: PokemonCellView = {
        let view = PokemonCellView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCustomView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        customView.prepareForReuse()
    }
    
    private func setupCustomView() {
        contentView.addSubview(customView)
        NSLayoutConstraint.activate([
            customView.topAnchor.constraint(equalTo: contentView.topAnchor),
            customView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            customView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            customView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    public func configure(with pokemon: Pokemon) {
        customView.configure(with: pokemon)
    }
}
