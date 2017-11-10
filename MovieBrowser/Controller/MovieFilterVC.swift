//
//  MovieFilterVC.swift
//  MovieBrowser
//
//  Created by Shivam Kapur on 09/11/17.
//  Copyright © 2017 ShivamKapur. All rights reserved.
//

import UIKit

protocol MovieFilterDelegate: class
{
    func didSelectPredicate(viewCon: MovieFilterVC, type: MenuOption)
}

class MovieFilterVC: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    weak var delegate: MovieFilterDelegate? = nil
    
    var sortPredicate: MenuOption? = nil
    
    private var _prevIndexPath: IndexPath? = nil
    
    private struct Identifiers
    {
        static let menuCellID = "menuCellID"
    }
    
    private let _menuItems: [MenuOption] =
    {
        let op1 = MenuOption.init(name: "Sort By Popuplarity(Descending)", state: false, apiReqString: NetworkEngine.SortKeys.SORT_BY_POPULAR)
        let op2 = MenuOption.init(name: "Sort by Rating(Descending)", state: false, apiReqString: NetworkEngine.SortKeys.SORT_BY_RATING)
        
        return [op1, op2]
    }()
    
    private lazy var tableView: UITableView =
    {
        let tv = UITableView()
        tv.backgroundColor = .white
        tv.delegate = self
        tv.dataSource = self
        return tv
    }()
    
    private lazy var doneButton: UIButton =
    {
        let button = UIButton()
        button.addTarget(self, action: #selector(doneTapped(_:)), for: .touchUpInside)
        button.setTitle("Done", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    override func loadView()
    {
        super.loadView()
        
        setupView()
        registerCells()
    }
    
    private func setupView()
    {
        view.backgroundColor = .white
    
        view.ext_addSubView(view: tableView)
        view.ext_addSubView(view: doneButton)
        
        NSLayoutConstraint.activate([
                tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
                tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
                tableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4)
            ])
        
        NSLayoutConstraint.activate([
            doneButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 8),
                doneButton.leftAnchor.constraint(equalTo: tableView.leftAnchor),
                doneButton.rightAnchor.constraint(equalTo: tableView.rightAnchor),
                doneButton.heightAnchor.constraint(equalToConstant: 34)
            ])
        
        tableView.tableFooterView = UIView()
    }
    
    private func setupNavTitle()
    {
        self.navigationItem.title = "Sort Movies"
    }
    
    private func registerCells()
    {
        tableView.register(MenuOptionCell.self, forCellReuseIdentifier: Identifiers.menuCellID)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return _menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.menuCellID) as? MenuOptionCell
        else
        {
            return MenuOptionCell()
        }
        
        let menuItem = _menuItems[indexPath.row]
        
        cell.menuOption = menuItem
        
        if let sortPredicate = sortPredicate
        {
            if sortPredicate.apiReqString == menuItem.apiReqString
            {
                _prevIndexPath = indexPath
                cell.accessoryType = .checkmark
            }
        }
        
        return cell 
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if let prevIndex = _prevIndexPath
        {
            guard let cell = tableView.cellForRow(at: prevIndex) as? MenuOptionCell
            else
            {
                return
            }
            
            cell.accessoryType = .none
            
        }
        
        guard let cell = tableView.cellForRow(at: indexPath) as? MenuOptionCell
        else
        {
            return
        }
        
        sortPredicate = cell.menuOption
        cell.accessoryType = .checkmark
        _prevIndexPath = indexPath
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 30
    }
    
    @objc
    private func doneTapped(_ sender: UIButton)
    {
        guard let predicate = sortPredicate else { return }
        delegate?.didSelectPredicate(viewCon: self, type: predicate)
        self.navigationController?.popViewController(animated: true)
    }
}

