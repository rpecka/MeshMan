//
//  SubjectViewController.swift
//  MeshMan
//
//  Created by Russell Pecka on 12/24/18.
//  Copyright © 2018 Russell Pecka. All rights reserved.
//

import UIKit

class SubjectViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var subjectField: UITextField!
    @IBOutlet private weak var rulesLabel: UILabel!
    
    // MARK: - Private Members
    
    private var netUtil: QuestionNetUtil!
    
    // MARK: - New Instance
    
    static func newInstance(netUtil: QuestionNetUtil) -> SubjectViewController {
        guard let subjectVC = Storyboards.subjectSelection.instantiateInitialViewController() as? SubjectViewController else { fatalError("Could not cast the resulting storyboard correctly") }
        subjectVC.netUtil = netUtil
        return subjectVC
    }
    
    // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        subjectField.delegate = self
        subjectField.becomeFirstResponder()
    }
    
    // MARK: -
    
    @IBAction func doneButtonPressed() {
        guard let text = subjectField.text else { return }
        processText(input: text)
    }
    
    // MARK: - Input Sanitation
    
    private func processText(input: String) {
        // TODO: Add sanitation code here
        showGame(subject: input)
    }
    
    // MARK: - Showing the Game
    
    private func showGame(subject: String) {
        let answersVC = AnswerViewController.newInstance(subject: subject, netUtil: netUtil, turnManager: QuestionsTurnManager(session: netUtil.session, myPeerID: MCManager.shared.peerID, firstPicker: MCManager.shared.peerID))
        netUtil.send(message: StartMessage(gameType: .questions, payload: QuestionNetUtil.StartGamePayload(subject: subject, firstPicker: MCManager.shared.peerID)))
        navigationController?.setViewControllers([answersVC], animated: true)
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else { return false }
        processText(input: text)
        textField.resignFirstResponder()
        return false
    }

}