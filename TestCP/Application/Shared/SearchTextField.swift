//
//  SearchTextField.swift
//  TestCP
//
//  Created by Ahmed K on 08/05/2017.
//  Copyright © 2017 Ahmed K. All rights reserved.
//

import UIKit
import Cartography


protocol SearchTextFieldDelegate {
    func didSelectPlace(_ place: Place)
}


class SearchTextField: UITextField {
    
    fileprivate var tableView:UITableView?
    fileprivate var places: [Place] = []
    
    var searchDelegate: SearchTextFieldDelegate?
    
    let cornerRadius:CGFloat = 5.0
    
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        defaultSetup()
        setupAutocompleteTable(view: superview!)
        
        constrain(self, tableView!, superview!) { (textfield, table, parent) in
            table.top == textfield.bottom + 8
            table.height == 220
            
            table.right == textfield.right
            table.left == textfield.left
            
        }
        
    }
    
    //RECT edit
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.minX + 10.0, y: bounds.minY + 5.0, width: bounds.width - 20.0, height: bounds.height - 10.0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return self.textRect(forBounds: bounds)
    }
    
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        if let superview = newSuperview {
            defaultSetup()
            setupAutocompleteTable(view: superview)
        }
    }
    
    fileprivate func defaultSetup(){

        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
        self.alpha = 0.65
        self.clearButtonMode = .always
        self.returnKeyType = .done
        
        self.delegate = self
        self.addTarget(self, action: #selector(self.textFieldDidChange), for: .editingChanged)
    }
    
    
    fileprivate func setupAutocompleteTable(view:UIView){
        
        let screenSize = UIScreen.main.bounds.size
        
        var tableViewFrame = self.frame
        tableViewFrame.origin.y     = self.frame.maxY + 8
        tableViewFrame.size.height  = screenSize.height - self.frame.height - self.frame.minY - 8
        
        self.tableView = UITableView(frame: tableViewFrame)
        tableView?.layer.cornerRadius = cornerRadius
        tableView?.clipsToBounds = true
        
        tableView?.isHidden = true
        tableView?.dataSource = self
        tableView?.delegate = self
        tableView?.rowHeight = UITableViewAutomaticDimension
        tableView?.estimatedRowHeight = 44
        tableView?.isHidden = true
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(self.tableView!)
    }
    
    fileprivate func hideTableView( _ hide: Bool) {
        self.alpha = hide == true ? 0.65 : 1.0
        self.tableView?.isHidden = hide
    }
}


extension SearchTextField: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.hideTableView(true)
        self.endEditing(true)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.hideTableView(false)
    }
    
    
    func textFieldDidChange(){
        guard let text = text else {
            return
        }
        tableView?.isHidden = false
        self.getDataFor(text)
    }
    
    
}

//MARK: Autocomplete tableview
extension SearchTextField: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.selectionStyle             = .none
        cell.textLabel?.textAlignment   = .left
        cell.textLabel?.numberOfLines   = 2
        cell.textLabel?.text = places[indexPath.row].longName
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        //inform the delegate
        let place = places[indexPath.row]
        self.text = place.name

        self.searchDelegate?.didSelectPlace(place)
        //Hide result
        tableView.isHidden = true
        self.endEditing(true)
        
        
    }
}

//MARK: API calls
extension SearchTextField {
    fileprivate func getDataFor(_ string: String) {
        if string.characters.count > 4 {
            ApiManager.geoCodeThis(string, withCompletion: { (result, error) in
                if let places = result {
                    self.places = places
                    self.tableView?.reloadData()
                }
            })
        }
    }
}
