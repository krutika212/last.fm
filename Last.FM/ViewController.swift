//
//  ViewController.swift
//  Last.FM
//
//  Created by Jenish Dhaduk on 6/26/19.
//  Copyright © 2019 iphone. All rights reserved.
//

import UIKit
import SDWebImage

class ViewController:
UIViewController,UITableViewDelegate,UITableViewDataSource ,UISearchBarDelegate{

    var strServerLink = "http://ws.audioscrobbler.com/2.0/?"
    var strApiKey = "335f3c1b4e600890349c916169e8afab"

    var dictArtistResponse = [[String:AnyObject]]()
    var dictTrackResponse = [[String:AnyObject]]()
    var dictAlbumResponse = [[String:AnyObject]]()
   
    var page = 1
    var Limit = 10
    var strAlbumm = String()
    var strArtistt = String()
    var strTrackk = String()


    // MARK: - Outlet
    @IBOutlet weak var searchBarDetails: UISearchBar!
    @IBOutlet weak var tblViewDetails: UITableView!
    
    
    // MARK: - Life-Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        searchBarDetails.delegate = self
    }
    
    // MARK: - tablview Method
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return dictAlbumResponse.count
        }else if section == 1{
            return dictArtistResponse.count
        }else{
            return dictTrackResponse.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! detailTableViewCell
        if indexPath.section == 0{
            if dictAlbumResponse.count>0{
                
            if let strName = (dictAlbumResponse[indexPath.row] as AnyObject).value(forKey: "name") as? String{
                    cell.lblAlbumName.text = strName
                }
                
            
        if let array = (dictAlbumResponse[indexPath.row] as AnyObject).value(forKey: "image") as? [[String:AnyObject]]{
     
        if let stringImg = (array[1] as AnyObject).value(forKey: "#text") as? String {
       
        if stringImg != ""{
        cell.lblAlbumImage.sd_setImage(with: URL(string: stringImg), completed: nil)
                }
            }
                }}
        }else if indexPath.section == 1{
            if dictArtistResponse.count > 0 {
                if let strName = (dictArtistResponse[indexPath.row] as AnyObject).value(forKey: "name") as? String{
                    cell.lblAlbumName.text = strName
                }
            
            if let array = (dictArtistResponse[indexPath.row] as AnyObject).value(forKey: "image") as? [[String:AnyObject]]{
                
                if let stringImg = (array[1] as AnyObject).value(forKey: "#text") as? String {
                    
                    if stringImg != ""{
                        cell.lblAlbumImage.sd_setImage(with: URL(string: stringImg), completed: nil)
                    }
                }
            }
            }}
        else{
            if dictTrackResponse.count > 0 {
                if let strName = (dictTrackResponse[indexPath.row] as AnyObject).value(forKey: "name") as? String{
                cell.lblAlbumName.text = strName
                }
                if let array = (dictTrackResponse[indexPath.row] as AnyObject).value(forKey: "image") as? [[String:AnyObject]]{
                    
                    if let stringImg = (array[1] as AnyObject).value(forKey: "#text") as? String {
                        
                        if stringImg != ""{
                            cell.lblAlbumImage.sd_setImage(with: URL(string: stringImg), completed: nil)
                        }
                    }
                }
            }}
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            let objInfo = self.storyboard?.instantiateViewController(withIdentifier: "infoViewController") as! infoViewController
            objInfo.dictInfoDetails = dictAlbumResponse[indexPath.row]
            objInfo.strDetail = "Album"
            self.navigationController?.pushViewController(objInfo, animated: true)
        }else if indexPath.section == 1{
            let objInfo = self.storyboard?.instantiateViewController(withIdentifier: "infoViewController") as! infoViewController
            objInfo.dictInfoDetails = dictArtistResponse[indexPath.row]
            objInfo.strDetail = "Artist"
            self.navigationController?.pushViewController(objInfo, animated: true)
        }else{
            let objInfo = self.storyboard?.instantiateViewController(withIdentifier: "infoViewController") as! infoViewController
            objInfo.dictInfoDetails = dictTrackResponse[indexPath.row]
            objInfo.strDetail = "Track"
            self.navigationController?.pushViewController(objInfo, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "Album"}
        else if section == 1{
            return "Artist"
        }else{
            return "Track"

        }
        return ""
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == ((tableView.indexPathsForVisibleRows)?.last)?.row{
        
        let intSection = tableView.numberOfSections - 1
            let intRow = tableView.numberOfRows(inSection: intSection) - 1
            if (indexPath.section  == intSection) && indexPath.row == intRow {
                wsSearchAlbum(strAlbum: strAlbumm , page : page + 1 , limit  : Limit + 10)
                wsSearchArtist(strArtist: strArtistt, page : page + 1, limit : Limit + 10)
                wsSearchSong(strSong: strTrackk,  page : page + 1, limit : Limit + 10)
                
                self.tblViewDetails.reloadData()
            }
            
        }
    }
    // MARK: - TableviewReload
    func setTblReload(){
        DispatchQueue.main.async {
            self.tblViewDetails.delegate = self
            self.tblViewDetails.dataSource = self
            self.tblViewDetails.reloadData()
        }
    }
    
    // MARK: - SearchBar Method

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        wsSearchAlbum(strAlbum: searchText , page : page , limit : Limit)
        wsSearchArtist(strArtist: searchText, page : page , limit : Limit)
        wsSearchSong(strSong: searchText,  page : page, limit : Limit)

    }
   
    // MARK: - Webservices
    func wsSearchAlbum(strAlbum : String ,page : Int , limit : Int){
       postService(Serverlink: "\(strServerLink)method=album.search&limit=\(limit)&page=\(page)&album=\(strAlbum)&api_key=\(strApiKey)&format=json") { (sucess, response) in
            if sucess{
                self.strAlbumm = strAlbum
                if response.allKeys.count > 0{
                if let dict2 = (response.value(forKey: "results") as! NSDictionary).value(forKey: "albummatches") as? NSDictionary{
                self.dictAlbumResponse = dict2.value(forKey: "album") as! [[String:AnyObject]]
                    print(self.dictAlbumResponse)
                    //self.page = self.page + 1

                    }}else{
                    self.dictAlbumResponse.removeAll()
                }
               self.setTblReload()
                
            }else{
                
            }
        }
    }
    func wsSearchArtist(strArtist : String , page : Int , limit : Int){
        postService(Serverlink: "\(strServerLink)method=artist.search&limit=\(limit)&page=\(page)&artist=\(strArtist)&api_key=\(strApiKey)&format=json") { (sucess, response) in
            if sucess{
                self.strArtistt = strArtist
                if response.allKeys.count > 0{
                    if let dict2 = (response.value(forKey: "results") as! NSDictionary).value(forKey: "artistmatches") as? NSDictionary{
                        self.dictArtistResponse = dict2.value(forKey: "artist") as! [[String:AnyObject]]
                        print(self.dictArtistResponse)
                        //self.page = self.page + 1

                    }}else{
                    self.dictArtistResponse.removeAll()
                }
                self.setTblReload()

                
            }else{
                
            }
            }
        }
    func wsSearchSong(strSong : String , page : Int , limit : Int){
        postService(Serverlink: "\(strServerLink)method=track.search&limit=\(limit)&page=\(page)&track=\(strSong)&artist=\(strSong)&api_key=\(strApiKey)&format=json") { (sucess, response) in
            if sucess{
                self.strTrackk = strSong
                if response.allKeys.count > 0{
                    if let dict2 = (response.value(forKey: "results") as! NSDictionary).value(forKey: "trackmatches") as? NSDictionary{
                        self.dictTrackResponse = dict2.value(forKey: "track") as! [[String:AnyObject]]
                        print(self.dictTrackResponse)

                    }}else{
                    self.dictTrackResponse.removeAll()
                }
                self.setTblReload()

                
            }else{
                
            }
        }
    }

}

