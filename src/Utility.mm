//==============================================================================
//
//  STAMPIES
//
//  Utility.mm
//
//  Author: Stephen Aldriedge, 2014
//
//==============================================================================

#include "Utility.h"

#include "ofMain.h"

#include <cmath>

float Utility::angleBetween (ofVec2f v1, ofVec2f v2) {
    //float a = atan2(v1.y, v1.x) - atan2(v2.y,v2.x);
    float a = atan2f(v2.y-v1.y, v2.x-v1.x);
    return a;
}

/*
std::vector<ofVec2f*> Utility::getCombo(std::vector<ofVec2f*> points, size_t comboSize, size_t index) {
    //std::vector<ofVec2f*> combo;
    //std::vector<std::vector<ofVec2f*> > combos;
    //getEveryCombo(points, comboSize, 0, combo);
    //return combo;
    
    std::vector<ofVec2f*> result(comboSize);
    std::vector<int> ans(comboSize);
    int a = points.size();
    int b = comboSize;
    long x = (Choose(a, b) - 1) - index;
    for (int i = 0; i < comboSize; i++) {
        ans[i] = LargestV(a, b, x);
        x -= Choose(ans[i], b);
        a = ans[i];
        b--;
    }
    for (int i = 0; i < comboSize; i++) {
        result[i] = items[items.Length - 1 - ans[i]];
    }
    return result;
}

int Utility::LargestV(int a, int b, long x) {
    int v = a - 1;
    while (Choose(v, b) > x) {
        v--;
    }
    return v;
}

int Utility::Choose(int n, int k) {
    long result = 0;
    int delta;
    int max;
    if (n < 0 || k < 0) {
        throw new ArgumentOutOfRangeException("Invalid negative parameter in Choose()");
    }
    if (n < k) {
        result = 0;
    } else if (n == k) {
        result = 1;
    } else {
        if (k < n - k) {
            delta = n - k;
            max = k;
        } else {
            delta = k;
            max = n - k;
        }
        result = delta + 1;
        for (int i = 2; i <= max; i++) {
            checked {
                result = (result * (delta + i)) / i;
            }
        }
    }
    return result;
}
*/

std::vector<std::vector<ofVec2f*> > Utility::getEveryCombo(std::vector<ofVec2f*>& points, size_t comboSize) {
    std::vector<ofVec2f*> combo;
    std::vector<std::vector<ofVec2f*> > combos;
    getEveryCombo(points, comboSize, 0, combo, combos);
    return combos;
}

// Credit to: http://stackoverflow.com/questions/12991758/creating-all-possible-k-combinations-of-n-items-in-c
void Utility::getEveryCombo(std::vector<ofVec2f*>& points, size_t k, int offset,
                                        std::vector<ofVec2f*>& combo, std::vector<std::vector<ofVec2f*> >& out)
{
    if (k == 0) {
        out.push_back(combo);
        combo.clear();
        return;
    }
    for (int i = offset; i <= points.size() - k; ++i) {
        combo.push_back(points[i]);
        getEveryCombo(points, k-1, i+1, combo, out);
        combo.pop_back();
    }
}


Utility::SimpleButton::SimpleButton(const ofRectangle& rect, const ofColor& color, const ofColor& pressColor,
                                    const std::string& label, ofTrueTypeFont& font)
: rect(rect), color(color), pressColor(pressColor), label(label), labelPos(rect.x+14, rect.y+(rect.height/2 + 5)), state(0),
font(font)
{
	//verdana14.loadFont("verdana.ttf", 14, true, true);
}

void Utility::SimpleButton::draw() {
    if(state == 0) ofSetColor(color);
    else ofSetColor(pressColor);
    
    ofRect(rect);
    
    ofSetColor(0);
    font.drawString(label, labelPos.x, labelPos.y);
}