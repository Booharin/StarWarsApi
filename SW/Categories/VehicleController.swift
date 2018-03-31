import UIKit
import CoreData

class VehicleController: UITableViewController, NSFetchedResultsControllerDelegate, UISearchBarDelegate {
 
    private lazy var resultsController: NSFetchedResultsController<Vehicle>? = {
        var resultController: NSFetchedResultsController<Vehicle>?
        
        CoreDataStack.shared.mainContext.performAndWait {
            let fetchRequest: NSFetchRequest<Vehicle> = Vehicle.fetchRequest()
            
            fetchRequest.sortDescriptors = [
                NSSortDescriptor(key: "name.firstLetter", ascending: true)
            ]
            
            let controller = NSFetchedResultsController(
                fetchRequest: fetchRequest,
                managedObjectContext: CoreDataStack.shared.mainContext,
                sectionNameKeyPath: "name.firstLetter",
                cacheName: nil
            )
            
            controller.delegate = self
            resultController = controller
        }
        
        return resultController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CoreDataStack.shared.mainContext.perform {
            try? self.resultsController?.performFetch()
            self.tableView.reloadData()
        }
        
        DataRepository.shared.fetchAll(for: .vehicles)
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return resultsController?.sections?.count ?? 0
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return resultsController?.sectionIndexTitles
    }
    
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return resultsController?.section(forSectionIndexTitle: title, at: index) ?? 0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return SectionView(name: resultsController?.sections?[section].name)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsController?.sections?[section].objects?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ObjectCell", for: indexPath)
        (cell as? ObjectCell)?.name = resultsController?.object(at: indexPath).name
        (cell as? ObjectCell)?.id = resultsController?.object(at: indexPath).id
        return cell
    }
    
    // MARK: - UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            resultsController?.fetchRequest.predicate = nil
        } else {
            resultsController?.fetchRequest.predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchText)
        }
        
        CoreDataStack.shared.mainContext.perform {
            try? self.resultsController?.performFetch()
            self.tableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let descriptionController = segue.destination as? VehicleDescriptionController {
            descriptionController.title = (sender as? ObjectCell)?.name
            guard let id = (sender as? ObjectCell)?.id else { return }
            descriptionController.setObjectId(id)
        }
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange sectionInfo: NSFetchedResultsSectionInfo,
        atSectionIndex sectionIndex: Int,
        for type: NSFetchedResultsChangeType
        ) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        case .move:
            break
        case .update:
            tableView.reloadSections(IndexSet(integer: sectionIndex), with: .fade)
        }
    }
    
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
        ) {
        
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .fade)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .fade)
        case .move:
            guard let indexPath = indexPath else { return }
            guard let newIndexPath = newIndexPath else { return }
            tableView.moveRow(at: indexPath, to: newIndexPath)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .fade)
        }
    }
    
}

