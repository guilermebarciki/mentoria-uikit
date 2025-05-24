import UIKit

class PokemonListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var pokemons: [Pokemon] = []
    
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
        view = tableView
        
        fetchPokemonListt()
    }
    
    private func fetchPokemonList() {
            let urlString = "https://pokeapi.co/api/v2/pokemon?limit=151"
            guard let url = URL(string: urlString) else { return }

            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let self = self, let data = data, error == nil else { return }
                do {
                    let decoded = try JSONDecoder().decode(PokemonListResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.pokemons = decoded.results.map { $0.toDomainModel() }
                        self.tableView.reloadData()
                    }
                } catch {
                    print("Erro ao decodificar: \(error)")
                }
            }.resume()
        }

    private func fetchPokemonListt() {
        let urlString = "https://pokeapi.co/api/v2/pokemon?limit=1000"
       
        guard let url = URL(string: urlString) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data else { return }
            do {
                let decoded = try JSONDecoder().decode(PokemonListResponse.self, from: data)
                self?.pokemons = decoded.results.compactMap { $0.toDomainModel() }
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            } catch {
                print("error")
            }
        }.resume()
    }
    
    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as? PokemonTableViewCell else {
            return UITableViewCell()
        }
        
        let poke = pokemons[indexPath.row]
        cell.configure(with: poke)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let poke = pokemons[indexPath.row]
        let pokeUrl = poke.pokemonUrl
        navigationController?.pushViewController(PokemonDetailViewController(url: pokeUrl), animated: true)
    }
}




