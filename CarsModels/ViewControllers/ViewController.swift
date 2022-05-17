//
//  ViewController.swift
//  CarsModels
//
//  Created by Bohdan on 16.05.2022.
//

import UIKit
import SnapKit
import CoreData

class ViewController: UIViewController {
    
    var context: NSManagedObjectContext!
    
    //MARK: - UI
    let segmentedControl: UISegmentedControl = {
        let carsArray = ["Lambo", "Ferrari", "Merc", "Nissan", "BMW"]
        let segmentedControl = UISegmentedControl(items: carsArray)
        segmentedControl.addTarget(self, action: #selector(segmentedControllPressed), for: .valueChanged)
        return segmentedControl
    }()
    
    let carImageView: UIImageView = {
        let image = UIImage(systemName: "checkmark")
        let imageView = UIImageView(image: image)
        return imageView
    }()
    
    let myChoiceImageView: UIImageView = {
        let image = UIImage(systemName: "checkmark")
        let imageView = UIImageView(image: image)
        return imageView
    }()
    
    let startEngineButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Start engine", for: .normal)
        button.tintColor = .white
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(startEnginePressed), for: .touchUpInside)
        return button
    }()
    
    let rateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Rate", for: .normal)
        button.tintColor = .white
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(rateItPressed), for: .touchUpInside)
        return button
    }()
    
    let modelLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let lastTimeStartedLabel: UILabel = {
        let label = UILabel()
        label.text = "Last time started:"
        return label
    }()
    
    let numberOfTripsLabel: UILabel = {
       let label = UILabel()
        label.text = "Number of trips:"
        return label
    }()
    
    let ratingLabel: UILabel = {
       let label = UILabel()
        label.text = "Rating: X/10.0"
        return label
    }()
    
    //MARK: - ViewLifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Mark"
        view.backgroundColor = .white
        layout()
    }
    
    //MARK: - Methods
    @objc func segmentedControllPressed() {
        
    }
    
    @objc func startEnginePressed() {
        
    }
    
    @objc func rateItPressed() {
        
    }
    
    
    //MARK: - Layout
    func layout() {
        view.addSubview(modelLabel)
        view.addSubview(carImageView)
        view.addSubview(segmentedControl)
        view.addSubview(lastTimeStartedLabel)
        view.addSubview(numberOfTripsLabel)
        view.addSubview(ratingLabel)
        view.addSubview(myChoiceImageView)
        view.addSubview(startEngineButton)
        view.addSubview(rateButton)
        
        modelLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.centerX.equalToSuperview()
        }
        
        carImageView.snp.makeConstraints { make in
            make.top.equalTo(modelLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(200)
        }
        
        lastTimeStartedLabel.snp.makeConstraints { make in
            make.top.equalTo(carImageView.snp.bottom).offset(20)
            make.leading.equalTo(view.snp.leading).offset(20)
        }
        
        numberOfTripsLabel.snp.makeConstraints { make in
            make.top.equalTo(lastTimeStartedLabel.snp.bottom).offset(10)
            make.leading.equalTo(lastTimeStartedLabel)
        }
        
        ratingLabel.snp.makeConstraints { make in
            make.bottom.equalTo(lastTimeStartedLabel.snp.bottom)
            make.trailing.equalTo(view.snp.trailing).inset(20)
        }
        
        segmentedControl.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
            make.leading.equalTo(view.snp.leading).offset(20)
            make.trailing.equalTo(view.snp.trailing).inset(20)
        }
        
        myChoiceImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(segmentedControl.snp.bottom).offset(20)
            make.width.height.equalTo(100)
        }
        
        startEngineButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(20)
            make.leading.equalTo(view.snp.leading).offset(20)
            make.height.equalTo(30)
            make.width.equalTo(120)
        }
        
        rateButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(20)
            make.trailing.equalTo(view.snp.trailing).inset(20)
            make.height.equalTo(30)
            make.width.equalTo(120)
        }
        
    }
    
}

