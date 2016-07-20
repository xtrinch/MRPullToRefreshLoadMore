import UIKit

@objc public protocol MRPullToRefreshLoadMoreDelegate {
    func viewShouldRefresh(scrollView:UIScrollView)
    func viewShouldLoadMore(scrollView:UIScrollView)
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
    
    public var indicatorTintColor: UIColor? {
        didSet {
            indicatorLoadMore.indicatorTintColor = (indicatorTintColor ?? UIColor.whiteColor())
            indicatorPullToRefresh.indicatorTintColor = (indicatorTintColor ?? UIColor.whiteColor())
        }
    }

    var indicatorSize: CGSize = CGSizeMake(30.0, 30.0)
    public var textColor:UIColor = UIColor.whiteColor()
    
    public enum ViewState {
        case Normal
        case LoadingHorizontal
        case LoadingVertical
        case ReadyHorizontal
        case ReadyVertical
    }
    
    public enum Drag {
        case Left
        case Top
        case Right
        case Bottom
        case None
    }
    
    public func initWithScrollView(scrollView:UIScrollView) {
        scrollView.addSubview(indicatorPullToRefresh)
        scrollView.addSubview(indicatorLoadMore)
                
        self.scrollView = scrollView
        scrollView.addObserver(self, forKeyPath: "contentOffset", options: NSKeyValueObservingOptions.New, context: nil)
        startingContentInset = scrollView.contentInset
        print(startingContentInset)
        self.enabled = true
        setPullState(ViewState.Normal)
        setLoadMoreState(ViewState.Normal)
    }
    
    public func setLoadMoreState(state:ViewState) {
        loadMoreViewState = state
        
        switch (state) {
        case ViewState.ReadyVertical, ViewState.ReadyHorizontal:
            scrollView!.contentInset = self.startingContentInset!
            indicatorLoadMore.setAnimating(false)
            
        case ViewState.Normal:
            indicatorLoadMore.setAnimating(false)
            UIView.animateWithDuration(0.2, animations: {
                self.scrollView!.contentInset = self.startingContentInset!
            })
        case ViewState.LoadingVertical:
            indicatorLoadMore.setAnimating(true)
            scrollView!.contentInset = UIEdgeInsetsMake(0.0, 0.0, 60.0, 0.0)
        case ViewState.LoadingHorizontal:
            indicatorLoadMore.setAnimating(true)
            scrollView!.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 60.0)
        }
    }
    
    
    public func setPullState(state:ViewState) {
        pullToRefreshViewState = state
        
        switch (state) {
        case ViewState.ReadyHorizontal, ViewState.ReadyVertical:
            scrollView!.contentInset = self.startingContentInset!
            indicatorPullToRefresh.setAnimating(false)
        
        case ViewState.Normal:
            indicatorPullToRefresh.setAnimating(false)
            UIView.animateWithDuration(0.2, animations: {
                self.scrollView!.contentInset = self.startingContentInset!
            })
        
        case ViewState.LoadingHorizontal:
            indicatorPullToRefresh.setAnimating(true)
            scrollView!.contentInset = UIEdgeInsetsMake(0.0, 60.0, 0.0, 0.0)
        
        case ViewState.LoadingVertical:
            indicatorPullToRefresh.setAnimating(true)
            scrollView!.contentInset = UIEdgeInsetsMake(60.0, 0.0, 0.0, 0.0)
        }
    }
    
    
    override public func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        switch (keyPath) {
        case .Some("contentOffset"):
            
            if (enabled) {
                
                
                // HORIZONTAL SCROLL
                let diff_x_end = scrollView!.contentOffset.x + scrollView!.bounds.width - scrollView!.contentSize.width
                let diff_x_start = 0 - scrollView!.contentOffset.x
                
                let diff_y_end = scrollView!.contentOffset.y + scrollView!.bounds.height - scrollView!.contentSize.height
                let diff_y_start = 0 - scrollView!.contentOffset.y
                
                var drag:Drag = .None
                
                // pull to refresh
                if diff_x_start > 0.0 {
                    drag = .Left
                } else if diff_y_start > 0.0 {
                    drag = .Top
                } else if diff_x_end > 0.0 {
                    drag = .Right
                } else if diff_y_end > 0.0 {
                    drag = .Bottom
                }
                
                switch(drag) {
                case .Top:
                    indicatorPullToRefresh.frame = CGRectMake(scrollView!.bounds.width/2 - indicatorSize.width/2, -scrollView!.bounds.origin.y - 45 + scrollView!.contentOffset.y, indicatorSize.width, indicatorSize.height)
                case .Left:
                    indicatorPullToRefresh.frame = CGRectMake(-45, scrollView!.bounds.height/2 - 15, indicatorSize.width, indicatorSize.height)
                case .Bottom:
                    indicatorLoadMore.frame = CGRectMake(scrollView!.bounds.width/2 - indicatorSize.width/2, 15 + scrollView!.contentSize.height, indicatorSize.width, indicatorSize.height)
                case .Right:
                    indicatorLoadMore.frame = CGRectMake(scrollView!.contentSize.width + 15, scrollView!.bounds.height/2 - 15, indicatorSize.width, indicatorSize.height)
                default: break
                }
                
                
                if (scrollView!.dragging) {
                    switch(drag) {
                    case .Top:
                        switch(pullToRefreshViewState) {
                        case ViewState.ReadyVertical:
                            indicatorPullToRefresh.interactiveProgress = diff_y_start / 130.0
                            if (diff_y_start < 65.0) {
                                setPullState(ViewState.Normal)
                            }
                        case ViewState.Normal:
                            indicatorPullToRefresh.interactiveProgress = diff_y_start / 130.0
                            if (diff_y_start > 65.0) {
                                setPullState(ViewState.ReadyVertical)
                            }
                        default: break
                        }
                        
                    case .Left:
                        switch(pullToRefreshViewState) {
                        case ViewState.ReadyHorizontal:
                            indicatorPullToRefresh.interactiveProgress = diff_x_start / 130.0
                            if (diff_x_start < 65.0) {
                                setPullState(ViewState.Normal)
                            }
                        case ViewState.Normal:
                            indicatorPullToRefresh.interactiveProgress = diff_x_start / 130.0
                            if (diff_x_start > 65.0) {
                                setPullState(ViewState.ReadyHorizontal)
                            }
                        default: break
                        }
                    case .Bottom:
                        switch(loadMoreViewState) {
                        case ViewState.ReadyVertical:
                            indicatorLoadMore.interactiveProgress = diff_y_end / 130.0
                            if (diff_y_end < 65.0) {
                                setLoadMoreState(ViewState.Normal)
                            }
                        case ViewState.Normal:
                            indicatorLoadMore.interactiveProgress = diff_y_end / 130.0
                            if (diff_y_end > 65.0) {
                                setLoadMoreState(ViewState.ReadyVertical)
                            }
                        default: break
                        }
                    case .Right:
                        switch(loadMoreViewState) {
                        case ViewState.ReadyHorizontal:
                            indicatorLoadMore.interactiveProgress = diff_x_end / 130.0
                            if (diff_x_end < 65.0) {
                                setLoadMoreState(ViewState.Normal)
                            }
                        case ViewState.Normal:
                            indicatorLoadMore.interactiveProgress = diff_x_end / 130.0
                            if (diff_x_end > 65.0) {
                                setLoadMoreState(ViewState.ReadyHorizontal)
                            }
                        default: break
                        }
                    default: break
                    }
                } else {
                    // pull to refresh
                    if (pullToRefreshViewState == ViewState.ReadyHorizontal || pullToRefreshViewState == ViewState.ReadyVertical) {
                        UIView.animateWithDuration(0.2, animations: {
                            if self.pullToRefreshViewState == ViewState.ReadyHorizontal {
                                self.setPullState(ViewState.LoadingHorizontal)
                            } else {
                                self.setPullState(ViewState.LoadingVertical)
                            }
                        })
                        
                        if let pullToRefreshLoadMoreDelegate = pullToRefreshLoadMoreDelegate {
                            pullToRefreshLoadMoreDelegate.viewShouldRefresh(scrollView!)
                        }
                    }
                    
                    // load more
                    if (loadMoreViewState == ViewState.ReadyHorizontal || loadMoreViewState == ViewState.ReadyVertical) {
                        UIView.animateWithDuration(0.2, animations: {
                            if self.loadMoreViewState == ViewState.ReadyHorizontal {
                                self.setLoadMoreState(ViewState.LoadingHorizontal)
                            } else {
                                self.setLoadMoreState(ViewState.LoadingVertical)
                            }
                        })
                        
                        if let pullToRefreshLoadMoreDelegate = pullToRefreshLoadMoreDelegate {
                            pullToRefreshLoadMoreDelegate.viewShouldLoadMore(scrollView!)
                        }
                    }
                }
                
                print(loadMoreViewState)
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