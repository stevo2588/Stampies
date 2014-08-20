//==============================================================================
//
//  STAMPIES
//
//  testApp.h
//
//  Author: Stephen Aldriedge, 2014
//
//==============================================================================

#pragma once

#ifndef TESTAPP_H
#define TESTAPP_H

//---- PROJECT HEADERS ----
#include "TouchPatternManager.h"
#include "MainScreen.h"
#include "SelectionScreen.h"
#include "Canvas.h"
#include "AppResetter.h"

//---- 3RD PARTY HEADERS ----
#include "ofMain.h"
#include "ofxiOS.h"
#include "ofxiOSExtras.h"

//______________________________________________________________________________
class testApp : public ofxiOSApp {
	
public:
    testApp();
    
    // return a 3d vector populated with image files from the resource folder
    static std::vector<std::vector<std::vector<ofFile> > > GetImageFiles();
    static std::vector<ofFile> GetMaterialImageFiles();
    
    void setup();
    void update();
    void draw();
    void exit();
    void lostFocus();
    void gotFocus();
    void gotMemoryWarning();
    void deviceOrientationChanged(int newOrientation);
        
    void startLevel(Level& l, int mode=0);
    
    TouchPatternManager tpm;
    const Pattern* knownPatterns[4];
    size_t knownPatternSize;
    
    Level* currentLevel;
    
private:
    string debugmsg;
    ofTrueTypeFont verdana14;
    ofTrueTypeFont verdanaLarge;
        
    MainScreen mainMenu;
    SelectionScreen selection;
    Canvas mainGame;
    
    int counter;
    
    AppResetter resetter;
};



#endif // TESTAPP_H




