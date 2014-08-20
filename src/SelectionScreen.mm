//==============================================================================
//
//  STAMPIES
//
//  SelectionScreen.mm
//
//  Author: Stephen Aldriedge, 2014
//
//==============================================================================

#include "SelectionScreen.h"

#include "testApp.h"

#include "ofMain.h"
#include "ofUtils.h"


SelectionScreen::SelectionScreen(testApp& app, Canvas &canvas, std::vector<std::vector<std::vector<ofFile> > > images, std::vector<ofFile> matImages)
: Level(app), canvas(canvas), imageFiles(images), matImages(matImages), state(IMAGES1), waitToChange(-1), colorAssignCount(0), delayToRegister(30), registrationFrames(6)
{
    coloredCircleDrawables.reserve(6);
    colors.reserve(6);
    coloredCircleDrawables.push_back(Utility::ColoredCircleDrawable(ofColor(255,0,0)));
    colors.push_back(&coloredCircleDrawables.back());
    coloredCircleDrawables.push_back(Utility::ColoredCircleDrawable(ofColor(0,255,0)));
    colors.push_back(&coloredCircleDrawables.back());
    coloredCircleDrawables.push_back(Utility::ColoredCircleDrawable(ofColor(0,0,255)));
    colors.push_back(&coloredCircleDrawables.back());
    coloredCircleDrawables.push_back(Utility::ColoredCircleDrawable(ofColor(255,255,0)));
    colors.push_back(&coloredCircleDrawables.back());
    coloredCircleDrawables.push_back(Utility::ColoredCircleDrawable(ofColor(180,0,150)));
    colors.push_back(&coloredCircleDrawables.back());
    coloredCircleDrawables.push_back(Utility::ColoredCircleDrawable(ofColor(255,170,0)));
    colors.push_back(&coloredCircleDrawables.back());
    
    sidebar.isSidebar = true;
}

std::vector<ofColor> SelectionScreen::getBGForImages() {
    std::vector<ofColor> vec;
    size_t size = 6;
    vec.reserve(size);
    for( int i=0; i<size; i++ ) vec.push_back(ofColor(255));
    return vec;
}
std::vector<ofColor> SelectionScreen::getBGForSidebar() {
    std::vector<ofColor> vec;
    size_t size = 4;
    vec.reserve(size);
    for( int i=0; i<size; i++ ) vec.push_back(ofColor(170));
    return vec;
}
std::vector<ofColor> SelectionScreen::getBGForColors() {
    std::vector<ofColor> vec;
    size_t size = 6;
    vec.reserve(size);
    vec.push_back(ofColor(255,0,0));
    vec.push_back(ofColor(0,255,0));
    vec.push_back(ofColor(0,0,255));
    vec.push_back(ofColor(255,255,0));
    vec.push_back(ofColor(180,0,150));
    vec.push_back(ofColor(255,170,0));
    return vec;
}

void SelectionScreen::setNumImages(size_t n) {
    size_t size = gridImageDrawables.size();
    if (size == n) return;
    
    if (size > n) {
        gridImageDrawables.resize(n);
        gridDrawables.resize(n);
    }
    else {
        for( int i=size; i<n; i++ ) {
            gridImageDrawables.push_back(Utility::ImageDrawable());
        }
        for( int i=0; i<n; i++ ) {
            gridDrawables.push_back( &gridImageDrawables[i] );
        }
    }
}

void SelectionScreen::changeImageCategory(unsigned cat) {
    for (int i=0; i<imageFiles[userStudyMode][cat].size(); i++) {
        gridImageDrawables[i].set(imageFiles[userStudyMode][cat][i]);
    }
}


void SelectionScreen::setup(int mode) {
    OrderedStampDrawables.clear();
    
    userStudyMode = mode;
    
    app.tpm.registerTouchPatternEvents(*this);
    
    //app.tpm.unregisterAllPatterns();
    
    ofEnableAlphaBlending();
    
    //--- allocate memory for material images --------
    size_t imageNum = matImages.size();
    matImageDrawables.resize(imageNum);
    matDrawables.resize(imageNum);
    for (int i=0; i<matImages.size(); i++) {
        matImageDrawables[i].set(matImages[i]);
        matDrawables[i] = &matImageDrawables[i];
    }
    
    // for color study
    if (mode == -1) {
        state = COLORS1;
        
        grid.isColors = true;
        
        colorMatDrawables = colors;
        
        grid.SetGridSize(3, 2, 1024, 768, ofVec2f(0,0));
        grid.SetGridContent(getBGForColors(), colors, colorMatDrawables, 1.0f);
    }
    
    // for image studies
    else {
        state = IMAGES1;
        
        grid.isColors = false;
        
        //--- allocate memory for images --------
        // here we assume all categories will be the same size
        size_t imagesPerCategory = imageFiles[mode][0].size();
        setNumImages(imagesPerCategory);
        
        
        grid.SetGridSize(imagesPerCategory/2, 2, 824, 768, ofVec2f(200,0));
        changeImageCategory(0);
        grid.SetGridContent(getBGForImages(), gridDrawables, gridDrawables, 1.0f);
        
        sidebar.SetGridSize(1, 4, 200, 768, ofVec2f(0,0));
        sidebar.SetGridContent(getBGForSidebar(), sidebarDrawables, OrderedStampDrawables, 0.4f);
    }
}

void SelectionScreen::update() {
    
    /*
    const std::vector<ofVec2f*>& u = app.tpm.getUnassigned();
    
    for( auto& d: patternCheckDelay ) {
        d--;
        if (d <= 0 && u.size() >= 3) {
            // when the value reaches 0 it will always be the first element of the container
            patternCheckDelay.erase(patternCheckDelay.begin());
            
            std::cout << "New pattern detected; Registering..." << std::endl;
            
            int touchCount = u.size();
            
            int xTotal=0, yTotal=0;
            for( auto& curTouch: u ) {
                xTotal += curTouch->x;
                yTotal += curTouch->y;
            }
            
            ofVec2f centralPt(xTotal/touchCount, yTotal/touchCount);
            
            //if (registering()) return;
            
            std::vector<ofVec2f> newpts(3);
            for (int i=0; i<3; i++) {
                int newX = u[i]->x - centralPt.x;
                int newY = u[i]->y - centralPt.y;
                newpts[i] = ofVec2f(newX, newY);
            }
            
            std::cout << "Central pt: " << centralPt << std::endl;
            
            int gridCell = grid.touchGrid(centralPt);
            if (gridCell == -1) return;
            Utility::CenterDrawable* d = grid.getCellDrawable(gridCell);
            
            
            if (state == COLORS1) {
                colorAssignCount++;
            }
            
            // register the pattern and add the pattern and drawable to the map
            const Pattern* pat = app.tpm.registerPattern(newpts, 4);
            canvas.addDrawable(pat, d->clone());
            std::cout << "Pattern successfully registered." << std::endl;
            
            
            switch (state) {
                case COLORS1:
                    if (colorAssignCount >= 4) waitToChange = 60;
                    break;
                    
                default:
                    // turn off touch recognition temporarily
                    app.tpm.unregisterTouchPatternEvents(*this);
                    
                    sidebarDrawables.push_back(canvas.patternDrawMap[pat]);
                    sidebar.SetGridContent(getBGForSidebar(), sidebarDrawables, 0.4f);
                    waitToChange = 60;
                    break;
            }
        }
    }
     */
    
    //------------------------------
    if (waitToChange == -1) return;
    
    if( waitToChange > 0 ) {
        waitToChange--;
        return;
    }
    waitToChange = -1;
    
    // turn touch recognition back on
    app.tpm.registerTouchPatternEvents(*this);
    
    switch (state) {
        //case CLRIMG4:
        //case LINIMG4:
        case IMAGES4:
        case COLORS1:
            startLevel((Level&)canvas);
            break;
        default:
            state = (SelectionState)((int)state+1);
            grid.deselectAll();
            changeImageCategory(state);
            break;
    }
}

void SelectionScreen::draw() {
    
    // set background color
    ofBackground( 170 );
    
    ofPushMatrix();
    grid.draw();
    ofPopMatrix();
    
    if (userStudyMode != -1) {
        ofPushMatrix();
        sidebar.draw();
        ofPopMatrix();
    }
}

void SelectionScreen::cleanup() {
    app.tpm.unregisterTouchPatternEvents(*this);
    ofDisableAlphaBlending();
    
    state = IMAGES1;
    colorAssignCount = 0;
}


void SelectionScreen::unassignedDown(ofVec2f & touch) {
    /*const std::vector<ofVec2f*>& u = app.tpm.getUnassigned();
    
    if (u.size() >= 3) {
        patternCheckDelay.push_back(delayToRegister);
    }*/
}

void SelectionScreen::patternDown(TouchPattern & pat) {
    
    // if this pattern has already been assigned, return
    if(canvas.patternDrawMap.count(pat.registeredPattern)) return;
    
    const Pattern* known = NULL;
    size_t theIndex;
    // determine if this pattern is "known"
    for (int i=0; i<app.knownPatternSize; i++) {
        if(pat.registeredPattern == app.knownPatterns[i]) {
            known = app.knownPatterns[i];
            theIndex = i;
            break;
        }
    }
    // if pattern is not "known", return
    if (!known) return;
    
    int gridCell = grid.touchGrid(pat.position);
    if (gridCell == -1) return;
    Utility::CenterDrawable* d = grid.getCellDrawable(gridCell);
    
    
    if (state == COLORS1) {
        colorAssignCount++;
    }
    
    // add the pattern and drawable to the map
    canvas.addDrawable(known, d->clone());
    std::cout << "Pattern successfully registered." << std::endl;
    
    switch (state) {
        case COLORS1:
            if (colorAssignCount >= 4) waitToChange = 60;
            
            colorMatDrawables[gridCell] = matDrawables[theIndex];
            grid.SetGridContent(getBGForColors(), colors, colorMatDrawables, 1.0f);
            break;
            
        default:
            // turn off touch recognition temporarily
            app.tpm.unregisterTouchPatternEvents(*this);
            
            sidebarDrawables.push_back(canvas.patternDrawMap[known]);
            OrderedStampDrawables.push_back(matDrawables[theIndex]);
            sidebar.SetGridContent(getBGForSidebar(), sidebarDrawables, OrderedStampDrawables, 0.4f);
            waitToChange = 60;
            break;
    }
}

bool SelectionScreen::registering() {
    
}


//-------------------------- ANIMCELL DEFINITIONS -----------------------------------
void SelectionScreen::AnimCell::draw() {
    
    //---- draw cell background ----
    ofSetColor( bg );
    
    ofPushMatrix();
    ofTranslate(-gridBox.width/2, -gridBox.height/2);
    ofRect( gridBox );
    ofPopMatrix();
    
    //---- draw cell content ----
    ofPushMatrix();
    ofTranslate(20, 0);
    ofScale(scale, scale);
    content->draw();
    ofPopMatrix();
    
    if (isSidebar) {
        ofPushMatrix();
        ofTranslate(150, 100);
        ofScale(1.1, 1.1);
        secondaryContent->draw();
        ofPopMatrix();
    }
    
    if (isColors) {
        ofPushMatrix();
        ofTranslate(370, 150);
        ofScale(1.8, 1.8);
        secondaryContent->draw();
        ofPopMatrix();
    }
    
    //---- if cell has been selected, wash it out ----
    if(selected) {
        ofSetColor(255, 255, 255, 200);
        ofPushMatrix();
        ofTranslate(-gridBox.width/2, -gridBox.height/2);
        ofRect( gridBox );
        ofPopMatrix();
    }
    
    
    
    //-------- IF ANIMATION IN PROGRESS -------
    if(!curFrame) return;
    
    // do animation
    //ofEnableAlphaBlending();
    ofSetColor(255, 255, 255, 100+(155*((float)curFrame/(float)frames)));
    
    ofPushMatrix();
    ofTranslate(-gridBox.width/2, -gridBox.height/2);
    ofRect( gridBox );
    ofPopMatrix();
    
    //ofDisableAlphaBlending();
    
    curFrame--;
    
    //---- once animation finishes, set cell as selected ----
    if (!curFrame) selected = true;
}

//-------------------------- GRID DEFINITIONS ---------------------------------------
SelectionScreen::Grid::Grid()
: gridWidth(3), gridHeight(2), totalCells(6), cellWidth(1024/3), cellHeight(768/2),
cellHalfWidth(cellWidth/2), cellHalfHeight(cellHeight/2), isSidebar(false), isColors(false)
{}

void SelectionScreen::Grid::SetGridSize(unsigned w, unsigned h, unsigned gridWidthPix, unsigned gridHeightPix, ofVec2f pos)
{
    gridPosition = pos;
    gridWidth = w;
    gridHeight = h;
    totalCells = w*h;
    cellWidth = gridWidthPix/w;
    cellHeight = gridHeightPix/h;
    cellHalfWidth = cellWidth/2;
    cellHalfHeight = cellHeight/2;
    
    cellMids.clear();
    for (int i=0; i<gridHeight; i++) {
        for (int j=0; j<gridWidth; j++) {
            cellMids.push_back(ofVec2f(j*cellWidth + cellWidth/2, i*cellHeight + cellHeight/2));
        }
    }
}

void SelectionScreen::Grid::SetGridContent(std::vector<ofColor> bg, std::vector<Utility::CenterDrawable*>& d, std::vector<Utility::CenterDrawable*>& d2, float scale) {
    cellAnim.clear();
    for ( int i=0; i<d.size(); i++ ) {
        cellAnim.push_back(AnimCell(cellWidth, cellHeight, bg[i], d[i], d2[i], scale));
        cellAnim.back().isColors = isColors;
        cellAnim.back().isSidebar = isSidebar;
    }
}

void SelectionScreen::Grid::deselectAll() {
    for ( int i=0; i<cellAnim.size(); i++ ) {
        cellAnim[i].selected = false;
    }
}

void SelectionScreen::Grid::draw() {
    ofTranslate(gridPosition);
    for ( int i=0; i<cellAnim.size(); i++ ) {
        ofPushMatrix();
            ofTranslate(cellMids[i]);
            cellAnim[i].draw();
        ofPopMatrix();
    }
}

int SelectionScreen::Grid::touchGrid(ofVec2f pt) {
    // take into account grid position
    pt -= gridPosition;
    
    // find what cell was touched
    for( int i=0; i<cellMids.size(); i++ ) {
        if( cellMids[i].distance(pt) <= cellHalfWidth ) {
            cellAnim[i].startAnim();
            return i;
        }
    }
    
    std::cout << "returning -1" << std::endl;
    return -1;
}


