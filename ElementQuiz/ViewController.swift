//
//  ViewController.swift
//  ElementQuiz
//
//  Created by Paloma Cristina Santana on 28/04/22.
//

import UIKit

enum State {
    case question, answer, score
}

enum Mode {
    case flashCard,quiz
}

class ViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var answerLabel: UILabel!
    
    @IBOutlet weak var modeSelector: UISegmentedControl!
    @IBOutlet weak var textField: UITextField!
    // Estado especifico teste
    var answerIsCorrect = false
    var correctAnswerCount = 0
    
    let elementList = ["Carbono", "Ouro", "Cloro", "Sódio"]
    
    var mode: Mode = .flashCard {
        didSet{
            updateUI()
        }
    }
    var state: State = .question
    
    var currentElementIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        //textField.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Pegar o texto do campo de texto
        let textFieldContents = textField.text!
        // Determina se o usuário respondeu corretamente e atualiza o estado de teste
        if textFieldContents.lowercased() == elementList[currentElementIndex].lowercased() {
            answerIsCorrect = true
            correctAnswerCount += 1
        } else {
            answerIsCorrect = false
        }
        // O aplicativo agora deve mostrar a resposta do usuário
        state = .answer
        updateUI()
        return true
    }
    
    // Atualiza a UI do app no modo ficha de estudo
    func updateFlashCardUI(elementName: String){
        modeSelector.selectedSegmentIndex = 0
        textField.isHidden = true
        textField.resignFirstResponder()
        
        if state == .answer {
            answerLabel.text = elementName
        } else {
            answerLabel.text = "?"
        }
    }
    
    // Atualiza a UI do app no modo teste
    func updateQuizUI(elementName: String){
        modeSelector.selectedSegmentIndex = 1
        textField.isHidden = false
        switch state{
            case .question:
                answerLabel.text = ""
                textField.becomeFirstResponder()
            case .answer:
            textField.resignFirstResponder()
            if answerIsCorrect {
                answerLabel.text = "Correto!"
            } else {
                answerLabel.text = "❌"
            }
        
        case .score:
            textField.isHidden = true
            textField.resignFirstResponder()
            answerLabel.text = ""
            displayScoreAlert()
        }
    }
    
    // Atualiza a UI do app com base no modo e estado.
    func updateUI(){
        let elementName = elementList[currentElementIndex]
        let image = UIImage(named: elementName)
        imageView.image = image
        switch mode{
        case .flashCard:
            updateFlashCardUI(elementName: elementName)
        case .quiz:
            updateQuizUI(elementName:elementName)
        }
    }
    
    
    //Mostra um alerta no IOS com a pontuacao do teste do usuário
    func displayScoreAlert(){
        let alert = UIAlertController(title: "Quiz Score", message: "Sua pontuação é \(correctAnswerCount) de \(elementList.count)", preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "OK", style: .default, handler: scoreAlertDismissed(_:))
        alert.addAction(dismissAction)
        present(alert,animated: true,completion: nil)
    }
    
    func scoreAlertDismissed(_ action:UIAlertAction){
        mode = .flashCard
    }
    
    
    @IBAction func switchModes(_ sender: Any) {
        if modeSelector.selectedSegmentIndex == 0
        {
            mode = .flashCard
        } else {
            mode = .quiz
        }
    }
    
    @IBAction func showAnswer(_ sender: Any) {
        state = .answer
        answerIsCorrect = true
        updateUI()
    }
    
    @IBAction func next(_ sender: Any) {
        
        currentElementIndex
        += 1
        if currentElementIndex >= elementList.count {
            currentElementIndex = 0
            if mode == .quiz {
                state = .score
                updateUI()
                return
            }
        }
        state = .question
        updateUI()
    }
}

