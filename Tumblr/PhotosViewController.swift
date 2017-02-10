//
//  PhotosViewController.swift
//  Tumblr
//
//  Created by Gokulsree Yenugadhati on 2/2/17.
//  Copyright © 2017 Gokul Yenugadhati. All rights reserved.
//

import UIKit
import AFNetworking
import SVPullToRefresh
class PhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var isMoreDataLoading = false
    var offset = 0
  var posts: [NSDictionary] = []
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
//        let url = URL(string:"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV")
//        let request = URLRequest(url: url!)
//        let session = URLSession(
//            configuration: URLSessionConfiguration.default,
//            delegate:nil,
//            delegateQueue:OperationQueue.main
//        )
//        
//        let task : URLSessionDataTask = session.dataTask(
//            with: request as URLRequest,
//            completionHandler: { (data, response, error) in
//                if let data = data {
//                    if let responseDictionary = try! JSONSerialization.jsonObject(
//                        with: data, options:[]) as? NSDictionary {
//                        print("responseDictionary: \(responseDictionary)")
//                        
//                        // Recall there are two fields in the response dictionary, 'meta' and 'response'.
//                        // This is how we get the 'response' field
//                        let responseFieldDictionary = responseDictionary["response"] as! NSDictionary
//                               self.posts = responseFieldDictionary["posts"] as! [NSDictionary]
//                        
//                        // This is where you will store the returned array of posts in your posts property
//                        // self.feeds = responseFieldDictionary["posts"] as! [NSDictionary]
//                        self.tableView.reloadData()
//                    }
//                    
//                }
//        });
//        task.resume()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:  #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        loadMoreData()
        
    
        
        
        
        // Do any additional setup after loading the view.
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return posts.count
        
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
       
    let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell") as! PhotoCell
        
        let post = posts[indexPath.row]
          
        if let photos = post.value(forKeyPath: "photos") as? [NSDictionary]{
            
            let imageUrlString = photos[0].value(forKeyPath: "original_size.url") as? String
            
            if let imageUrl = URL(string: imageUrlString!) {
                
                 cell.pictureView.setImageWith(imageUrl)
                // URL(string: imageUrlString!) is NOT nil, go ahead and unwrap it and assign it to imageUrl and run the code in the curly braces
            } else {
                // URL(string: imageUrlString!) is nil. Good thing we didn't try to unwrap it!
            }
           
            
        }
        else{
            
        }
       
        tableView.addInfiniteScrolling(){
            self.tableView.reloadData()
            //self.tableView.infiniteScrollingView?.stopAnimating()
            self.tableView.indexPath(for: cell)
        }
        
        tableView.rowHeight = 240
        
        
        
        
        return cell
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! PhotoCell
        var destinationViewController = segue.destination as! PhotoDetailsViewController
        
        destinationViewController.imageTouse = cell.pictureView.image
    
    }
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        //let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string:"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV")
        //let request = URLRequest(url: url!)
        // ... Create the URLRequest `myRequest` ...
        let request = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        
        
        // Configure session so that completion handler is executed on main UI thread
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            // ... Use the new data to update the data source ...
            
            // Reload the tableView now that there is new data
            self.tableView.reloadData()
            
            // Tell the refreshControl to stop spinning
            refreshControl.endRefreshing()
        }
        task.resume()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(!isMoreDataLoading){
            isMoreDataLoading = true
        }
        let scrollViewContentHeight = tableView.contentSize.height
        let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
        
        // When the user has scrolled past the threshold, start requesting
        if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
            isMoreDataLoading = true
            offset += 1
            loadMoreData()
            // ... Code to load more results ...
        }
        // Handle scroll behavior here
    }
    
    func loadMoreData(){
        let url = URL(string:"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV&offset=\(offset*self.posts.count)")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        let task : URLSessionDataTask = session.dataTask(
            with: request as URLRequest,
            completionHandler: { (data, response, error) in
                if let data = data {
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options:[]) as? NSDictionary {
                        print("responseDictionary: \(responseDictionary)")
                        
                        // Recall there are two fields in the response dictionary, 'meta' and 'response'.
                        // This is how we get the 'response' field
                        let responseFieldDictionary = responseDictionary["response"] as! NSDictionary
                        self.posts += responseFieldDictionary["posts"] as! [NSDictionary]
                        
                        // This is where you will store the returned array of posts in your posts property
                        // self.feeds = responseFieldDictionary["posts"] as! [NSDictionary]
                        self.tableView.reloadData()
                        
                    }
                    
                }
                self.isMoreDataLoading = false
        });
        task.resume()
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
