//
//  DocumentTableViewController.swift
//  MyDocuments
//
//  Created by Filipe Augusto on 01/09/2018.
//  Copyright © 2018 Filipe Augusto. All rights reserved.
//


import UIKit

class DocumentTableViewController: UITableViewController {
    
    //MARK: Properties
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var searchActive : Bool = false
    var listFilterDocuments = [DocumentModel]()
    let documentConroller = DocumentController()
    var user:UserModel!
    let backgroundActivityIndicator = UIView()

    @IBOutlet weak var searchBarDocument: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundActivityIndicator.backgroundColor = UIColor(red: 16.0/255, green: 13/255.0, blue: 45.0/255, alpha: 0.5)
        backgroundActivityIndicator.frame = UIScreen.main.bounds
        self.view.addSubview(backgroundActivityIndicator)
        backgroundActivityIndicator.isHidden = true
        
        //searchBar
        searchBarDocument.delegate = self
        self.searchBarDocument.showsCancelButton = false
        self.searchBarDocument.delegate = self
        
        definesPresentationContext = true
        backgroundActivityIndicator.isHidden = false
        self.activeActivityIndicator()
    }
   
    override func viewWillAppear(_ animated: Bool) {
        loadDocuments()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listFilterDocuments.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentTableViewCell", for: indexPath) as! DocumentTableViewCell
        
        let row = indexPath.row
        cell.nameLabel.text = listFilterDocuments[row].nome
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.activeActivityIndicator()
            backgroundActivityIndicator.isHidden = false

            // Delete the row from the data source
            documentConroller.deleteDocument(i: indexPath.row) { (result) in
                self.activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
                self.backgroundActivityIndicator.isHidden = true
                if result as! Bool {
                    self.loadDocuments()
                    self.tableView.reloadData()
                } else {
                    let alert = UIAlertController(title: "Erro", message: "Erro na requisição", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
    //MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch(segue.identifier ?? "") {
            
        case "AddItem":
            if let documentVC = segue.destination as? DocumentViewController {
                documentVC.user = self.user
            }
            break
            
        case "ShowDetail":
            guard let DocumentDetailViewController = segue.destination as? DocumentViewController, let selectedDocumentCell = sender as? DocumentTableViewCell, let indexPath = tableView.indexPath(for: selectedDocumentCell) else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            let selectedDocument = listFilterDocuments[indexPath.row]
            DocumentDetailViewController.document = selectedDocument
            DocumentDetailViewController.user = self.user

            
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier ?? "")")
        }
    }
    
    //Activity Indicator
    func activeActivityIndicator() {
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    //loading Documents
    func loadDocuments() {
        documentConroller.loadDocuments(idUser: user.id!, callback: { result in
            if let result = result as? [DocumentModel] {
                self.listFilterDocuments = result
                self.activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
                self.backgroundActivityIndicator.isHidden = true
                self.tableView.reloadData()
            }  else {
                let alert = UIAlertController(title: "Erro", message: "Erro na requisição", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        })
    }
    
}

extension DocumentTableViewController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        listFilterDocuments = documentConroller.filterListDocuments(name: searchText, documents: self.listFilterDocuments)
        self.tableView.reloadData()
    }
    
}
