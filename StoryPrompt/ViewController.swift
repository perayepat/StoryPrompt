//
//  ViewController.swift
//  StoryPrompt
//
//  Created by Pat on 2022/09/04.
//

import UIKit
import PhotosUI

class ViewController: UIViewController {
    
    @IBOutlet weak var nounTextField: UITextField!
    @IBOutlet weak var verbTextField: UITextField!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var numberSlider: UISlider!
    @IBOutlet weak var storyPromptImageView: UIImageView!
    @IBOutlet weak var adjectiveTextField: UITextField!
    let storyPrompt = StoryPromptEntry()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        numberSlider.value = 7.5
        storyPrompt.number = Int(numberSlider.value)
        storyPromptImageView.isUserInteractionEnabled = true
        //Create a gesture recognizer
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(changeImage))
        storyPromptImageView.addGestureRecognizer(gestureRecognizer)
    }
    
    @IBAction func changeNumber(_ sender: UISlider) {
        numberLabel.text = "Number: \(Int(sender.value))"
        storyPrompt.number = Int(sender.value)
    }
    @IBAction func changeStoryType(_ sender: UISegmentedControl) {
        // get current index by refrencing the selected segment index property on the segmented control
        //We're using this to create a genre enum
        if let genre = StoryPrompts.Genre(rawValue: sender.selectedSegmentIndex){
            storyPrompt.genre = genre
        } else{
            storyPrompt.genre = .scifi
        }
    }
    
    @IBAction func generateStoryPrompt(_ sender: UIButton) {
        updateStoryPrompt()
        
        if storyPrompt.isValid(){
            print(storyPrompt)
        }else{
            //event to show the user
            let alert = UIAlertController(
                title: "Invalid Story Prompt",
                message: "Please fill out all the fields",
                preferredStyle: .alert
            )
            let action = UIAlertAction(title: "OK", style: .default) { action in
                
            }
            alert.addAction(action)
            present(alert, animated: true)
        }
    }
    
    func updateStoryPrompt(){
        storyPrompt.noun = nounTextField.text ?? ""
        storyPrompt.adjective = adjectiveTextField.text ?? ""
        storyPrompt.verb = verbTextField.text ?? ""
    }
    
    @objc func changeImage(){
        //create picker config to only allow one section
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        //create picker view delegate and assign ourselves as the delegate
        let controller = PHPickerViewController(configuration: configuration)
        controller.delegate = self
        present(controller, animated: true)
    }
    
}

extension ViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        updateStoryPrompt()
        return true
    }
}

extension ViewController: PHPickerViewControllerDelegate{
    //fetch user selected image
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        if !results.isEmpty{
            let result = results.first!
            let itemProvider = result.itemProvider
            if itemProvider.canLoadObject(ofClass: UIImage.self){
                itemProvider.loadObject(ofClass: UIImage.self){[weak self] image, error in
                    guard let image = image as? UIImage else {
                        return
                    }
                    //cast image as ui image on the main thread
                    DispatchQueue.main.async {
                        self?.storyPromptImageView.image = image
                        picker.resignFirstResponder()
                    }
                }
            }
        }
    }
}
