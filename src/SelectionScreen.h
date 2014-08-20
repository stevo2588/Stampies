//==============================================================================
//
//  STAMPIES
//
//  SelectionScreen.h
//
//  Author: Stephen Aldriedge, 2014
//
//==============================================================================

#ifndef Stampies_SelectionScreen_h
#define Stampies_SelectionScreen_h

#include "Level.h"
#include "Canvas.h"
#include "TouchPatternManager.h"
#include "Utility.h"

#include <map>

class SelectionScreen : public Level, public TouchPatternListener {
public:
    SelectionScreen(testApp& app, Canvas &canvas, std::vector<std::vector<std::vector<ofFile> > > images, std::vector<ofFile> matImages);
    
    enum SelectionState { IMAGES1, IMAGES2, IMAGES3, IMAGES4,
                          COLORS1 };
    
    class AnimCell : public Utility::DrawFunctor {
    public:
        AnimCell(unsigned w, unsigned h, ofColor bg, Utility::CenterDrawable* d, Utility::CenterDrawable* d2, float scale)
        : w(w), h(h), frames(30), curFrame(0), bg(bg), gridBox(0, 0, w-3, h-3), content(d), secondaryContent(d2), scale(scale), selected(false), isSidebar(false), isColors(false) {}
        
        void draw();
        
        void startAnim() { curFrame = frames; }
        
        Utility::CenterDrawable* content;
        Utility::CenterDrawable* secondaryContent;
        
        bool selected;
        bool isSidebar;
        bool isColors;
        
    private:
        unsigned w, h;
        unsigned frames;
        unsigned curFrame;
        ofColor bg;
        ofRectangle gridBox;
        float scale;
        
    };
    
    class Grid {
    public:
        Grid();
        
        void SetGridSize(unsigned w, unsigned h, unsigned gridWidthPix, unsigned gridHeightPix, ofVec2f pos);
        void SetGridContent(std::vector<ofColor> bg, std::vector<Utility::CenterDrawable*>& d, std::vector<Utility::CenterDrawable*>& d2, float scale);
        void deselectAll();
        
        ofVec2f gridPosition;
        unsigned gridWidth, gridHeight;
        unsigned cellWidth, cellHeight;
        unsigned cellHalfWidth, cellHalfHeight;
        void draw();
        int touchGrid(ofVec2f pt);
        bool isSidebar;
        bool isColors;
        
        Utility::CenterDrawable* getCellDrawable(unsigned i) {
            return cellAnim[i].content;
        }
        
    private:
        unsigned totalCells;
        std::vector<ofVec2f> cellMids;
        std::vector<AnimCell> cellAnim;
    };
    
    SelectionState state;
    unsigned userStudyMode;

    
    void setup(int mode);
    void update();
    void draw();
    void cleanup();
    
    static std::vector<ofColor> getBGForImages();
    static std::vector<ofColor> getBGForSidebar();
    static std::vector<ofColor> getBGForColors();
    
    void setNumImages(size_t n);
    
    // Touch handlers
    void unassignedDown(ofVec2f & touch);
    void unassignedMoved(ofVec2f & touch) {}
    void unassignedUp(ofVec2f & touch) {}
    
    void patternDown(TouchPattern & pat);
    void patternMoved(TouchPattern & pat) {}
    void patternUp(TouchPattern & pat) {}
    
    Grid grid;
    Grid sidebar;
    
private:
    
    std::vector<std::vector<std::vector<ofFile> > > imageFiles;
    std::vector<ofFile> matImages;
    
    std::vector<Utility::ColoredCircleDrawable> coloredCircleDrawables;
    std::vector<Utility::CenterDrawable*> colors;
    
    std::vector<Utility::CenterDrawable*> colorMatDrawables;
    
    std::vector<Utility::ImageDrawable> gridImageDrawables;
    std::vector<Utility::CenterDrawable*> gridDrawables;
    
    std::vector<Utility::CenterDrawable*> sidebarDrawables;
    std::vector<Utility::CenterDrawable*> OrderedStampDrawables;
    
    std::vector<Utility::ImageDrawable> matImageDrawables;
    std::vector<Utility::CenterDrawable*> matDrawables;
    
    Canvas& canvas;
    
    unsigned delayToRegister;
    std::vector<unsigned> patternCheckDelay;
    unsigned registrationFrames;
    
    int waitToChange;
    unsigned colorAssignCount;
    
    bool registering();
    
    void changeImageCategory(unsigned cat);
};

#endif
