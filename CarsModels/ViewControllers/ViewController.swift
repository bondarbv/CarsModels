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
    var car: Car!
    
    lazy var dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .short
        df.timeStyle = .none
        return df
    }()
    
    //MARK: - UI
    let segmentedControl: UISegmentedControl = {
        let carsArray = ["Lambo", "Ferrari", "Merc", "Nissan", "BMW"]
        let whiteTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        let blackTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        UISegmentedControl.appearance().setTitleTextAttributes(whiteTitleTextAttributes, for: .normal)
        UISegmentedControl.appearance().setTitleTextAttributes(blackTitleTextAttributes, for: .selected)
        let segmentedControl = UISegmentedControl(items: carsArray)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentedControllPressed), for: .valueChanged)
        return segmentedControl
    }()
    
    let carImageView = UIImageView()
    
    let myChoiceImageView = UIImageView()
    
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
    
    let modelLabel = UILabel()
    
    let lastTimeStartedLabel = UILabel()
    
    let numberOfTripsLabel = UILabel()
    
    let ratingLabel = UILabel()
    
    //MARK: - ViewLifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Mark"
        view.backgroundColor = .white
        layout()
        getDataFromFile()
        updateSegmentedControll()
    }
    
    //MARK: - Methods
    @objc func segmentedControllPressed() {
        updateSegmentedControll()
    }
    
    @objc func startEnginePressed() {
        car.timesDriven += 1
        car.lastStarted = Date()

        do {
            try context.save()
            insetDataFrom(selectedCar: car)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    @objc func rateItPressed() {
        let alertController = UIAlertController(title: "Rate it", message: "Rate this car please", preferredStyle: .alert)
        
        let rateAction = UIAlertAction(title: "Rate", style: .default) { action in
            if let text = alertController.textFields?.first?.text {
                self.update(rating: (text as NSString).doubleValue)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addTextField { textField in
            textField.keyboardType = .numberPad
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(rateAction)
        
        present(alertController, animated: true)
    }
    
    private func updateSegmentedControll() {
        let fetchRequest: NSFetchRequest<Car> = Car.fetchRequest()
    guard let mark = segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex) else { return }
        fetchRequest.predicate = NSPredicate(format: "mark == %@", mark)
        do {
            let results = try context.fetch(fetchRequest)
            car = results.first
            insetDataFrom(selectedCar: car)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    private func update(rating: Double) {
        car.rating = rating
        
        do {
            try context.save()
            insetDataFrom(selectedCar: car)
        } catch let error as NSError {
            let alertController = UIAlertController(title: "Wrong value", message: "Wrong input", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(ok)
            present(alertController, animated: true)
            print(error.localizedDescription)
        }
    }
    
    private func insetDataFrom(selectedCar car: Car) {
        carImageView.image = UIImage(data: car.imageData!)
        navigationItem.title = car.mark
        modelLabel.text = car.model
        lastTimeStartedLabel.text = "Last time started: \(dateFormatter.string(from: car.lastStarted!))"
        numberOfTripsLabel.text = "Number of trips: \(car.timesDriven)"
        ratingLabel.text = "Rating: \(car.rating) / 10"
        myChoiceImageView.isHidden = !(car.myChoice)
        segmentedControl.backgroundColor = car.tintColor as? UIColor
    }
    
    private func getDataFromFile() {
        
        let fetchRequest: NSFetchRequest<Car> = Car.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "mark != nil")
        
        var records = 0
        
        do {
            records = try context.count(for: fetchRequest)
            print("Is Data there already?")
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        guard records == 0 else { return }
        
        guard let pathToFile = Bundle.main.path(forResource: "data", ofType: "plist"),
              let dataArray = NSArray(contentsOfFile: pathToFile) else { return }
        for dictionary in dataArray {
            guard let entity = NSEntityDescription.entity(forEntityName: "Car", in: context) else { return }
            let car = NSManagedObject(entity: entity, insertInto: context) as! Car
            
            let carDictionary = dictionary as! [String: AnyObject]
            car.mark = carDictionary["mark"] as? String
            car.model = carDictionary["model"] as? String
            car.rating = carDictionary["rating"] as! Double
            car.lastStarted = carDictionary["lastStarted"] as? Date
            car.timesDriven = carDictionary["timesDriven"] as! Int16
            car.myChoice = carDictionary["myChoice"] as! Bool
            
            guard let imageName = carDictionary["imageName"] as? String else { return }
            guard let image = UIImage(named: imageName) else { return }
            let imageData = image.pngData()
            car.imageData = imageData
            
            if let colorDictionary = carDictionary["tintColor"] as? [String: Float] {
                car.tintColor = getColor(colorDictionary: colorDictionary)
            }
        }
    }
    
    private func getColor(colorDictionary: [String: Float]) -> UIColor {
        guard let red = colorDictionary["red"],
              let green = colorDictionary["green"],
              let blue = colorDictionary["blue"] else { return UIColor() }
        return UIColor(red: CGFloat(red / 255), green: CGFloat(green / 255), blue: CGFloat(blue / 255), alpha: 1.0)
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
            make.leading.equalTo(view.snp.leading).offset(20)
            make.trailing.equalTo(view.snp.trailing).inset(20)
            make.width.equalTo(336)
            make.height.equalTo(256)
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
            make.top.equalTo(numberOfTripsLabel.snp.bottom).offset(30)
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

