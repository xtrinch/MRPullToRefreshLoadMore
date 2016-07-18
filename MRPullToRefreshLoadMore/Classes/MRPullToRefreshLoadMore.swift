import UIKit

@objc public protocol MRPullToRefreshLoadMoreDelegate {
    func viewShouldRefresh()
    func viewShouldLoadMore()
}

public class MRPullToRefreshLoadMore:NSObject {

    public var scrollView:UIScrollView?
    public var pullToRefreshLoadMoreDelegate:MRPullToRefreshLoadMoreDelegate?
    public var enabled:Bool = true
    public var startingContentInset:UIEdgeInsets?
    public var pullToRefreshViewState:ViewState = ViewState.Normal
    public var loadMoreViewState:ViewState = ViewState.Normal
    
    public var arrowImage: CALayer?
    public var activityView: UIActivityIndicatorView?
    public var indicatorPullToRefresh = IndicatorView()
    public var indicatorLoadMore = IndicatorView()

    var indicatorSize: CGSize = CGSizeMake(30.0, 30.0)
    public var textColor:UIColor = UIColor.whiteColor()
    
    public enum ViewState {
        case Normal
        case Loading
        case Ready
    }
    
    public func initWithScrollView(scrollView:UIScrollView) {
        scrollView.addSubview(indicatorPullToRefresh)
        scrollView.addSubview(indicatorLoadMore)
        
        //indicatorLoadMore.setAnimating(true)
        
        self.scrollView = scrollView
        scrollView.addObserver(self, forKeyPath: "contentOffset", options: NSKeyValueObservingOptions.New, context: nil)
        startingContentInset = scrollView.contentInset
        print(startingContentInset)
        self.enabled = true
        setState(ViewState.Normal)
        setLoadMoreState(ViewState.Normal)
    }
    
    public func setLoadMoreState(state:ViewState) {
        loadMoreViewState = state
        
        switch (state) {
            case ViewState.Ready:
                scrollView!.contentInset = self.startingContentInset!
                indicatorLoadMore.setAnimating(false)
                
            case ViewState.Normal:
                indicatorLoadMore.setAnimating(false)
                UIView.animateWithDuration(0.2, animations: {
                    self.scrollView!.contentInset = self.startingContentInset!
                })
                
            case ViewState.Loading:
                indicatorLoadMore.setAnimating(true)
                scrollView!.contentInset = UIEdgeInsetsMake(0.0, 0.0, 60.0, 0.0)
                
            default:
                break;
        }
    }
    
    
    public func setState(state:ViewState) {
        pullToRefreshViewState = state
        
        switch (state) {
            case ViewState.Ready:
                scrollView!.contentInset = self.startingContentInset!
                indicatorPullToRefresh.setAnimating(false)
            
            case ViewState.Normal:
                indicatorPullToRefresh.setAnimating(false)
                UIView.animateWithDuration(0.2, animations: {
                    self.scrollView!.contentInset = self.startingContentInset!
                })
            
            case ViewState.Loading:
                indicatorPullToRefresh.setAnimating(true)
                scrollView!.contentInset = UIEdgeInsetsMake(60.0, 0.0, 0.0, 0.0)
            
            default:
            break;
        }
    }
    
    override public func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        switch (keyPath) {
        case .Some("contentOffset"):
            indicatorPullToRefresh.frame = CGRectMake(scrollView!.bounds.width/2 - indicatorSize.width/2, -scrollView!.bounds.origin.y - 45 + scrollView!.contentOffset.y, indicatorSize.width, indicatorSize.height)
            indicatorLoadMore.frame = CGRectMake(scrollView!.bounds.width/2 - indicatorSize.width/2, 15 + scrollView!.contentSize.height, indicatorSize.width, indicatorSize.height)
            
            if (enabled) {
                if (scrollView!.dragging) {
                    
                    // HORIZONTAL SCROLL
                    let diff_x_end = scrollView!.contentOffset.x + scrollView!.bounds.width - scrollView!.contentSize.width
                    let diff_x_start = 0 - scrollView!.contentOffset.x
                    
                    let diff_y_end = scrollView!.contentOffset.y + scrollView!.bounds.height - scrollView!.contentSize.height
                    let diff_y_start = 0 - scrollView!.contentOffset.y

                    print("diffs")
                    print(diff_x_start)
                    print(diff_x_end)
                    print(diff_y_start)
                    print(diff_y_end)
                    
                    
                    // VERTICAL SCROLL
                    
                    // pull to refresh
                    if (pullToRefreshViewState == ViewState.Ready) {
                        indicatorPullToRefresh.interactiveProgress = scrollView!.contentOffset.y / -130.0
                        
                        if (scrollView!.contentOffset.y > -65.0 && scrollView!.contentOffset.y < 0.0) {
                            setState(ViewState.Normal)
                        }
                    } else if (pullToRefreshViewState == ViewState.Normal) {
                        indicatorPullToRefresh.interactiveProgress = scrollView!.contentOffset.y / -130.0
                        
                        if (scrollView!.contentOffset.y < -65.0) {
                            setState(ViewState.Ready)
                        }
                    } else if (pullToRefreshViewState == ViewState.Loading) {
                        if (scrollView!.contentOffset.y >= 0) {
                            scrollView!.contentInset = startingContentInset!
                        } else {
                            scrollView!.contentInset = UIEdgeInsetsMake(min(-scrollView!.contentOffset.y, 60.0), 0, 0, 0);
                        }
                    }
                    // load more
                    let diff = scrollView!.contentOffset.y + scrollView!.bounds.height - scrollView!.contentSize.height

                    if (loadMoreViewState == ViewState.Ready) {
                        indicatorLoadMore.interactiveProgress = diff / 130.0
                        
                        if (diff < 65.0) {
                            setLoadMoreState(ViewState.Normal)
                        }
                    } else if (loadMoreViewState == ViewState.Normal) {
                        indicatorLoadMore.interactiveProgress = diff / 130.0
                        
                        if (diff > 65) {
                            setLoadMoreState(ViewState.Ready)
                        }
                    } else if (loadMoreViewState == ViewState.Loading) {
                        if (diff <= 0) {
                            scrollView!.contentInset = startingContentInset!
                        } else {
                            scrollView!.contentInset = UIEdgeInsetsMake(0, 0, 60.0, 0.0);
                        }
                    }
                    
                } else {
                    // pull to refresh
                    if (pullToRefreshViewState == ViewState.Ready) {
                        UIView.animateWithDuration(0.2, animations: {
                            self.setState(ViewState.Loading)
                        })
                        
                        if let pullToRefreshLoadMoreDelegate = pullToRefreshLoadMoreDelegate {
                            pullToRefreshLoadMoreDelegate.viewShouldRefresh()
                        }
                    }
                    
                    // load more
                    if (loadMoreViewState == ViewState.Ready) {
                        UIView.animateWithDuration(0.2, animations: {
                            self.setLoadMoreState(ViewState.Loading)
                        })
                        
                        if let pullToRefreshLoadMoreDelegate = pullToRefreshLoadMoreDelegate {
                            pullToRefreshLoadMoreDelegate.viewShouldLoadMore()
                        }
                    }
                }
            }
        default:
            break
        }
    }
}

public class MRTableView:UITableView {
    
    public var pullToRefresh:MRPullToRefreshLoadMore = MRPullToRefreshLoadMore()
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        pullToRefresh.initWithScrollView(self)
    }
    
    override public init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame:frame, style:style)
        pullToRefresh.initWithScrollView(self)
    }
}

public class MRCollectionView:UICollectionView {
    
    public var pullToRefresh:MRPullToRefreshLoadMore = MRPullToRefreshLoadMore()
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        pullToRefresh.initWithScrollView(self)
    }
    
    override public init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame:frame, collectionViewLayout:layout)
        pullToRefresh.initWithScrollView(self)
    }
}