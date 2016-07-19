# MRPullToRefreshLoadMore

[![CI Status](http://img.shields.io/travis/xtrinch/MRPullToRefreshLoadMore.svg?style=flat)](https://travis-ci.org/xtrinch/MRPullToRefreshLoadMore)
[![Version](https://img.shields.io/cocoapods/v/MRPullToRefreshLoadMore.svg?style=flat)](http://cocoapods.org/pods/MRPullToRefreshLoadMore)
[![License](https://img.shields.io/cocoapods/l/MRPullToRefreshLoadMore.svg?style=flat)](http://cocoapods.org/pods/MRPullToRefreshLoadMore)
[![Platform](https://img.shields.io/cocoapods/p/MRPullToRefreshLoadMore.svg?style=flat)](http://cocoapods.org/pods/MRPullToRefreshLoadMore)

Pull to refresh and load more loader with delegate methods for UITableViews, UICollectionViews (and planned: UIScrollviews). Its usage is extremely simple as it onnly requires setting a class on your uiview. Example project contains tableview and horizontally scrolling collectionview. 

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Usage

    import MRPullToRefreshLoadMore
    
    class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MRPullToRefreshLoadMoreDelegate {
    
        @IBOutlet weak var tableView: MRTableView!
      
        override func viewDidLoad() {
            super.viewDidLoad()
            tableView.delegate = self
            tableView.dataSource = self
            tableView.pullToRefresh.pullToRefreshLoadMoreDelegate = self
        }
        
        func viewShouldRefresh() {
          // refresh tableview
        }
        
        func viewShouldLoadMore() {
          // load more in tableview
        }
    }

Available classes: MRTableView, MRCollectionView

## Installation

MRPullToRefreshLoadMore is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "MRPullToRefreshLoadMore"
```

## Author

xTrinch, mojca.rojko@gmail.com

## License

MRPullToRefreshLoadMore is available under the MIT license. See the LICENSE file for more info.
