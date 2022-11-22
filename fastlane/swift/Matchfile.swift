// Matchfile.swift
// Copyright (c) 2021 FastlaneTools

// This class is automatically included in FastlaneRunner during build

// This autogenerated file will be overwritten or replaced during build time, or when you initialize `match`
//
//  ** NOTE **
//  This file is provided by fastlane and WILL be overwritten in future updates
//  If you want to add extra functionality to this project, create a new file in a
//  new group so that it won't be marked for upgrade
//

public class Matchfile: MatchfileProtocol {
    // If you want to enable `match`, run `fastlane match init`
    // After, this file will be replaced with a custom implementation that contains values you supplied
    // during the `init` process, and you won't see this message
    
    public var type: String {
        return "appstore" // or development, adhoc, enterprise
    }
    
    public var appIdentifier: [String] {
        return ["com.flexday.app"]
    }
    
    public var gitUrl: String {
        return "https://9folders-inchan:gkdlfn1!A@github.com/9folders-inchan/certificates.git"
    }
    
    public var username: String? {
        return "inchan@korea.com"
    }
}

// Generated with fastlane 2.180.1
