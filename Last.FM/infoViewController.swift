//
//  infoViewController.swift
//  Last.FM
//
//  Created by Jenish Dhaduk on 6/26/19.
//  Copyright © 2019 iphone. All rights reserved.
//

import UIKit

class infoViewController: UIViewController {
 

    @IBOutlet weak var lblViewDetail: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var txtViewUrl: UITextView!
    @IBOutlet weak var txtViewInfo: UITextView!

    var strServerLink = "http://ws.audioscrobbler.com/2.0/?"
    var strApiKey = "335f3c1b4e600890349c916169e8afab"

    var strDetail = String()
    var dictInfoDetails = [String:AnyObject]()
    var dictDetails = NSDictionary()
    @IBOutlet weak var viewInfo: UITextView!
    // MARK: - Life-Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print(dictInfoDetails)
        setData()
    }
    
    // MARK: - Set data
    func setData(){
        lblViewDetail.text = strDetail
      
        if let strName = dictInfoDetails["name"] as? String{
            lblName.text = strName
            
            if let strArt = dictInfoDetails["artist"] as? String{
                wsSetArtistInfo(strArtist: strArt)}
        }
        if let strURL = dictInfoDetails["url"] as? String{
            txtViewUrl.text = strURL
        }
    }

    // MARK: - Button Action method
    @IBAction func btnBackAct(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func setDetails(){
        if let dict = dictDetails.value(forKey: "bio") as? NSDictionary{
            DispatchQueue.main.async {
                
                self.txtViewInfo.text = dict.value(forKey: "content")  as? String
            }

        }
    }
    // MARK: - WebService
    func wsSetArtistInfo(strArtist : String){
        postService(Serverlink: "\(strServerLink)method=artist.getinfo&artist=\(strArtist)&api_key=\(strApiKey)&format=json") { (sucess, response) in
            if sucess{
                print(response)
                if let dict = response.value(forKey: "artist") as? NSDictionary{
                self.dictDetails = dict
                    self.setDetails()
                    
                }
            }else{
                
            }
        }
    }
}
