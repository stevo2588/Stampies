//==============================================================================
//
//  STAMPIES
//
//  TouchPattern.h
//
//  Author: Stephen Aldriedge, 2014
//
//==============================================================================

#ifndef Stampies_TouchPattern_h
#define Stampies_TouchPattern_h

#include "ofMain.h"

class Pattern;

class TouchPattern {
public:
    TouchPattern();
    
    const Pattern* registeredPattern;
    ofVec2f position;
    float angle;
    std::vector<ofVec2f*> touches;
    
    //int getCount() { return touches.size(); }
    void updateTransform();
};

#endif

