//
//  Constants.swift
//  Finance
//
//  Created by Александр Меренков on 09.09.2022.
//

import Firebase

let DB_REF = Database.database().reference()
let REF_USERS = DB_REF.child("users")
let REF_USER_TRANSACTIONS = DB_REF.child("user_transactions")

let STORAGE_REF = Storage.storage().reference()
let REF_PROFILE_IMAGE = STORAGE_REF.child("profile_image")
