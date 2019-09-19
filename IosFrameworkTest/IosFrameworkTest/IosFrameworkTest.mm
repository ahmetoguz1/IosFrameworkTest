//
//  dicomUtil.mm
//  gdcmIosTest
//
//  Created by erkut on 16.09.2019.
//  Copyright © 2019 erkut. All rights reserved.
//
#import "IosFrameworkTest.h"
#include "../gdcmHeaders/gdcmCompositeNetworkFunctions.h"
#include "../gdcmHeaders/gdcmReader.h"
/*#include "../Headers/gdcmGlobal.h"
 #include "../Headers/gdcmDicts.h"
 #include "../Headers/gdcmDict.h"
 #include "../Headers/gdcmAttribute.h"
 #include "../Headers/gdcmStringFilter.h"*/

@implementation IosFrameworkTest


char *hostname = "192.168.1.124";
int port = 1011;
std::string callingaetitle = "SERVER";
std::string callaetitle = "IncigulPc"; // calledtitle

+(Boolean)store:(NSString *)fileLocation{
    //filepath = fileLocation;
    NSString *fileFullPath = [[NSBundle mainBundle] pathForResource:fileLocation ofType:@"dcm"];
    gdcm::Directory::FilenamesType filenames,thefiles;
    const bool theRecursive = 0;
    filenames.push_back([fileFullPath UTF8String]);
    for( gdcm::Directory::FilenamesType::const_iterator file = filenames.begin();
        file != filenames.end(); ++file )
    {
        if( gdcm::System::FileIsDirectory(file->c_str()) )
        {
            gdcm::Directory::FilenamesType files;
            gdcm::Directory dir;
            dir.Load(*file, theRecursive);
            files = dir.GetFilenames();
            thefiles.insert(thefiles.end(), files.begin(), files.end());
        }
        else
            thefiles.push_back(*file);
    }
    bool didItWork =
    gdcm::CompositeNetworkFunctions::CStore(hostname, (uint16_t)port, thefiles,
                                            callingaetitle.c_str(), callaetitle.c_str());
    
    if(didItWork)
        return true;
    else
        return false;
    return false;
}


@end

