//==============================================================================
//
//  STAMPIES
//
//  AppResetter.mm
//
//  Author: Stephen Aldriedge, 2014
//
//==============================================================================

//---- CLASS HEADER ----
#include "AppResetter.h"

//---- PROJECT HEADERS ----
#include "testApp.h"

//---------------------------- CONSTRUCTOR ------------------------------------
AppResetter::AppResetter(testApp& app, Level& mainMenu) : app(app), mainMenu(mainMenu) {
    
}

//---------------------------- SETUP ------------------------------------
void AppResetter::setup() {
    app.tpm.registerTouchPatternEvents(*this);
}

//---------------------------- TDOWN ------------------------------------
void AppResetter::tDown(ofVec2f & touch) {
    const std::vector<ofVec2f*>& u = app.tpm.getUnassigned();
    
    if( u.size() < 4 ) return;
    
    if( touch.x < 20 && touch.y < 20 ) {
        app.currentLevel->cleanup();
        app.startLevel(mainMenu);
    }
}