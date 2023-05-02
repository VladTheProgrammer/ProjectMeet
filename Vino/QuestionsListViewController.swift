//
//  QuestionsListViewController.swift
//  Vino
//
//  Created by Vladimir Kisselev on 2018-05-04.
//  Copyright © 2018 Matias Jow. All rights reserved.
//

import Foundation

protocol ReloadTable: class {
    func handleTableReload()
}

class QuestionsListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, QuestionSelected {
    
    var replacingQuestionIndex: Int?
    
    var reloadDelegate: ReloadTable?
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = ColorSelector.BACKGROUND_COLOR
        cv.dataSource = self
        cv.isPagingEnabled = false
        cv.keyboardDismissMode = .onDrag
        cv.delegate = self
        return cv
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 3
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.backgroundColor = ColorSelector.SELECTED_COLOR
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let questionsListTitle: UILabel = {
        let label = UILabel()
        label.text = "Questions List"
        label.textAlignment = .center
        return label
    }()
    
    let questionFromServerCellID = "questionFromServerCellID"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorSelector.BACKGROUND_COLOR
        
        view.addSubview(questionsListTitle)
        view.addSubview(collectionView)
        view.addSubview(cancelButton)
        
        

        
        questionsListTitle.anchorToTop(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor)
        
        collectionView.anchorToTop(questionsListTitle.bottomAnchor, left: view.leftAnchor, bottom: cancelButton.topAnchor, right: view.rightAnchor)
        
        
        _ = cancelButton.anchor(nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 16, bottomConstant: 16, rightConstant: 16, widthConstant: 0, heightConstant: 40)
        
        collectionView.register(QuestionListCell.self, forCellWithReuseIdentifier: questionFromServerCellID)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return QuestionsMaster.sharedInstance.questionsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: questionFromServerCellID, for: indexPath) as! QuestionListCell
        cell.questionSelectedDelegate = self
        cell.questionButton.setTitle(QuestionsMaster.sharedInstance.questionsArray[indexPath.item], for: .normal)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height * 0.05)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    @objc func cancelButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func newQuestionSelected(question: String) {
        print(question)
        print("Replacing index: (Questions list)", replacingQuestionIndex)
        
        if replacingQuestionIndex! < 0 {
            CurrentUser.sharedInstance.questionAnswerArray.append(QuestionAnswer(question: question, answer: ""))
        } else {
            CurrentUser.sharedInstance.questionAnswerArray[replacingQuestionIndex!].question = question
        }
        
        self.reloadDelegate?.handleTableReload()
        self.dismiss(animated: true, completion: nil)
    }
}
