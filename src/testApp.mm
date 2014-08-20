//==============================================================================
//
//  STAMPIES
//
//  testApp.mm
//
//  Author: Stephen Aldriedge, 2014
//
//==============================================================================

//---- CLASS HEADER ----
#include "testApp.h"

//---- STANDARD LIBS ----
#include <vector>
#include <functional>
#include <iterator>


//ofImage testApp::images[72];

//---------------------------- CONSTRUCTOR ------------------------------------
testApp::testApp()
    : tpm(20,10), mainMenu(*this,selection, verdana14, verdanaLarge), selection(*this,mainGame, GetImageFiles(), GetMaterialImageFiles()), mainGame(*this,selection),
      currentLevel(NULL), resetter(*this,mainMenu)
{
    // define and register the "known" patterns
    
    // FELT
    std::vector<ofVec2f> p0(3);
    p0[0] = ofVec2f(14,-64); p0[1] = ofVec2f(-33,32); p0[2] = ofVec2f(20,32);
    knownPatterns[0] = tpm.registerPattern(p0, 7);
    
    // PLASTIC
    std::vector<ofVec2f> p1(3);
    p1[0] = ofVec2f(-9,24); p1[1] = ofVec2f(55,-16); p1[2] = ofVec2f(-45,-9);
    knownPatterns[1] = tpm.registerPattern(p1, 7);
    
    // SILICONE
    std::vector<ofVec2f> p2(3);
    p2[0] = ofVec2f(-15,24); p2[1] = ofVec2f(39,35); p2[2] = ofVec2f(-24,-60);
    knownPatterns[2] = tpm.registerPattern(p2, 7);
    
    // WOOD
    std::vector<ofVec2f> p3(3);
    p3[0] = ofVec2f(54,18); p3[1] = ofVec2f(-54,3); p3[2] = ofVec2f(0,-20);
    knownPatterns[3] = tpm.registerPattern(p3, 7);
    
    knownPatternSize = 4;
}

//---------------------------- GETIMAGEFILES ------------------------------------
std::vector<std::vector<std::vector<ofFile> > > testApp::GetImageFiles() {
    
    std::vector<std::vector<std::vector<ofFile> > > imageFilenames;
    size_t imageTypeCount = 0;
    
    // this seems to be the only way to get the correct path to resources.
    NSString *path = [[NSBundle mainBundle] resourcePath];
    const char *cpath = [path fileSystemRepresentation];
    std::string dirPath(cpath);
    //std::ifstream vertFStream(cpath);
    
    ofDirectory dir(dirPath + "/data/stampImages");
    dir.listDir(); //populate the directory object
    
    
    for(int i = 0; i < dir.numFiles(); i++){
        size_t categoryCount = 0;
        
        if (!dir[i].isDirectory()) continue;
        std::cout << dir[i].path() << std::endl;
        
        ofDirectory imageTypeDir(dir.getPath(i));
        imageTypeDir.listDir();
        imageFilenames.push_back(std::vector<std::vector<ofFile> >());
        for (int j=0; j < imageTypeDir.numFiles(); j++) {
            if (!imageTypeDir[j].isDirectory()) continue;
            
            ofDirectory categoryDir(imageTypeDir.getPath(j));
            categoryDir.allowExt("png");
            categoryDir.listDir();
            imageFilenames[imageTypeCount].push_back(std::vector<ofFile>());
            for (int k=0; k < categoryDir.numFiles(); k++) {
                imageFilenames[imageTypeCount][categoryCount].push_back(ofFile(categoryDir.getPath(k)));
                std::cout << imageFilenames[imageTypeCount][categoryCount][k].path() << std::endl;
            }
            
            categoryCount++;
        }
        
        imageTypeCount++;
    }
    
    return imageFilenames;
}

//---------------------------- GETMATERIALIMAGEFILES ------------------------------------
std::vector<ofFile> testApp::GetMaterialImageFiles() {
    
    std::vector<ofFile> imageFilenames;
    
    // this seems to be the only way to get the correct path to resources.
    NSString *path = [[NSBundle mainBundle] resourcePath];
    const char *cpath = [path fileSystemRepresentation];
    std::string dirPath(cpath);
    
    ofDirectory dir(dirPath + "/data/materialImages");
    dir.allowExt("png");
    dir.listDir(); //populate the directory object
    
    for (int i=0; i < dir.numFiles(); i++) {
        imageFilenames.push_back(ofFile(dir.getPath(i)));
        std::cout << imageFilenames[i].path() << std::endl;
    }
    
    /*
    std::string matImageDir = dirPath + "/data/materialImages";
    
    StampImageFiles[0] = ofFile(matImageDir + "/Stampies_felt_01.png");
    StampDrawables[0] = &StampImageDrawables[0];
    StampImageFiles[1] = ofFile(matImageDir + "/Stampies_plastic_01.png");
    //StampImageDrawables[1].set(StampImageFiles[1]);
    StampDrawables[1] = &StampImageDrawables[1];
    StampImageFiles[2] = ofFile(matImageDir + "/Stampies_silicone_01.png");
    //StampImageDrawables[2].set(StampImageFiles[2]);
    StampDrawables[2] = &StampImageDrawables[2];
    StampImageFiles[3] = ofFile(matImageDir + "/Stampies_wood_01.png");
    //StampImageDrawables[3].set(StampImageFiles[3]);
    StampDrawables[3] = &StampImageDrawables[3];
     */
    
    return imageFilenames;
}

//---------------------------- STARTLEVEL ------------------------------------
void testApp::startLevel(Level& l, int mode) {
    currentLevel = &l;
    currentLevel->setup(mode);
}


//---------------------------- SETUP ------------------------------------
void testApp::setup(){
    
    ofSetOrientation(OF_ORIENTATION_90_RIGHT);
    ofSetBackgroundAuto(false); //disable automatic background redraw
    
    resetter.setup();
    
    counter = 0;
    debugmsg = "";
    
    ofBackground( 0 );
    //old OF default is 96 - but this results in fonts looking larger than in other programs.
	ofTrueTypeFont::setGlobalDpi(72);
    
	verdana14.loadFont("data/verdana.ttf", 22, true, true);
	verdana14.setLineHeight(18.0f);
	verdana14.setLetterSpacing(1.037);
    
    verdanaLarge.loadFont("data/verdana.ttf", 80, true, true);
	verdanaLarge.setLineHeight(18.0f);
	verdanaLarge.setLetterSpacing(1.037);
    
    ofEnableSmoothing();
    
    startLevel(mainMenu);
}

//---------------------------- UPDATE ------------------------------------
void testApp::update(){
    tpm.updateFrame();
    currentLevel->update();
}

//---------------------------- DRAW ------------------------------------
void testApp::draw(){
    currentLevel->draw();
}


void testApp::exit() {
}

void testApp::lostFocus(){
}

void testApp::gotFocus(){
}

void testApp::gotMemoryWarning(){
}

void testApp::deviceOrientationChanged(int newOrientation){
}




