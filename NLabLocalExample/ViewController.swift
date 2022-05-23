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
        getUsers().onData { user in
            print("--> sync data received")
            dump("--> \(user.page)")
        }.onError { error in
            print("--> sync error received")
            print("--> \(error)")
        }.start()
        
        Task {
            async let data1 = await getUsers().onError { error in
                print("--> async error received")
                print(error)
            }.startAsync()

            async let data2 = await getUsers().onError({ error in
                print("--> async error received")
                print(error)
            }).startAsync()

            let receivedData = await [data1, data2]
            print("-->", receivedData)
        }
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


