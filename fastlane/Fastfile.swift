// This file contains the fastlane.tools configuration
// You can find the documentation at https://docs.fastlane.tools
//
// For a list of all available actions, check out
//
//     https://docs.fastlane.tools/actions
//

import Foundation

class Fastfile: LaneFile {
    
    func betaLane(withOptions options:[String: String]?) {
        
        desc("Build - Upload - Testflight")
		// add actions here: https://docs.fastlane.tools/actions
        
        match(type: "appstore")
        
        incrementBuildNumber()

        buildIosApp(scheme: "flexday")
        
        uploadToTestflight(username: .userDefined(appleID))
	}
    
    func release(withOptions options:[String: String]?) {
        
        desc("Build - Upload - Testflight")
        // add actions here: https://docs.fastlane.tools/actions
        
        match(type: "appstore")

        buildIosApp(scheme: "flexday")

        //uploadToAppStore(skip_metadata: true, skip_screenshots: true, app: nil)
    }
    
    func versionLane(withOptions options:[String: String]?) {
        //incrementBuildNumber()
        incrementVersionNumber(bumpType: "patch")
    }
    
}
