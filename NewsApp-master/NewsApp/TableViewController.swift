//
//  TableViewController.swift
//  NewsApp
//
//  Created by XP on 9/22/19.
//  Copyright © 2019 XP. All rights reserved.
//

import UIKit
import SafariServices

class TableViewController: UITableViewController {    
    
    // MARK: - Variables
    var url: URL?
    var articlesList = [NewsAPI]()
    lazy var searchResult = [NewsAPI]()
    lazy var filteredArticlesArray = [NewsAPI]()
    
    let refresh = UIRefreshControl()
    
    // For Pagination
    var currentPage = 1
    var pageSize = 6
    var isDataLoading = false

    // Search Bar
    @IBOutlet weak var searchBar: UISearchBar!
    var searchBarActive = false
    
    // MARK: - Life cycle View
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell for Table View
        let cell = UINib(nibName: "CustomTableViewCell", bundle: nil)
        self.tableView.register(cell, forCellReuseIdentifier: "myCell")
        
        // Refresh configuration
        self.refresh.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        self.refresh.tintColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        self.tableView.addSubview(refresh)
        
        // Start point of SearchBar
        self.tableView.setContentOffset(CGPoint.init(x: 0, y: self.searchBar.frame.height), animated: false)
        self.tableView.tableHeaderView = self.searchBar
        self.searchBar.delegate = self

        // Table View is not available while searching
        if searchBarActive {
            tableView.isUserInteractionEnabled = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.articlesList.removeAll()
        currentPage = 1

        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        getData()
    }
    
    // MARK: - Save data from API in our articleList
    func getData() {
        let category = UserDefaults.standard.object(forKey: "category") as? String ?? "general"
        let country = UserDefaults.standard.object(forKey: "country") as? String ?? "ua"
        
        url = URL(string: "https://newsapi.org/v2/top-headlines?country=\(country)&category=\(category)&pageSize=\(pageSize)&page=\(currentPage)&apiKey=bca9b711b1e445baa15da21825bc73e4")
        guard let url = url else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }

            do {
                let json = try JSONSerialization.jsonObject(with: data) as! [String:AnyObject]
                if let items = json["articles"] as? [[String : Any]] {
                    for item in items {
                        self.articlesList.append(NewsAPI(dictionary: item))
                    }
                        
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            } catch { print(error) }
        }.resume()
    }
    
    // MARK: - Show Safari with article
    func showSafari(articleURL: String, with: Int) {
        if let url = URL(string: articleURL) {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            
            let vc = SFSafariViewController(url: url, configuration: config)
            self.present(vc, animated: true)
        }
    }
    
    // MARK: - Pull-to-refresh
    @objc func handleRefresh() {
        articlesList.removeAll()
        currentPage += 1
        getData()
        refresh.endRefreshing()
    }
    
    // MARK: - Show alert with Sort
    @IBAction func sortBarButtonItem(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController()
        
        let category = UIAlertAction(title: "Sort by category", style: .default) { (action) in
            let sortVC = self.storyboard?.instantiateViewController(withIdentifier: "SortCategoryVC")
            self.navigationController?.pushViewController(sortVC!, animated: true)
        }
        alertController.addAction(category)
        
        let country = UIAlertAction(title: "Sort by country", style: .default) { (action) in
            let sortVC = self.storyboard?.instantiateViewController(withIdentifier: "SortCountryVC")
            self.navigationController?.pushViewController(sortVC!, animated: true)
        }
        alertController.addAction(country)
        
        self.present(alertController, animated: true)
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchBarActive {
            return searchResult.count
        } else {
            return articlesList.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! CustomTableViewCell
        
        filteredArticlesArray = searchBarActive ? searchResult.sorted(by: { $0.publishedAt > $1.publishedAt }) : articlesList.sorted(by: { $0.publishedAt > $1.publishedAt })

        let article = filteredArticlesArray[indexPath.row]
        cell.sourceLabel.text = article.source.name
        cell.titleLabel.text = article.title
        cell.authorLabel.text = article.author
        cell.descriptionTextView.text = article.description
        if let url = URL(string: article.urlToImage) {
            cell.myImageView.load(url: url)
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = filteredArticlesArray[indexPath.row]
        showSafari(articleURL: article.url, with: indexPath.row)
        self.searchBar.text = ""
    }
    
    // Pagination
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isDataLoading = false
        self.currentPage += 1
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if currentOffset > contentHeight - scrollView.frame.height {
            if !isDataLoading {
                isDataLoading = true
                getData()
            }
        }
    }
    
}

// MARK: - UISearchBarDelegate
extension TableViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBarActive = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBarActive = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBarActive = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBarActive = false
        searchBar.resignFirstResponder()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchResult = articlesList.filter({ (article: NewsAPI) -> Bool in
            return article.title.lowercased().contains(searchText.lowercased())
        })
        
        if searchResult.isEmpty {
            self.searchBarActive = false
        } else {
            self.searchBarActive = true
        }
        
        self.tableView.reloadData()
    }
    
    @IBAction func searchBarButtonItem(_ sender: UIBarButtonItem) {
        
        self.refresh.isUserInteractionEnabled = false

        UIView.animate(withDuration: 0.6) {
            if self.searchBar.isHidden == true {
                self.searchBar.becomeFirstResponder()
                self.searchBar.isHidden = false
                self.tableView.setContentOffset(CGPoint(x: 0, y: -self.searchBar.frame.height * 2), animated: false)
            } else {
                self.searchBar.resignFirstResponder()
                self.searchBar.isHidden = true
                self.searchBar.text = ""
                self.tableView.setContentOffset(CGPoint.init(x: 0, y: -self.searchBar.frame.height), animated: false)
            }
        }
    }
    
}
