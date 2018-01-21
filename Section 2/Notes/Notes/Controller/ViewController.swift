//
//  ViewController.swift
//  Notes
//
//  Created by pranav on 21/01/18.
//  Copyright © 2018 RB. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var notes = [Note]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        getNotes()
    }

    func getNotes() {
        NotesService.getNotes { (notes) in
            self.notes = notes
            self.tableView.reloadData()
        }
    }
    
    @IBAction func onComposeTapped() {
        AlertService.composeNote(in: self) { (note) in
            CKService.shared.save(record: note.noteRecord())
            self.insert(note: note)
        }
    }
    
    func insert(note: Note) {
        notes.insert(note, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let note = notes[indexPath.row]
        cell.textLabel?.text = note.title
        return cell
    }
}

