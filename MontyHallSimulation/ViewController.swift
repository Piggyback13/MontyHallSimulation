//
//  ViewController.swift
//  MontyHallSimulation
//
//  Created by piggyback13 on 16.12.2022.
//

import UIKit

final class ViewController: UIViewController {

    @IBOutlet weak var numberOfGames: UITextField!
    @IBOutlet weak var switchSolution: UISwitch!
    @IBOutlet weak var winGamesLabel: UILabel!
    @IBOutlet weak var lossGamesLabel: UILabel!
    @IBOutlet weak var gamesPlayedLabel: UILabel!
    
    let group = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func playButtonTapped(_ sender: UIButton) {
        if let numberOfGames = Int(numberOfGames.text ?? "") {
        
            self.simulateMontyHall(numberOfGames: numberOfGames, option: self.switchSolution.isOn ? .Switch : .Stay)
            
            group.notify(queue: .main) {
                print("All iterations completed")
            }
        }
    }
    
    enum Option : Int {
        case Stay = 0
        case Switch
    }
    
    private func simulateMontyHall(numberOfGames: Int, option: Option) {
        
        var wins = 0
        var losses = 0
        
        for _ in 0..<numberOfGames {
            
            group.enter()
            
            DispatchQueue.global(qos: .userInteractive).async {
                
                // Создаем три пустые двери
                var doors : [Int] = [0, 0, 0]
                
                // Рандомно выбираем дверь за которой машина
                let car = Int.random(in: 0...2)
                doors[car] = 1
                
                // Игрок выбирает случайную дверь в качестве первоначального выбора
                var choice = Int.random(in: 0...2)

                // Ведущий открывает дверь за которой нет машины и эта дверь не выбрана игроком
                var opened = -1
                for doorIndex in 0..<doors.count {
                    // Если индекс двери равен выбранному игроком индексу двери, то запуск след итерац
                    if doorIndex == choice {
                        continue
                    }
                    
                    // Выбираем дверь которую открывает ведущий, за которой нет машина и которая не выбрана игроком
                    if doors[doorIndex] == 0 {
                        opened = doorIndex
                    }
                }
                
                // Если нужно было поменять дверь, выберите дверь, которая не является исходной и не открыта ведущим
                let initialChoice = choice
                if option == .Switch {
                    for doorIndex in 0..<doors.count {
                        if doorIndex != initialChoice && doorIndex != opened {
                            choice = doorIndex
                        }
                    }
                }
                
                // Ведём счетчик вин лос
                doors[choice] == 1 ? (wins += 1) : (losses += 1)
            }
            
            group.leave()
        }
        
        self.winGamesLabel.text = "Wins: \(wins)"
        self.lossGamesLabel.text = "Losses: \(losses)"
        self.gamesPlayedLabel.text = "Games played: \(numberOfGames)"
    }
}

