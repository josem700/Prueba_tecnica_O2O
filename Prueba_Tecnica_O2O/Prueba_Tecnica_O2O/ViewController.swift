//
//  ViewController.swift
//  Prueba_Tecnica_O2O
//
//  Created by Jose M on 21/9/22.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    //Diccionario con todas las cervezas
    var Beers:[[String:Any]] = [[:]]
    
    //Diccionario usado para filtrar los datos
    var filteredData:[[String:Any]] = [[:]]
    
    @IBOutlet weak var SearchBar: UISearchBar!
    @IBOutlet weak var BeersTableView: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        BeersTableView.delegate = self
        BeersTableView.dataSource = self
        SearchBar.delegate = self
        
        self.getBeers()
        
        if filteredData[0].isEmpty{
            filteredData.remove(at: 0)
        }
        
        if Beers[0].isEmpty{
            Beers.remove(at: 0)
        }
     
    }
    
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Aqui uso filteredData para contar las filas ya que este varia cuando estemos buscando
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "beercell", for: indexPath) as! BeerCell
        
        guard let urlImage = URL(string: filteredData[indexPath.row]["image_url"] as! String) else {return cell}
        
            cell.BeerImage.load(url: urlImage)
            cell.BeerName.text = filteredData[indexPath.row]["name"] as! String
            cell.BeerPrice.text = "First Brewed: \(filteredData[indexPath.row]["first_brewed"] as! String)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "detalle") as! DetailViewController
        
      
                vc.image_url = filteredData[indexPath.row]["image_url"] as! String
                vc.titleBeer = filteredData[indexPath.row]["name"] as! String
                vc.desc = filteredData[indexPath.row]["description"] as! String
       
        self.present(vc, animated: true)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredData = []
        
        guard let searchText = searchBar.text else {return}
        
        //Si el texto de busqueda esta vacio, muestra todas las cervezas, si contiene algo, filtra el Array
        if searchText == "" {
            filteredData = Beers
        }
        else{
            filteredData = Beers.filter { (object) -> Bool in
            
                guard let beername = object["name"] as? String else {return false}
                
                return beername.contains(searchText)
            
            }
        }

        BeersTableView.reloadData()

    }
    
    
    
    func getBeers(){
        
        //Esta funcion usa Alamofire para hacer la peticion al servidor y Aplicar los datos
        let urlString = "https://api.punkapi.com/v2/beers"
        guard let url = URL(string: urlString) else {return}
        
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
       
        let alamoRequest = AF.request(request as URLRequestConvertible)
        alamoRequest.validate(statusCode: 200..<300)
        alamoRequest.responseString { response in
            
            guard let datos = response.data else {return}
            
            do{
                
                let responseData = try JSONSerialization.jsonObject(with: datos, options: .fragmentsAllowed) as! [[String:Any]]
                self.Beers = responseData
                self.filteredData=self.Beers
                print (self.Beers)
                
                
                DispatchQueue.main.async {
                    self.BeersTableView.reloadData()
                }
                
            }
            catch{
                print("Error: \(error)")
            }
        }
    }
}

extension UIImageView {
     
    //Esta funcion carga una foto a partir de una url dada
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }

}


