//
//  StoryPromptTableViewController.swift
//  StoryPrompt
//
//  Created by Pat on 2022/09/04.
//

import UIKit

class StoryPromptTableViewController: UITableViewController {
    
    var storyPrompts = [StoryPromptEntry]()

    override func viewDidLoad() {
        super.viewDidLoad()

        let storyPrompts1 = StoryPromptEntry()
        let storyPrompts2 = StoryPromptEntry()
        let storyPrompts3 = StoryPromptEntry()
        
        storyPrompts1.noun = "Toast"
        storyPrompts1.adjective = "Smelly"
        storyPrompts1.verb = "attacks"
        storyPrompts1.number = 5
        
        storyPrompts2.noun = "Toast"
        storyPrompts2.adjective = "Smelly"
        storyPrompts2.verb = "attacks"
        storyPrompts2.number = 5
        
        storyPrompts3.noun = "Toast"
        storyPrompts3.adjective = "Smelly"
        storyPrompts3.verb = "attacks"
        storyPrompts3.number = 5
        
        storyPrompts = [storyPrompts1, storyPrompts2, storyPrompts3]
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        storyPrompts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoryPromptCell", for: indexPath)
        cell.textLabel?.text = "Prompt \(indexPath.row + 1)"
        cell.imageView?.image = storyPrompts[indexPath.row].image
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //MARK: - Using the sender to send the selected item at the row
        let storyPrompt = storyPrompts[indexPath.row]
        performSegue(withIdentifier: "ShowStoryPrompt", sender: storyPrompt)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //MARK: - Casting the sender and assigning it to the new view 
        if segue.identifier == "ShowStoryPrompt"{
            guard let storyPromptViewController = segue.destination as? StoryPromptViewController,
                  let storyPrompt = sender as? StoryPromptEntry else {
                return
            }
            storyPromptViewController.storyPrompt = storyPrompt
        }
    }
}
