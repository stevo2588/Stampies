//==============================================================================
//
//  STAMPIES
//
//  Utility.h
//
//  Author: Stephen Aldriedge, 2014
//
//==============================================================================

#ifndef Colors_Utility_h
#define Colors_Utility_h

#include "ofMain.h"

namespace Utility {
    
    //------------ angleBetween function ------------
    float angleBetween (ofVec2f v1, ofVec2f v2);
    
    //------------ factorial function ---------------
    int factorial(int n) {
        return (n == 1 || n == 0) ? 1 : factorial(n - 1) * n;
    }
    
    //------------ nCr formula (combinations) function
    // n! / ( r!(n - r)! ). For 0 <= r <= n.
    unsigned nCr(unsigned n, unsigned r) {
        return factorial(n) / ( factorial(r) * factorial(n - r) );
    }
    
    //std::vector<ofVec2f*> getCombo(std::vector<ofVec2f*> points, size_t comboSize, size_t index);
    
    std::vector<std::vector<ofVec2f*> > getEveryCombo(std::vector<ofVec2f*>& points, size_t comboSize);
    
    // Credit to: http://stackoverflow.com/questions/12991758/creating-all-possible-k-combinations-of-n-items-in-c
    //std::vector<ofVec2f*> getCombo(std::vector<ofVec2f*> points, size_t k, int offset, std::vector<ofVec2f*>& combo);
    void getEveryCombo(std::vector<ofVec2f*>& points, size_t k, int offset,
                                        std::vector<ofVec2f*>& combo, std::vector<std::vector<ofVec2f*> >& out);
    
    //------------ SimpleButton class --------------
    class SimpleButton {
    public:
        SimpleButton(const ofRectangle& rect, const ofColor& color, const ofColor& pressColor, const std::string& label, ofTrueTypeFont& font);
        
        void setText(const std::string& text) { label = text; }
        void setTextPos(const ofVec2f& pos) { labelPos = pos; }
        
        void draw();
        
        bool touchDown(ofVec2f & touch) {
            if(rect.inside(touch.x, touch.y)) {
                state = 1;
                lastTouch = &touch;
                return true;
            }
            return false;
        }
        void touchMoved(ofVec2f & touch) {}
        bool touchUp(ofVec2f & touch) {
            if(state == 1 && rect.inside(touch.x, touch.y) && &touch == lastTouch) {
                state = 0;
                return true;
            }
            return false;
        }
        
    private:
        ofRectangle rect;
        ofColor color;
        ofColor pressColor;
        
        ofTrueTypeFont& font;
        std::string label;
        ofVec2f labelPos;
        
        ofVec2f* lastTouch;
        
        int state; // 0: up, 1: down
    };
    
    //-------------- CenterDrawable -------------------------
    // Class for drawing things center
    class CenterDrawable {
    public:
        virtual ~CenterDrawable() {}
        virtual void draw() =0;
        virtual CenterDrawable* clone() =0;
    };
    
    class ImageDrawable : public CenterDrawable {
    public:
        ~ImageDrawable() { im.clear(); }
        
        void set(ofFile& file) { im.loadImage(file); }
        void draw() {
            ofSetColor (ofColor(255));
            ofTranslate(-210, -135);
            ofScale(0.7f, 0.7f);
            im.draw(0,0);
        }
        CenterDrawable* clone() {
            return new ImageDrawable(*this);
        }
        
    private:
        ofImage im;
    };
    
    
    
    class ColoredCircleDrawable : public CenterDrawable {
    public:
        ColoredCircleDrawable(ofColor c) : c(c) {}
        void draw() {
            ofSetColor (c);
            ofEllipse(0, 0, 200, 200);
        }
        CenterDrawable* clone() {
            return new ColoredCircleDrawable(*this);
        }
        
        ofColor c;
    };

    //-------------- DrawFunctor ----------------------
    class DrawFunctor {
    public:
        virtual void draw() =0;
    };
}

#endif
