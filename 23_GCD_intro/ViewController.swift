//
//  ViewController.swift
//  23_GCD_intro
//
//  Created by Norbert Grover on 11/15/22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        printOnAsyncAfter { msg in
//            print(msg)
//        }
        
//        printRun { msg in
//            print(msg)
//        }
        
        printConcurrency { msg in
            print(msg)
        }
    }
    
    
    @IBAction func downloadImageBtnPressed(_ sender: Any) {
        downloadImage { image in
            self.imageView.image = image
        }
    }
    
    
    @IBAction func changeBackgroundColor(_ sender: Any) {
        imageView.backgroundColor = imageView.backgroundColor == UIColor.red ? UIColor.green : UIColor.red
    }
    


}

extension ViewController {
    
    func printConcurrency(completion:@escaping(_ msg:String) -> ()) {
        completion("*** start ***")
        let conQueue = DispatchQueue(label: "com.checkCon", attributes: .concurrent)
        conQueue.sync {
            completion("Line 1")
            sleep(5)
        }
        conQueue.async {
            completion("Line 2")
            sleep(5)
        }
        conQueue.async {
            completion("Line 3")
            sleep(5)
        }
    }
    
    func downloadImage(completion:@escaping(_ image:UIImage?) -> ()) {
        DispatchQueue.global(qos: .userInteractive).async {
            guard let url = URL(string: "https://a3.espncdn.com/combiner/i?img=%2Fphoto%2F2021%2F0427%2Fr846375_1296x729_16%2D9.jpg") else {
                completion(nil)
                fatalError("invalid url")
            }
            guard let imageData = try? Data(contentsOf: url) else {
                completion(nil)
                fatalError("No image data")
            }
            sleep(6)
            guard let image = UIImage(data: imageData) else {
                completion(nil)
                fatalError("No image")
            }
            DispatchQueue.main.async {
                completion(image)
            }
            
        }
    }
    
    func printOnAsyncAfter(completion:@escaping(_ msg:String) -> ()) {
        completion("** Start **")
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            completion("I'm running for 3 seconds")
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
            completion("I'm running for 3 more seconds. 6 seconds in all, asynchronously.")
        }
    }
    
    
    func printRun(completion:@escaping(_ msg:String) -> ()) {
        completion("** Start **")
        DispatchQueue.global(qos: .background).async {
            completion("Pre-run")
            sleep(2)
            completion("Run inside the Queue")
        }
        completion("Runs outside of the queue.")
    }
    
}

