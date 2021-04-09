//
//  GFError.swift
//  GHFollowers
//
//  Created by William Maguire on 4/5/21.
//

import Foundation

// MARK: - New Swift 5 Result way of creating a Error to conform to Error Protocol
enum GFError: String, Error {
    case invalidUsername = "This username created an invalid request. Please try again."
    case unableToComplete = "Unable to complete request. Please check your internet connection"
    case invalidResponse = "Invalid response from server. Please try again."
    case invalidData = "Data received from server was invalid. Please try again."
    case unableToAddFavorite = "There was an error adding this user as a favorite, please try again."
    case favoriteAlreadyExists = "This user already exists in favorites."
}

// MARK: - Old/Fundamental way of creating a raw value Enum for Errors
//enum ErrorMessage: String {
//    case invalidUsername = "This username created an invalid request. Please try again."
//    case unableToComplete = "Unable to complete request. Please check your internet connection"
//    case invalidResponse = "Invalid response from server. Please try again."
//    case invalidData = "Data received from server was invalid. Please try again."
//}
