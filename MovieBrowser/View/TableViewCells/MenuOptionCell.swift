//
//  MenuOptionCell.swift
//  MovieBrowser
//
//  Created by Shivam Kapur on 09/11/17.
//  Copyright © 2017 ShivamKapur. All rights reserved.
//

import UIKit

struct MenuOption
{
    let name: String
    let state: Bool
    let apiReqString: String
}

class MenuOptionCell: UITableViewCell
{
    private var label: UILabel =
    {
        let label = UILabel()
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    var menuOption: MenuOption? = nil
    {
        didSet
        {
            guard let option = menuOption else { return }
            label.text = option.name
        }
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder) has not been implemented.")
    }
    
    private func setupView()
    {
        contentView.backgroundColor = .white
        
        contentView.ext_addSubView(view: label)
        
        NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: contentView.topAnchor),
                label.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 4),
                label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                label.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -4)
            ])
        
    }
}
