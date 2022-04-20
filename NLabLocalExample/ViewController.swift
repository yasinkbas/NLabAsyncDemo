//
//  ViewController.swift
//  NLabLocalExample
//
//  Created by Yasin Akbas on 20.04.2022.
//

import UIKit
import NLab

let client = NLClient(baseURL: URL(string: "https://reqres.in")!)

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        getUsers().onData { user in
            dump("--> \(user)")
        }.onError { error in
            print(error)
        }.start()
    }

    func getUsers() -> NLTaskDirector<User, Empty> {
        NLTaskPoint<User, Empty>(client: client)
            .path("/api/users?page=2")
            .method(.get)
            .build().and.direct()
    }

}


struct User: Decodable {
    let page: Int
}


