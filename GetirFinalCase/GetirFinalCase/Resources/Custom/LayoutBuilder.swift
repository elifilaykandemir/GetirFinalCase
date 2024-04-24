//
//  LayoutBuilder.swift
//  GetirFinalCase
//
//  Created by Elif İlay KANDEMİR on 12.04.2024.
//

import UIKit

final class LayoutBuilder {

    static func createHorizontalScrollingSection(backgroundElementKind: String) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(120),
            heightDimension: .absolute(180)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 8,
            leading: 8,
            bottom: 0,
            trailing: 8
        )
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(120),
            heightDimension: .absolute(180)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 24,
            leading: 0,
            bottom: 16,
            trailing: 0
        )
        let sectionBackground = NSCollectionLayoutDecorationItem.background(elementKind: backgroundElementKind)
        sectionBackground.contentInsets = NSDirectionalEdgeInsets(
            top: 16,
            leading: 0,
            bottom: 16,
            trailing: 0
        )
        section.decorationItems = [sectionBackground]
        
        return section
    }
}

class SectionBackroundView: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class DividerView: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.primaryGray 
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
