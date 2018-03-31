import UIKit

class StarshipDescriptionController: UITableViewController {
    
    private var elements = [DescriptionElement]()
    
    func setObjectId(_ id: Int16) {
        DataRepository.shared.fetchStarship(with: id) { [weak self] starship in
            self?.elements = DescriptionBuilder().build(from: starship)
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elements.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let element = elements[indexPath.row]
        var cell: UITableViewCell
        
        switch element {
        case let .group(name):
            cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath)
            (cell as? GroupCell)?.name = name
        case let .keyValue(name, value):
            cell = tableView.dequeueReusableCell(withIdentifier: "KeyValueCell", for: indexPath)
            (cell as? KeyValueCell)?.setData(key: name, value: value)
        case let .singleValue(value):
            cell = tableView.dequeueReusableCell(withIdentifier: "SingleValueCell", for: indexPath)
            (cell as? SingleValueCell)?.value = value
        }
        
        return cell
    }
}



