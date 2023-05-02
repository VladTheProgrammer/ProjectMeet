//
//  QuestionsViewController.swift
//  Vino
//
//  Created by Vladimir Kisselev on 2018-05-01.
//  Copyright © 2018 Matias Jow. All rights reserved.
//

import Foundation

protocol DismissProfileEditorProtocol: class {
    func dismissViewController()
}

class QuestionsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITextViewDelegate, GoToQuestions, ReloadTable{
    
    let questionsTitle: UILabel = {
        let label = UILabel()
        label.text = "5 Questions About Me!"
        label.textAlignment = .center
        return label
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.dataSource = self
        cv.isPagingEnabled = false
        cv.keyboardDismissMode = .onDrag
        cv.backgroundColor = ColorSelector.BACKGROUND_COLOR
        cv.delegate = self
        
        return cv
    }()
    
    lazy var saveButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 3
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.backgroundColor = ColorSelector.SELECTED_COLOR
        button.setTitle("Save", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let questionCellID = "questionCellId"
    
    let answerCellID = "answerCellID"
    
    var collectionViewBottomAnchor: NSLayoutConstraint?
    
    var dismissDelegate: DismissProfileEditorProtocol?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorSelector.BACKGROUND_COLOR
        view.addSubview(questionsTitle)
        view.addSubview(collectionView)
        view.addSubview(saveButton)
        

        
        questionsTitle.anchorToTop(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor)
        
        _ = saveButton.anchor(nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 16, bottomConstant: 8, rightConstant: 16, widthConstant: 0, heightConstant: 40)
        
        registerCells()
        
        collectionViewBottomAnchor = collectionView.anchor(questionsTitle.bottomAnchor, left: view.leftAnchor, bottom: saveButton.topAnchor, right: view.rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 10, rightConstant: 0)[2]
        
        
        setupKeyboardObservers()
        
    }
    
    fileprivate func registerCells() {
        collectionView.register(QuestionCell.self, forCellWithReuseIdentifier: questionCellID)
        collectionView.register(AnswerCell.self, forCellWithReuseIdentifier: answerCellID)
    }
    
    @objc func saveButtonTapped() {
        CurrentUser.sharedInstance.handleSaveUserQuestionsToDatabase()
        self.dismiss(animated: true, completion: nil)
        dismissDelegate?.dismissViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if CurrentUser.sharedInstance.questionAnswerArray.count * 2 + 1 <= 10 {
            return CurrentUser.sharedInstance.questionAnswerArray.count * 2 + 1
        }
        
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print(indexPath)
        
        if indexPath.item < (CurrentUser.sharedInstance.questionAnswerArray.count * 2) {
            
            if (indexPath.item + 1) % 2 == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: answerCellID, for: indexPath) as! AnswerCell
                cell.answerView.delegate = self
                cell.answerView.tag = indexPath.item
                
                switch indexPath.item {
                case 1:
                    cell.answerView.text = CurrentUser.sharedInstance.questionAnswerArray[0].answer
                    break
                case 3:
                    cell.answerView.text = CurrentUser.sharedInstance.questionAnswerArray[1].answer
                    break
                case 5:
                    cell.answerView.text = CurrentUser.sharedInstance.questionAnswerArray[2].answer
                    break
                case 7:
                    cell.answerView.text = CurrentUser.sharedInstance.questionAnswerArray[3].answer
                    break
                case 9:
                    cell.answerView.text = CurrentUser.sharedInstance.questionAnswerArray[4].answer
                    break
                default:
                    break
                }
                
                
                //cell.answerView.text = String(indexPath.item)
                
                
                return cell
            }
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: questionCellID, for: indexPath) as! QuestionCell
            
            cell.questionsDelegate = self
            
            switch indexPath.item {
            case 0:
                cell.replacingIndex = 0
                cell.questionButton.setTitle(("\(1). " + CurrentUser.sharedInstance.questionAnswerArray[0].question), for: .normal)
                break
            case 2:
                cell.replacingIndex = 1
                cell.questionButton.setTitle(("\(2). " + CurrentUser.sharedInstance.questionAnswerArray[1].question), for: .normal)
                break
            case 4:
                cell.replacingIndex = 2
                cell.questionButton.setTitle(("\(3). " + CurrentUser.sharedInstance.questionAnswerArray[2].question), for: .normal)
                break
            case 6:
                cell.replacingIndex = 3
                cell.questionButton.setTitle(("\(4). " + CurrentUser.sharedInstance.questionAnswerArray[3].question), for: .normal)
                break
            case 8:
                cell.replacingIndex = 4
                cell.questionButton.setTitle(("\(5). " + CurrentUser.sharedInstance.questionAnswerArray[4].question), for: .normal)
                break
            default:
                break
            }
            
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: questionCellID, for: indexPath) as! QuestionCell
        
        cell.questionsDelegate = self
        cell.replacingIndex = -1
        
        cell.questionButton.setTitle("Touch Here to Select Question", for: .normal)
        
        return cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if (indexPath.item + 1) % 2 == 0 {
            return CGSize(width: view.frame.width, height: 50)
        }
        return CGSize(width: view.frame.width, height: view.frame.height * 0.05)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        collectionView.scrollToItem(at: IndexPath(item: textView.tag, section: 0), at: .centeredVertically, animated: false)
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    @objc private func handleKeyboardWillShow(notification: NSNotification){
        let keyboardFrame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        let keyboardDuration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        
        collectionViewBottomAnchor?.constant = -keyboardFrame!.height + saveButton.frame.height + 35
        UIView.animate(withDuration: keyboardDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func handleKeyboardWillHide(notification: NSNotification){
        let keyboardDuration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        
        collectionViewBottomAnchor?.constant = -10
        UIView.animate(withDuration: keyboardDuration) {
            self.view.layoutIfNeeded()
        }
        
    
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {

        CurrentUser.sharedInstance.questionAnswerArray[textView.tag / 2].answer = textView.text

        textView.resignFirstResponder()

        

    }
    
    func goToQuestionsList(replacingIndex: Int) {
        let questionsView = QuestionsListViewController()
        questionsView.replacingQuestionIndex = replacingIndex
        questionsView.reloadDelegate = self
        print("presented index: ", questionsView.replacingQuestionIndex ?? " ")
        self.present(questionsView, animated: true, completion: nil)
    }

    func handleTableReload() {
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}
