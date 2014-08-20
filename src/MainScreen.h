//==============================================================================
//
//  STAMPIES
//
//  MainScreen.h
//
//  Author: Stephen Aldriedge, 2014
//
//==============================================================================

#ifndef Stampies_MainScreen_h
#define Stampies_MainScreen_h

#include "Level.h"
#include "SelectionScreen.h"
#include "TouchPatternManager.h"
#include "Utility.h"


class MainScreen : public Level, public TouchPatternListener {
public:
    MainScreen(testApp& app, SelectionScreen &selectionScreen, ofTrueTypeFont& f, ofTrueTypeFont& titleFont)
    : Level(app), selectionScreen(selectionScreen), font(f), titleFont(titleFont),
    startImages(ofRectangle(425, 250, 200, 100), ofColor(255,0,0), ofColor(0,255,0), "Color Images", font),
    startLines(ofRectangle(425, 400, 200, 100), ofColor(255,0,0), ofColor(0,255,0), "Line Images", font),
    startColors(ofRectangle(425, 550, 200, 100), ofColor(255,0,0), ofColor(0,255,0), "Colors", font) {}
    
    void setup(int mode);
    void update();
    void draw();
    void cleanup();
    
    void tDown(ofVec2f & touch);
    void tMoved(ofVec2f & touch);
    void tUp(ofVec2f & touch);
    
private:
    SelectionScreen& selectionScreen;
    ofTrueTypeFont &font, &titleFont;
    
    Utility::SimpleButton startImages, startLines, startColors;
};

#endif

