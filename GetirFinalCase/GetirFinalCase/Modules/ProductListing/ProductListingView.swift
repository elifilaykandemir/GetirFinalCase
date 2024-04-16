//
//  ProductListingViewController.swift
//  GetirFinalCase
//
//  Created by Elif İlay KANDEMİR
//

import UIKit

enum Section: Int, CaseIterable {
    case horizontal
    case vertical
}

protocol ProductListingViewProtocol: AnyObject {
    func reloadProductList()
    func refreshCartAmount(_ amount: Double)
    func setupNavBar()
    func configureCollectionView()
}

final class ProductListingViewController: UIViewController {
    
    var presenter: ProductListingPresenter!
    
    private lazy var customNavBar = CustomNavigationBar(title: "Ürünler", showCloseButton: false)
    private lazy var collectionView = UICollectionView()
    static let background = "background-element-kind"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        configureNavigationBarAppearance(color: .primary)

    }


}

extension ProductListingViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.identifier, for: indexPath) as? ProductCollectionViewCell else {
            fatalError("Could not dequeue a ProductCollectionViewCell")
        }
        if let product = presenter.product(indexPath.item), let image = presenter.productImage(indexPath.item){
            cell.presenter = ProductCellPresenter(view: cell, product: product, images: image)
            
        }
    
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didSelectProduct(at: indexPath.item)
    }
}

extension ProductListingViewController {
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionNumber, environment) -> NSCollectionLayoutSection? in
            if sectionNumber == 0 {
                return LayoutBuilder.createHorizontalScrollingSection(backgroundElementKind: ProductListingViewController.background)
            } else {
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1/3),
                    heightDimension: .fractionalHeight(1)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(
                    top: 8,
                    leading: 8,
                    bottom: 8,
                    trailing: 8
                )
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(190)
                )
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: groupSize,
                    subitem: item,
                    count: 3
                )
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(
                    top: 16,
                    leading: 16,
                    bottom: 8,
                    trailing: 16
                )
                let sectionBackground = NSCollectionLayoutDecorationItem.background(
                    elementKind: ProductListingViewController.background)
                
                section.decorationItems = [sectionBackground]
                return section
            }
        }
        layout.register(
            SectionBackroundView.self,
            forDecorationViewOfKind: ProductListingViewController.background
        )
        return layout
    }
}

extension ProductListingViewController: ProductListingViewProtocol {
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        collectionView.register(ProductCollectionViewCell.self, forCellWithReuseIdentifier: ProductCollectionViewCell.identifier)
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemGray4
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    
    func setupNavBar(){
        lazy var cartButton = CartButton()
        cartButton.addTarget(self, action: #selector(cartButtonTapped), for: .touchUpInside)
        let cartBarButtonItem = UIBarButtonItem(customView: cartButton)
        self.navigationItem.rightBarButtonItem = cartBarButtonItem
        self.navigationItem.titleView = customNavBar
    }
    func reloadProductList() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func refreshCartAmount(_ amount: Double) {
        print("")
    }
    
    
    @objc func cartButtonTapped() {
        presenter.didTapCartButton()
    }
    
}
