//
//  ProductListingViewController.swift
//  GetirFinalCase
//
//  Created by Elif İlay KANDEMİR
//

import UIKit
import Kingfisher

enum Section: Int, CaseIterable {
    case horizontal
    case vertical
}

protocol ProductListingViewProtocol: AnyObject {
    func reloadProductList()
    func refreshCartAmount(_ amount: Double)
    func setupNavBar()
    func configureCollectionView()
    func updateCartVisibility(shouldShowCartButton: Bool)
}

final class ProductListingViewController: UIViewController {
    
    var presenter: ProductListingPresenter!
    
    private lazy var customNavBar = CustomNavigationBar(title: "Ürünler", showCloseButton: false)
    private lazy var collectionView = UICollectionView()
    static let background = "background-element-kind"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .primary
        setupConstraint()
        presenter.viewDidLoad()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
        
    }
}
extension ProductListingViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Section.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.numberOfItems(in: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.identifier, for: indexPath) as? ProductCollectionViewCell else {
            fatalError("Could not dequeue a ProductCollectionViewCell")
        }
        if let product = presenter.product(for: indexPath),let imageURL = presenter.productImageURL(for: indexPath){
            cell.presenter = ProductCellPresenter(view: cell, product: product, imageURL: imageURL)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let section = Section(rawValue: indexPath.section) else { return }
        switch section {
        case .horizontal:
            presenter.didSelectProduct(at: indexPath.item, in: .horizontal)
        case .vertical:
            presenter.didSelectProduct(at: indexPath.item, in: .vertical)
        }
    }
}

extension ProductListingViewController {
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            guard let self = self else { return nil }
            guard let sectionType = Section(rawValue: sectionIndex) else { return nil }
            
            switch sectionType {
            case .horizontal:
                return LayoutBuilder.createHorizontalScrollingSection(backgroundElementKind: ProductListingViewController.background)
            case .vertical:
                return self.createVerticalSection()
            }
        }
        layout.register(
            SectionBackroundView.self,
            forDecorationViewOfKind: ProductListingViewController.background
        )
        return layout
    }
    private func createVerticalSection() -> NSCollectionLayoutSection {
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

extension ProductListingViewController: ProductListingViewProtocol {
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        collectionView.register(ProductCollectionViewCell.self, forCellWithReuseIdentifier: ProductCollectionViewCell.identifier)
        view.addSubview(collectionView)
        collectionView.setupConstraints(
            leadingAnchor:view.leadingAnchor,
            topAnchor: customNavBar.bottomAnchor,
            topConstant: 16,
            trailingAnchor: view.trailingAnchor,
            bottomAnchor: view.bottomAnchor
        )
        collectionView.backgroundColor = .systemGray6
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
    func setupConstraint(){
        view.addSubview(customNavBar)
        customNavBar.setupConstraints(
            leadingAnchor: view.leadingAnchor,
            topAnchor: view.safeAreaLayoutGuide.topAnchor,
            trailingAnchor: view.trailingAnchor,
            height: 34
        )
    }
    
    func setupNavBar() {
        customNavBar.onCartButtonTapped = { [weak self] in
            self?.cartButtonTapped()
        }
    }
    
    func reloadProductList() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func refreshCartAmount(_ amount: Double) {
        DispatchQueue.main.async { [weak self] in
            self?.customNavBar.updateCartAmount(to: amount)
            self?.customNavBar.updateCartVisibility(shouldShowCartButton: amount > 0)
        }
    }
    func cartButtonTapped() {
        presenter.didTapCartButton()
    }
    
    func updateCartVisibility(shouldShowCartButton: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.customNavBar.updateCartVisibility(shouldShowCartButton: shouldShowCartButton)
        }
    }
    
}
