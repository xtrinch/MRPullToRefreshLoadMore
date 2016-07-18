@objc public protocol MRPullToRefreshLoadMoreDelegate {
    func viewShouldRefresh()
    func viewShouldLoadMore()
}

public class MRPullToRefreshLoadMore: UIView {

    public var scrollView:UIScrollView?
    public var delegate:MRPullToRefreshLoadMoreDelegate?
    public var enabled:Bool = true
    public var startingContentInset:UIEdgeInsets?
    public var pullToRefreshViewState:ViewState = ViewState.Normal
    public var loadMoreViewState:ViewState = ViewState.Normal
    
    public var arrowImage: CALayer?
    public var activityView: UIActivityIndicatorView?
    public var indicator = IndicatorView()
    var indicatorSize: CGSize = CGSizeMake(30.0, 30.0)
    public var textColor:UIColor = UIColor.whiteColor()
    
    public enum ViewState {
        case Normal
        case Loading
        case Ready
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public init(frame: CGRect) {
        super.init(frame:frame)
    }
    
    public func initWithScrollView(scrollView:UIScrollView) {
        self.addSubview(indicator)
        self.scrollView = scrollView       
        scrollView.addObserver(self, forKeyPath: "contentOffset", options: NSKeyValueObservingOptions.New, context: nil)
        startingContentInset = scrollView.contentInset
        
        self.enabled = true
        setState(ViewState.Normal)
    }
    
    
    public func setState(state:ViewState) {
        pullToRefreshViewState = state
        
        switch (state) {
            case ViewState.Ready:
                scrollView!.contentInset = self.startingContentInset!
                indicator.setAnimating(false)
            
            case ViewState.Normal:
                indicator.setAnimating(false)
                UIView.animateWithDuration(0.2, animations: {
                    self.scrollView!.contentInset = self.startingContentInset!
                })
            
            case ViewState.Loading:
                self.indicator.setAnimating(true)
                scrollView!.contentInset = UIEdgeInsetsMake(60.0, 0.0, 0.0, 0.0)
            
            default:
            break;
        }
    }
    
    override public func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        switch (keyPath, object) {
            
        case (.Some("contentOffset"), _):
            print(scrollView!.bounds.origin.y )
            print(scrollView!.contentOffset.y)
            indicator.frame = CGRectMake(scrollView!.bounds.width/2 - indicatorSize.width/2, -scrollView!.bounds.origin.y - 45, indicatorSize.width, indicatorSize.height)
            
            if (enabled) {
                if (scrollView!.dragging) {
                    
                    if (pullToRefreshViewState == ViewState.Ready) {
                        indicator.interactiveProgress = scrollView!.contentOffset.y / -130.0
                        
                        if (scrollView!.contentOffset.y > -65.0 && scrollView!.contentOffset.y < 0.0) {
                            setState(ViewState.Normal)
                        }
                    } else if (pullToRefreshViewState == ViewState.Normal) {
                        indicator.interactiveProgress = scrollView!.contentOffset.y / -130.0
                        
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
                } else {
                    if (pullToRefreshViewState == ViewState.Ready) {
                        UIView.animateWithDuration(0.2, animations: {
                            self.setState(ViewState.Loading)
                        })
                        
                        if let delegate = delegate {
                            delegate.viewShouldRefresh()
                        }
                    }
                }
                self.frame = CGRectMake(scrollView!.contentOffset.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height)
            }
        default:
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
}