//==============================================================================
//
//  STAMPIES
//
//  Level.h
//
//  Author: Stephen Aldriedge, 2014
//
//==============================================================================

#ifndef Stampies_Level_h
#define Stampies_Level_h

class testApp;

#include "ofMain.h"

#include <iostream>
#include <vector>

class Level {
public:
    virtual void setup(int mode) =0;
    virtual void update() =0;
    virtual void draw() =0;
    virtual void cleanup() =0;
    
protected:
    Level(testApp& app);
    
    testApp& app;
    
    void startLevel(Level& l, int mode=0);
};

#endif
