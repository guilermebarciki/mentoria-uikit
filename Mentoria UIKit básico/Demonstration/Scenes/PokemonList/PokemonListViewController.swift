import UIKit

class PokemonListViewController: UIViewController {

    private lazy var viewModel = PokemonListViewModel()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.register(PokemonTableViewCell.self, forCellReuseIdentifier: "CustomCell")
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        view = tableView
        
        viewModel.fetchPokemons()
    }
}

// MARK: - ViewModel Delegate

extension PokemonListViewController: PokemonListViewModelDelegate {
    func didUpdatePokemonList() {
           DispatchQueue.main.async {
               self.tableView.reloadData()
           }
       }

       func didFailWithError(_ message: String) {
           DispatchQueue.main.async {
               self.showAlert(message: "Erro ao carregar lista \(message)")
           }
       }
}

// MARK: - UITableViewDataSource

extension PokemonListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfPokemons
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as? PokemonTableViewCell else {
            return UITableViewCell()
        }
        let pokemon = viewModel.getPokemon(at: indexPath.row)
        cell.configure(with: pokemon)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension PokemonListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pokemon = viewModel.getPokemon(at: indexPath.row)
        let detailVC = PokemonDetailViewController(url: pokemon.pokemonUrl)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
