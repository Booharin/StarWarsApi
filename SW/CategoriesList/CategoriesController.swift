import UIKit

class CategoriesController: UITableViewController {
    
    private let data = [
        CategoryData(title: "Peoples", icon: #imageLiteral(resourceName: "icon_people"), category: .people),
        CategoryData(title: "Species", icon: #imageLiteral(resourceName: "icon_film"), category: .species),
        CategoryData(title: "Planets", icon: #imageLiteral(resourceName: "icon-planet"), category: .planets),
        CategoryData(title: "Starships", icon: #imageLiteral(resourceName: "icon-starship"), category: .starships),
        CategoryData(title: "Vehicles", icon: #imageLiteral(resourceName: "icon-vehicle"), category: .vehicles)
    ]
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        (cell as? CategoryCell)?.data = data[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch data[indexPath.row].category {
        case .people:
            performSegue(withIdentifier: "showPeoples", sender: nil)
        case .films:
            break
        case .planets:
            performSegue(withIdentifier: "showPlanets", sender: nil)
        case .species:
            performSegue(withIdentifier: "showSpecies", sender: nil)
        case .starships:
            performSegue(withIdentifier: "showStarships", sender: nil)
        case .vehicles:
            performSegue(withIdentifier: "showVehicles", sender: nil)
        }
    }
}

struct CategoryData {
    let title: String
    let icon: UIImage
    let category: ModelType
}
