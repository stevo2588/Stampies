//==============================================================================
//
//  STAMPIES
//
//  Canvas.mm
//
//  Author: Stephen Aldriedge, 2014
//
//==============================================================================

#include "Canvas.h"

#include "testApp.h"

#include "ofMain.h"

Canvas::Canvas(testApp& app, SelectionScreen &selectionScreen) : Level(app), selectionScreen(selectionScreen)
{}

void Canvas::setup(int mode) {
    app.tpm.registerTouchPatternEvents(*this);
    
    ofBackground( 255 );  // set background color
    
    typedef std::map<const Pattern*, Utility::CenterDrawable*>::iterator it_type;
    for(it_type iterator = patternDrawMap.begin(); iterator != patternDrawMap.end(); iterator++) {
        // iterator->first = key
        // iterator->second = value
        std::cout << iterator->first << std::endl;
        std::cout << (void*)iterator->second << std::endl;
    }
}

void Canvas::update() {

}

void Canvas::draw() {

}

void Canvas::cleanup() {
    app.tpm.unregisterTouchPatternEvents(*this);
    
    typedef std::map<const Pattern*, Utility::CenterDrawable*>::iterator it_type;
    for(it_type iterator = patternDrawMap.begin(); iterator != patternDrawMap.end(); iterator++) {
        // iterator->second = value
        delete iterator->second;
    }
    patternDrawMap.clear();
}

void Canvas::patternDown(TouchPattern & pat) {
    ofPushMatrix();
    
    ofTranslate(pat.position);
    ofRotate((pat.angle-PI) * (180/PI), 0, 0, 1);
    
    patternDrawMap[pat.registeredPattern]->draw();
    
    ofPopMatrix();
}

void Canvas::patternMoved(TouchPattern & pat) {
    ofPushMatrix();
    
    ofTranslate(pat.position);
    ofRotate((pat.angle-PI) * (180/PI), 0, 0, 1);
    
    std::cout << "registeredPattern: " << pat.registeredPattern << std::endl;
    patternDrawMap[pat.registeredPattern]->draw();
    
    ofPopMatrix();
}



