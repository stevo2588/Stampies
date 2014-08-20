//==============================================================================
//
//  STAMPIES
//
//  MainScreen.mm
//
//  Author: Stephen Aldriedge, 2014
//
//==============================================================================

#include "MainScreen.h"

#include "testApp.h"

#include "ofMain.h"

void MainScreen::setup(int mode) {
    app.tpm.registerTouchPatternEvents(*this);
}

void MainScreen::update() {
    // check if start button was pressed
    
    // change to selection screen
    //startLevel(selectionScreen);
}

void MainScreen::draw() {
    ofBackground( 0 );  // set background color
    
    ofSetColor(255);
    titleFont.drawString("STAMPIES", 315, 170);
    
    startImages.draw();
    startLines.draw();
    startColors.draw();
}

void MainScreen::cleanup() {
    app.tpm.unregisterTouchPatternEvents(*this);
}

void MainScreen::tDown(ofVec2f & touch) {
    startImages.touchDown(touch);
    startLines.touchDown(touch);
    startColors.touchDown(touch);
}
void MainScreen::tMoved(ofVec2f & touch) {}
void MainScreen::tUp(ofVec2f & touch) {
    if(startImages.touchUp(touch)) {
        startLevel(selectionScreen, 0);
    }
    if(startLines.touchUp(touch)) {
        startLevel(selectionScreen, 1);
    }
    else if(startColors.touchUp(touch)) {
        startLevel(selectionScreen, -1);
    }
}