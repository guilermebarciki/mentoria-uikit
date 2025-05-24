import UIKit

class LobbyViewController: UIViewController {

    private lazy var cellButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Celula", for: .normal)
        button.addTarget(self, action: #selector(goToCellPreview), for: .touchUpInside)
        return button
    }()

    private lazy var listButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("List", for: .normal)
        button.addTarget(self, action: #selector(goToList), for: .touchUpInside)
        return button
    }()

    private lazy var detailButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Detalhe do pokemon", for: .normal)
        button.addTarget(self, action: #selector(goToPokemonDetail), for: .touchUpInside)
        return button
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [cellButton, listButton, detailButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    @objc func goToCellPreview() {
        navigationController?.pushViewController(CellViewController(), animated: true)
    }

    @objc func goToList() {
        navigationController?.pushViewController(PokemonListViewController(), animated: true)
    }

    @objc func goToPokemonDetail() {
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon/1/")
        navigationController?.pushViewController(PokemonDetailViewController(url: url), animated: true)
    }
}


