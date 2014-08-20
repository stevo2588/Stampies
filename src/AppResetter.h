//==============================================================================
//
//  STAMPIES
//
//  AppResetter.h
//
//  Author: Stephen Aldriedge, 2014
//
//==============================================================================

#ifndef Stampies_AppResetter_h
#define Stampies_AppResetter_h

//---- PROJECT HEADERS ----
#include "TouchPatternManager.h"
class Level;
class testApp;

//---- 3RD PARTY HEADERS ----
class ofVec2f;

//______________________________________________________________________________
class AppResetter : public TouchPatternListener {
public:
    AppResetter(testApp& app, Level& mainMenu);
    
    void setup();
    
    // Touch handlers
    void tDown(ofVec2f & touch);
    void tMoved(ofVec2f & touch) {}
    void tUp(ofVec2f & touch) {}
    
    testApp& app;
    Level& mainMenu;
};

#endif
