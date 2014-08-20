//==============================================================================
//
//  STAMPIES
//
//  TouchPattern.mm
//
//  Author: Stephen Aldriedge, 2014
//
//==============================================================================

#include "TouchPattern.h"

#include "Utility.h"
#include "Pattern.h"

TouchPattern::TouchPattern() : registeredPattern(NULL) {

}

void TouchPattern::updateTransform() {
    ofVec2f curFirstToSecond(touches[1]->x - touches[0]->x,
                             touches[1]->y - touches[0]->y);
    
    //angle = Utility::angleBetween(curFirstToSecond, registeredPattern->firstToSecond);
    angle = Utility::angleBetween(curFirstToSecond, registeredPattern->vectors[0]);
    
    
    size_t count = touches.size();
    // update position
    ofVec2f total;
    for(int i=0; i<count; i++) {
        total += *touches[i];
    }
    position = total/count;
}
