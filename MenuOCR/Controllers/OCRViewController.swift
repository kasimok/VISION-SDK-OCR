import UIKit
import TesseractOCR
import MarqueeLabel

final class OCRViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource{
    
    // MARK: - Properties
    fileprivate let reuseIdentifier = "OCRCell"
    fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    
    public var results = [UIImage]()
    @IBOutlet var wait: UIActivityIndicatorView!
    fileprivate let itemsPerRow: Int = 1
    @IBOutlet var labelWrapperView: UIView!
    
    
    
    var hintLabel:MarqueeLabel!
    
    var tesseract:G8Tesseract = G8Tesseract(language:"eng+chi_sim");
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(results.count)
        print(tesseract.absoluteDataPath)
        tesseract.delegate = self;
        setupDebugLable()
        wait.isHidden = true
    }
    
}


// MARK: - Private
private extension OCRViewController {
    func photoForIndexPath(indexPath: IndexPath) -> UIImage {
        return results[(indexPath as IndexPath).section]
    }
}


// MARK: - UICollectionViewDataSource
extension OCRViewController{
    //1
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return results.count
    }
    
    //2
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return itemsPerRow
    }
    
    //3
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath) as! TextRecognitionResultCell
        cell.backgroundColor = UIColor.black
        // Configure the cell
        
        let image = photoForIndexPath(indexPath: indexPath)
        cell.imageView.image = image
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let image = photoForIndexPath(indexPath: indexPath)
        print(image.size)
        self.wait.isHidden = false
        self.wait.startAnimating()
        
        
        DispatchQueue.global().async {
            self.tesseract.image = image
            self.tesseract.recognize();
            print("------------------------------------\n"+self.tesseract.recognizedText)
            DispatchQueue.main.async {
                self.hintLabel.text = self.tesseract.recognizedText
                self.wait.isHidden = true
                self.wait.stopAnimating()
            }
        }
        
    }
}


extension OCRViewController : UICollectionViewDelegateFlowLayout {
    //1
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //2
        let paddingSpace = sectionInsets.left * (CGFloat(itemsPerRow) + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / CGFloat(itemsPerRow)
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    // 4
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}


extension OCRViewController: G8TesseractDelegate{
    func shouldCancelImageRecognitionForTesseract(tesseract: G8Tesseract!) -> Bool {
        return false; // return true if you need to interrupt tesseract before it finishes
    }
}

//set up debugging area
extension OCRViewController{
    func setupDebugLable(){
        hintLabel = MarqueeLabel(frame: labelWrapperView.bounds, duration: 7.0, fadeLength: 0)
        hintLabel.font = UIFont.systemFont(ofSize: 13)
        hintLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        labelWrapperView.addSubview(hintLabel)
    }
}

