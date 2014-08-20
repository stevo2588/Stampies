//==============================================================================
//
//  STAMPIES
//
//  Level.mm
//
//  Author: Stephen Aldriedge, 2014
//
//==============================================================================

#include "Level.h"

#include "testApp.h"

Level::Level(testApp& app) : app(app) {}

void Level::startLevel(Level& l, int mode) {
    cleanup();
    app.startLevel(l,mode);
}
