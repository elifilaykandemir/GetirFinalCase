//
//  BasketViewController.swift
//  GetirFinalCase
//
//  Created by Elif İlay KANDEMİR on 15.04.2024.
//

import UIKit

enum BasketSection: Int, CaseIterable {
    case vertical
    case horizontal
}

protocol BasketViewProtocol: AnyObject {
    func reloadProductList()
    func configureCollectionView()
    func closeButtonAction()
    func trashButtonAction()
    func checkOutButtonAction()
    func didTapAlertConfirmAction()
    func didTapSuccessViewOkButtonAction()
}

final class BasketViewController: UIViewController {
    
    var presenter: BasketViewPresenter!
    
    private lazy var customNavBar = BasketNavigationBar(title: "Sepetim")
    private lazy var checkOutView = CheckOutView()
    
    private lazy var customAlert : CustomAlertView = {
        let alertView = CustomAlertView()
        alertView.modalPresentationStyle = .overFullScreen
        alertView.modalTransitionStyle = .crossDissolve
        return alertView
    }()
    
    private lazy var successView : CustomSuccessView = {
        let alertView = CustomSuccessView()
        alertView.modalPresentationStyle = .overFullScreen
        alertView.modalTransitionStyle = .crossDissolve
        return alertView
    }()
    
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

extension BasketViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return BasketSection.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.numberOfItems(in: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let sectionType = BasketSection(rawValue: indexPath.section) else { fatalError("Unexpected section index") }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BasketCollectionViewCell.identifier, for: indexPath) as! BasketCollectionViewCell
        if let product = presenter.product(for: indexPath),let imageURL = presenter.productImageURL(for: indexPath){
            cell.presenter = BasketCellPresenter(view: cell, product: product, imageURL: imageURL)
        }
        return cell
    }
}

extension BasketViewController {
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            guard let self = self else { return nil }
            return self.createVerticalSection()
        }
        layout.register(
            SectionBackroundView.self,
            forDecorationViewOfKind: BasketViewController.background
        )
        return layout
    }
    private func createVerticalSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
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
            heightDimension: .absolute(110)
        )
        let group = NSCollectionLayoutGroup.vertical(
                layoutSize: groupSize,
                subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        let sectionBackground = NSCollectionLayoutDecorationItem.background(
            elementKind: BasketViewController.background)
        
        section.decorationItems = [sectionBackground]
        return section
    }
}

extension BasketViewController: BasketViewProtocol {
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        collectionView.register(BasketCollectionViewCell.self, forCellWithReuseIdentifier: BasketCollectionViewCell.identifier)
        view.addSubview(collectionView)
        collectionView.setupConstraints(
            leadingAnchor:view.leadingAnchor,
            topAnchor: customNavBar.bottomAnchor,
            topConstant: 16,
            trailingAnchor: view.trailingAnchor,
            bottomAnchor: checkOutView.topAnchor
        )
        collectionView.backgroundColor = .systemGray6
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
    func setupConstraint(){
        view.addSubview(customNavBar)
        view.addSubview(checkOutView)
        customNavBar.setupConstraints(
            leadingAnchor: view.leadingAnchor,
            topAnchor: view.safeAreaLayoutGuide.topAnchor,
            trailingAnchor: view.trailingAnchor,
            height: 24
        )
        checkOutView.setupConstraints(
            leadingAnchor: view.leadingAnchor,
            trailingAnchor: view.trailingAnchor,
            bottomAnchor: view.bottomAnchor,
            height: 98
        )
    }
   
    func reloadProductList() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }

    func trashButtonAction() {
        customNavBar.onTrashButtonTapped = { [weak self] in
            guard let self else { return }
            self.present(customAlert, animated: true, completion: nil)
        }
    }
    func checkOutButtonAction(){
        checkOutView.onCheckoutButtonTapped = { [weak self] in
            guard let self else { return }
            present(successView, animated: true, completion: nil)
        }
        
    }
    func didTapAlertConfirmAction(){
        customAlert.onTapConfirm = { [weak self] in
            guard let self else { return }
            presenter.didTapConfirmButton()
        }
    }
    func closeButtonAction(){
        customNavBar.onCloseTapped = { [weak self] in
            self?.presenter.didTapCloseButton()
        }
    }
    func didTapSuccessViewOkButtonAction(){
        successView.onTapOk = { [weak self] in
            guard let self else { return }
            presenter.didTapOkButton()
        }
    }
    
}
