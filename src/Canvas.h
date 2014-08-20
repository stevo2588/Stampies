//==============================================================================
//
//  STAMPIES
//
//  Canvas.h
//
//  Author: Stephen Aldriedge, 2014
//
//==============================================================================

#ifndef Stampies_Canvas_h
#define Stampies_Canvas_h

#include "Level.h"
#include "TouchPatternManager.h"
#include "Utility.h"
class SelectionScreen;

class Canvas : public Level, public TouchPatternListener {
public:
    Canvas(testApp& app, SelectionScreen &selectionScreen);
    
    void setup(int mode);
    void update();
    void draw();
    void cleanup();

    // Touch handlers
    void unassignedDown(ofVec2f & touch) {}
    void unassignedMoved(ofVec2f & touch) {}
    void unassignedUp(ofVec2f & touch) {}
    
    void patternDown(TouchPattern & pat);
    void patternMoved(TouchPattern & pat);
    void patternUp(TouchPattern & pat) {}
    
    void addDrawable(const Pattern* p, Utility::CenterDrawable* d) {
        if (patternDrawMap.count(p)) {
            delete patternDrawMap[p];
        }
        patternDrawMap[p] = d;
    }
    std::map<const Pattern*, Utility::CenterDrawable*> patternDrawMap;
    
private:
    SelectionScreen& selectionScreen;
};

#endif
