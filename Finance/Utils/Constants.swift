//
//  Constants.swift
//  Finance
//
//  Created by Александр Меренков on 09.09.2022.
//

import Firebase

let DB_REF = Database.database().reference()
let REF_USERS = DB_REF.child("users")

let STORAGE_REF = Storage.storage().reference()
let REF_PROFILE_IMAGE = STORAGE_REF.child("profile_image")
