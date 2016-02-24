package com.gxuwz.rctrlm.views.videoCtrl.mangerGesture
{
import flash.display.DisplayObjectContainer;

/**
 * MGesture
 * Purpose: Detect a single mouse gesture
 * @author Shiu
 * @version 2,		30 October 2011
 */
public class MGesture
{
    private var mainBox:DisplayObjectContainer;
    private var directions:Vector.<Vector2D> = new <Vector2D>[
        new Vector2D(1, 0), 	//East number=0
        new Vector2D(0, 1),		//South number=1
        new Vector2D(-1, 0),	//West number=2
        new Vector2D(0, -1),	//North number=3
        new Vector2D(1, 1),		//South - east number=4
        new Vector2D(-1, 1),	//South - west number=5
        new Vector2D( -1, -1),	//North - west number=6
        new Vector2D(1, -1)		//North - east number=7
    ];

    private var _deviationFromMains:Number = Math2.radianOf(10);
    private var _deviationFromDiagonals:Number = Math2.radianOf(30);
    private var _minDist:Number = 10;
    private var _earlier:Vector2D;
    private var _latter:Vector2D;

    /**
     * Initiate variables
     * @param	container where mouse is detected from
     */
    public function MGesture(container:DisplayObjectContainer) {
        //setting container from which mouse is moving
        mainBox = container;
    }

    /**
     * Method to register initial mouse location
     */
    public function start ():void {
        var startMX:Number = mainBox.mouseX;
        var startMY:Number = mainBox.mouseY;
        trace("mouse start:"+mainBox.mouseX+","+mainBox.mouseY);
        _earlier = new Vector2D(startMX, startMY);	//pointer location, initially
        _latter = new Vector2D(startMX, startMY);	//pointer location, to be updated later
    }

    /**
     * Method to update mouse location
     * @return a Vector2D of current mouse location relative to that when start() is called;
     */
    public function update ():Vector2D {
        _latter = new Vector2D(mainBox.mouseX, mainBox.mouseY);
        trace("_latter:"+mainBox.mouseX+","+mainBox.mouseY);
        var vecUpdate:Vector2D = _latter.minus(_earlier);

        //trace("vecUpdate:"+vecUpdate.x+","+vecUpdate.y);
        return vecUpdate;
    }

    /**
     * Method to validate a gesture.
     * @param	newLoc	Vector2D to new mouse location
     * @return	null if invalid gesture, a Vector2D if valid
     */
    private function validMagnitude ():Vector2D {
        var gestureVector:Vector2D = update();
        var newMag:Number = gestureVector.getMagnitude();

        //if magnitude condition is not fulfilled, reset gestureVector to null
        if (newMag < _minDist)		gestureVector = null;
        return gestureVector;
    }

    /**
     * Method to evaluate gesture direction
     * @return Integer indicative of direction. Invalid gesture, -1.
     */
    public function evalDirections():int {
        //Pessimistic search (initialise with unsuccessful search)
        var detectedDirection:int = -1;

        //validate magnitude condition
        var newDirection:Vector2D = validMagnitude();

        //if gesture exceed minimum magnitude
        if (newDirection != null) {

            //evaluation against all directions
            for (var i:int = 0; i < directions.length; i++)
            {
                var angle:Number = directions[i].angleBetween(newDirection);
                angle = Math.abs(angle);

                //check against main directions
                if ( i < 4 && angle < _deviationFromMains) {
                    detectedDirection = i;
                    break;
                }

                //check against diagonal directions
                else if (i > 3 && angle < _deviationFromDiagonals) {
                    detectedDirection = i;
                    break;
                }
            }

            //update mouse location for next evaluation
            //_earlier =  _latter;
        }

        //return detected direction
        return detectedDirection
    }
}
}