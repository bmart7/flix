//
//  MoviesViewController.swift
//  flix
//
//  Created by Brian Martin on 9/26/20.
//

import UIKit
import AlamofireImage

class MoviesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var movies = [[String:Any]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self

        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
           // This will run when the network request returns
           if let error = error {
              print(error.localizedDescription)
           } else if let data = data {
              let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]

              // Get the array of movies
              // Store the movies in a property to use elsewhere
            self.movies = dataDictionary["results"] as! [[String:Any]]
              // Reload your table view data
            self.tableView.reloadData()
            print(self.movies)
           }
        }
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movie = movies[indexPath.row]
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
        cell.titleLabel.text = (movie["title"] as! String)
        cell.descriptionLabel.text = (movie["overview"] as! String)
        
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterUrl = URL(string:baseUrl + (movie["poster_path"] as! String))!
        
        cell.posterView.af_setImage(withURL: posterUrl)
        
        return cell
    }

}
