//
//  CellView.swift
//  GamingStreamsTVApp
//
//  Created by Gabriel Petrescu on 12/22/15.
//  Copyright © 2015 OwnZones. All rights reserved.
//

import UIKit
import Alamofire

protocol CellItem {
    var urlTemplate: String? { get }
    var title: String { get }
    var subtitle: String { get }
    var bannerString: String? { get }
    var image: UIImage? { get }
    mutating func setImage(image: UIImage)
}

class ItemCellView: UICollectionViewCell {
    internal static let CELL_IDENTIFIER : String = "kItemCellView"
    internal static let LABEL_HEIGHT : CGFloat = 40
    
    private var representedItem : CellItem?
    private var activityIndicator : UIActivityIndicatorView!
    private var image : UIImage?    

    @IBOutlet var imageView : UIImageView!
    @IBOutlet var titleLabel : ScrollingLabel!
    @IBOutlet var subtitleLabel : UILabel!
    
    override func awakeFromNib() {
    }
    
    /*
    * prepareForReuse()
    *
    * Override the default method to free internal ressources and add
    * a loading indicator
    */
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.representedItem = nil
        self.image = nil
        self.imageView.image = nil
        self.titleLabel.text = ""
        self.subtitleLabel.text = ""
        
        self.activityIndicator = UIActivityIndicatorView(frame: self.imageView.frame)
        self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        self.activityIndicator.startAnimating()
        
        self.imageView.addSubview(self.activityIndicator!)
        
        //we don't need to have this next line because we are turning on the 'adjustsImageWhenAncestorFocused' therefore we can't clip to bounds, and the corner radius has no effect if we aren't clipping
        self.imageView.layer.cornerRadius = 10
        self.imageView.backgroundColor = UIColor(white: 0.25, alpha: 0.7)
    }
    
    /*
    * assignImageAndDisplay()
    *
    * Downloads the image from the actual game and assigns it to the image view
    * Removes the loading indicator on download callback success
    */
    private func assignImageAndDisplay() {
        self.downloadImageWithSize(self.imageView!.bounds.size) {
            (image, error) in
            
            if let image = image {
                self.image = image
            } else {
                self.image = nil
            }
            
            
            dispatch_async(dispatch_get_main_queue(),{
                if self.activityIndicator != nil  {
                    self.activityIndicator?.removeFromSuperview()
                    self.activityIndicator = nil
                }
                self.imageView.image = self.image
            })
        }
    }
    
    /*
    * downloadImageWithSize(size : CGSize, completionHandler : (image : UIImage?, error : NSError?) -> ())
    *
    * Download an image from twitch server with the required size
    * Passes the downloaded image to a defined completion handler
    */
    private func downloadImageWithSize(size : CGSize, completionHandler : (image : UIImage?, error : NSError?) -> ()) {
        if let image = representedItem?.image {
            completionHandler(image: image, error: nil)
            return
        }
        if let imgUrlTemplate = representedItem?.urlTemplate {
            let imgUrlString = imgUrlTemplate.stringByReplacingOccurrencesOfString("{width}", withString: "\(Int(size.width))")
                .stringByReplacingOccurrencesOfString("{height}", withString: "\(Int(size.height))")
            Alamofire.request(.GET, imgUrlString).response() {
                (_, _, data, error) in
                
                guard let data = data, image = UIImage(data: data) else {
                    completionHandler(image: nil, error: nil)
                    return
                }
                self.representedItem?.setImage(image)
                completionHandler(image: image, error: nil)
            }
        }
    }
    
    /*
    * didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator)
    *
    * Responds to the focus update by either growing or shrinking
    *
    */
    override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocusInContext(context, withAnimationCoordinator: coordinator)
        if(context.nextFocusedView == self){
            coordinator.addCoordinatedAnimations({
                self.titleLabel.alpha = 1
                self.titleLabel.beginScrolling()
                
                self.subtitleLabel.alpha = 1
                },
                completion: nil
            )
        }
        else if(context.previouslyFocusedView == self) {
            coordinator.addCoordinatedAnimations({
                self.titleLabel.alpha = 0.5
                self.titleLabel.endScrolling()
                
                self.subtitleLabel.alpha = 0.5
                },
                completion: nil
            )
        }
    }
    
    var centerVerticalCoordinate: CGFloat {
        get {
            switch representedItem {
            case is OwnzoneStream:
                return 22
            default:
                return 22
            }
        }
    }
    
    /////////////////////////////
    // MARK - Getter and setters
    /////////////////////////////
    
    func getRepresentedItem() -> CellItem? {
        return self.representedItem
    }
    
    func setRepresentedItem(item : CellItem) {
        self.representedItem = item
        self.updateView ()
    }
    
    func updateView (){
        titleLabel.text = self.representedItem!.title
        subtitleLabel.text = self.representedItem!.subtitle
        imageView.image = UIImage(named: "1.jpg")
        self.assignImageAndDisplay()
    }
    
}
