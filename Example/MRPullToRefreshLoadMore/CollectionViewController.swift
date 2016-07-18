import UIKit
import Foundation
import MRPullToRefreshLoadMore

class CollectionViewController:UIViewController, MRPullToRefreshLoadMoreDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: MRCollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.pullToRefresh.pullToRefreshLoadMoreDelegate = self
    }
    
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("SampleCell", forIndexPath: indexPath)
        return cell
    }
        
    func viewShouldRefresh() {
        print("view should refresh")
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(2 * NSEC_PER_SEC)), dispatch_get_main_queue()) { () -> Void in
            self.collectionView.pullToRefresh.setState(MRPullToRefreshLoadMore.ViewState.Normal)
        }
    }
    
    func viewShouldLoadMore() {}
}
