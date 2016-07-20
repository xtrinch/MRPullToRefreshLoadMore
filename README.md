# MRPullToRefreshLoadMore

[![CI Status](http://img.shields.io/travis/xtrinch/MRPullToRefreshLoadMore.svg?style=flat)](https://travis-ci.org/xtrinch/MRPullToRefreshLoadMore)
[![Version](https://img.shields.io/cocoapods/v/MRPullToRefreshLoadMore.svg?style=flat)](http://cocoapods.org/pods/MRPullToRefreshLoadMore)
[![License](https://img.shields.io/cocoapods/l/MRPullToRefreshLoadMore.svg?style=flat)](http://cocoapods.org/pods/MRPullToRefreshLoadMore)
[![Platform](https://img.shields.io/cocoapods/p/MRPullToRefreshLoadMore.svg?style=flat)](http://cocoapods.org/pods/MRPullToRefreshLoadMore)

Pull to refresh and load more loader with delegate methods for UITableViews, UICollectionViews (and planned: UIScrollviews). Its usage is extremely simple as it onnly requires setting a class on your uiview. Example project contains tableview and horizontally scrolling collectionview. 

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

Pull to refresh a table view:

<img src='https://raw.githubusercontent.com/xTrinch/MRPullToRefreshLoadMore/master/Graphics/tableViewPullToRefresh.gif' width=200>

Load more in a table view:

<img src='https://raw.githubusercontent.com/xTrinch/MRPullToRefreshLoadMore/master/Graphics/tableViewLoadMore.gif' width=200>

Pull to refresh in horizontally scrolling collection view:

<img src='https://raw.githubusercontent.com/xTrinch/MRPullToRefreshLoadMore/master/Graphics/collectionViewPullToRefresh.gif' width=200>

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

## Issues && Todo

- Need to disable refresh / load more if either of them is already under way
- Add scrollview support

## Author

xTrinch, mojca.rojko@gmail.com

## License

MRPullToRefreshLoadMore is available under the MIT license. See the LICENSE file for more info.
