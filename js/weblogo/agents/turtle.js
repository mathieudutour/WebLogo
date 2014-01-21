"use strict";

    var Turtle = function (observer, breed) {
            this.initialize(observer, breed);
        };

    var p = Turtle.prototype;
    p.constructor = Turtle;
    p.agent = null;
    p.breed    = null;
    p.color = null;
    p.heading = null;
    p.hidden = null;
    p.label = null;
    p.label_color = null;
    p.pen_mode = null;
    p.pen_size = null;
    p.shape = null;
    p.size = null;
    p.xcor = null;
    p.ycor = null;
    p.variable = null;
    p.observer = null;

    /**
     * This function initialize some of the properties
     * It is called from the constructor
     */
    p.initialize = function (observer, breed) {

        this.setInitialValues(observer, breed);

    };
    
    /**
     * Initialize a bunch of properties.
     */
    p.setInitialValues = function (observer, breed) {
    	this.agent = "turtle";
    	this.observer = observer;
        this.breed    = breed?breed:"turtle";
	    this.color = new Color(observer.defaults[breed].color?observer.defaults[breed].color:"");
	    this.heading = observer.defaults[breed].heading?observer.defaults[breed].heading:Math.random(360);
	    this.hidden = observer.defaults[breed].hidden;
	    this.label = observer.defaults[breed].label;
	    this.label_color = observer.defaults[breed].label_color;
	    this.pen_mode = observer.defaults[breed].pen_mode;
	    this.pen_size = observer.defaults[breed].pen_size;
	    this.shape = observer.defaults[breed].shape;
	    this.size = observer.defaults[breed].size;
	    this.xcor = observer.defaults[breed].xcor;
	    this.ycor = observer.defaults[breed].ycor;
	    this.variable = observer.defaults[breed].variable;
    };
    
    /**
     * The turtle moves backward by number steps. (If number is negative, the turtle moves forward.)
	 *
	 * Turtles using this primitive can move a maximum of one unit per time increment. So bk 0.5 and bk 1 both take one unit of time, but bk 3 takes three.
	 *
	 * If the turtle cannot move backward number steps because it is not permitted by the current topology the turtle will complete as many steps of 1 as it can and stop.
	 */
    p.back = function (number) {

    };    
    
    /**
     * Reports true if this turtle can move distance in the direction it is facing without violating the topology; reports false otherwise.
     *
     * It is equivalent to:
     *
     * patch-ahead distance != nobody
     */
    p.can_move = function (distance) {
	     
    };
    
    /**
     * Reports the distance from this agent to the given turtle or patch.
     *
     * The distance to or a from a patch is measured from the center of the patch. Turtles and patches use the wrapped distance (around the edges of the world) if wrapping is allowed by the topology and the wrapped distance is shorter.
     */
    p.distance = function (agent) {
	     if(agent.agent && (agent.agent==="turtle" || agent.agent==="path"))
	     	p.distancexy (agent.x, agent.y);
    };
     
    /**
     * Reports the distance from this agent to the point (xcor, ycor).
     *
     * The distance to or a from a patch is measured from the center of the patch. Turtles and patches use the wrapped distance (around the edges of the world) if wrapping is allowed by the topology and the wrapped distance is shorter.
     */
    p.distancexy = function (xcor, ycor) {

    };     
    
    /**
     * Moves the turtle to the neighboring patch with the lowest value for patch_variable. If no neighboring patch has a smaller value than the current patch, the turtle stays put. If there are multiple patches with the same lowest value, the turtle picks one randomly. Non-numeric values are ignored.
     *
     * downhill considers the eight neighboring patches; downhill4 only considers the four neighbors.
     */
    p.downhill = function (patch_variable) {

    }; 
    p.downhill4 = function (patch_variable) {

    }; 
    
    /**
     * Reports the x-increment or y-increment (the amount by which the turtle's xcor or ycor would change) if the turtle were to take one step forward in its current heading.
     *
     * Note: dx is simply the sine of the turtle's heading, and dy is simply the cosine. (If this is the reverse of what you expected, it's because in NetLogo a heading of 0 is north and 90 is east, which is the reverse of how angles are usually defined in geometry.)
     */
    p.dx = function () {
	    return Math.sin(Math.PI*this.heading/180);
    };    
    p.dy = function () {
	    return Math.cos(Math.PI*this.heading/180);
    };

    /**
     * Set the caller's heading towards agent.
     *
     * If wrapping is allowed by the topology and the wrapped distance (around the edges of the world) is shorter, face will use the wrapped path.
     *
     * If the caller and the agent are at the exact same position, the caller's heading won't change.
     */
    p.face = function (agent) {
	     if(agent.agent && (agent.agent==="turtle" || agent.agent==="path"))
	     	this.facexy (agent.x, agent.y);
    };
     
    /**
     * Set the caller's heading towards the point (x,y).
     *
     * If wrapping is allowed by the topology and the wrapped distance (around the edges of the world) is shorter and wrapping is allowed, facexy will use the wrapped path.
     *
     * If the caller is on the point (x,y), the caller's heading won't change.
     */
    p.facexy = function (xcor, ycor) {
    	try {
	    	this.heading = this.towardsxy(xcor, ycor);
    	}
	    catch(e) {}
    }; 
    
    /**
     * The turtle moves forward by number steps, one step at a time. (If number is negative, the turtle moves backward.)
	 *
	 * Turtles using this primitive can move a maximum of one unit per time increment. So fd 0.5 and fd 1 both take one unit of time, but fd 3 takes three.
	 *
	 * If the turtle cannot move forward number steps because it is not permitted by the current topology the turtle will complete as many steps of 1 as it can, then stop.
	 */
    p.forward = function (number) {

    }; 
    
    /**
     * The turtle makes itself invisible.
	 *
	 * Note: This command is equivalent to setting the turtle variable "hidden?" to true.
	 */
    p.hide_turtle = function () {
	    this.hidden = true;
    };
    
    /**
     * This turtle moves to the origin (0,0). Equivalent to setxy 0 0.
	 */
    p.home = function () {
	    this.setxy(0,0);
    };
    
    /**
     * Reports true if value is of the given type, false otherwise.
	 */
    p.is = function (breed) {
	    return this.breed === breed;
    };
    
    /**
     * The turtle moves forward by number units all at once (rather than one step at a time as with the forward command).
	 *
	 * If the turtle cannot jump number units because it is not permitted by the current topology the turtle does not move at all.
	 */
    p.jump = function (number) {

    };   
    
    /**
     * The turtle turns left by number degrees. (If number is negative, it turns right.)
	 */
    p.left = function (number) {
	    this.heading = (this.heading - number) % 360;
    }; 
    
    /**
     * Reports an agentset containing the 8 surrounding patches (neighbors) or 4 surrounding patches (neighbors4).
	 */
    p.neighbors = function () {
	    return this.patch_here().neighbors();
    };
    p.neighbors4 = function () {
	    return this.patch_here().neighbors4();
    };
    
    /**
     * The turtle sets its x and y coordinates to be the same as the given agent's.
	 *
	 * (If that agent is a patch, the effect is to move the turtle to the center of that patch.)
	 *
	 * Note that the turtle's heading is unaltered. You may want to use the face command first to orient the turtle in the direction of motion.
	 */
    p.move_to = function (agent) {
	    if(agent.agent && (agent.agent==="turtle" || agent.agent==="path"))
	     	this.setxy (agent.x, agent.y);
    }; 

    /**
     * Reports the single patch that is the given distance "ahead" of this turtle, that is, along the turtle's current heading. Reports nobody if the patch does not exist because it is outside the world.
	 */
    p.patch_ahead = function (distance) {
	    return patch_at_heading_and_distance(this.heading, distance)
    }; 
    
    /**
     * Reports the patch at (dx, dy) from the caller, that is, the patch containing the point dx east and dy patches north of this agent. Reports nobody if the patch does not exist because it is outside the world.
	 */
    p.patch_at = function (dx, dy) {
	    return patch(this.xcor+dx,this.ycor.dy)
    }; 
    
    /**
     * Reports the single patch that is the given distance from this turtle or patch, along the given absolute heading. (In contrast to patch-left-and-ahead and patch-right-and-ahead, this turtle's current heading is not taken into account.) Reports nobody if the patch does not exist because it is outside the world.
	 */
    p.patch_at_heading_and_distance = function (heading, distance) {
	    return patch_at(distance*Math.sin(Math.PI*heading/180),distance*Math.cos(Math.PI*heading/180));
    }; 
    
    /**
     * Reports the patch under the turtle.
	 */
    p.patch_here = function () {
	    return this.patch_at(0,0);
    }; 
    
    /**
     * Reports the single patch that is the given distance from this turtle, in the direction turned left or right the given angle (in degrees) from the turtle's current heading. Reports nobody if the patch does not exist because it is outside the world.
	 */
    p.patch_left_and_ahead = function (angle, distance) {
	    return patch_at_heading_and_distance(this.heading+angle, distance)
    };
    p.patch_right_and_ahead = function (angle, distance) {
	    this.patch_left_and_ahead(-angle, distance)
    };
    
    /**
     * The turtle changes modes between drawing lines, removing lines or neither. The lines will always be displayed on top of the patches and below the turtles. To change the color of the pen set the color of the turtle using set color.
	 *
	 * Note: When a turtle's pen is down, all movement commands cause lines to be drawn, including jump, setxy, and move-to.
	 */
    p.pen_down = function () {
	    this.pen_mode = "down";
    }; 
    p.pen_erase = function () {
	    this.pen_mode = "erase";
    }; 
    p.pen_up = function () {
	    this.pen_mode = "up";
    }; 
    
    /**
     * The turtle turns right by number degrees. (If number is negative, it turns left.)
	 */
    p.right = function (number) {
	    this.left(-number);
    };
    
    /**
     * Reports this turtle.
	 */
    p.self = function () {
	    return this;
    };
    
    /**
     * The turtle sets its x-coordinate to x and its y-coordinate to y.
	 *
	 * Equivalent to set xcor x set ycor y, except it happens in one time step instead of two.
	 *
	 * If x or y is outside the world, WebLogo will throw a runtime error, unless wrapping is turned on in the relevant dimensions. For example, with wrapping turned on in both dimensions and the default world size where min-pxcor = -16, max-pxcor = 16, min-pycor = -16 and max-pycor = 16, asking a turtle to setxy 17 17 will move it to the center of patch (-16, -16).
	 */
    p.setxy = function (x, y) {

    }; 
    
    /**
     * The turtle becomes visible again.
	 *
	 * Note: This command is equivalent to setting the turtle variable "hidden?" to false.
	 */
    p.hide_turtle = function () {
	    this.hidden = false;
    };
    
    /**
     * Reports the heading from this agent to the given agent.
     *
     * If wrapping is allowed by the topology and the wrapped distance (around the edges of the world) is shorter, towards will use the wrapped path.
     *
     * Note: asking for the heading from an agent to itself, or an agent on the same location, will cause a runtime error.
     */
    p.towards = function (agent) {
	     if(agent.agent && (agent.agent==="turtle" || agent.agent==="path"))
	     	this.towardxy (agent.x, agent.y);
    };
    
    /**
     * Reports the heading from the turtle or patch towards the point (x,y).
     *
     * If wrapping is allowed by the topology and the wrapped distance (around the edges of the world) is shorter, towardsxy will use the wrapped path.
     *
     * Note: asking for the heading to the point the agent is already standing on will cause a runtime error.
     */
    p.towardsxy = function (agent) {

    };
    
    /**
     * Moves the turtle to the neighboring patch with the highest value for patch-variable. If no neighboring patch has a higher value than the current patch, the turtle stays put. If there are multiple patches with the same highest value, the turtle picks one randomly. Non-numeric values are ignored.
     *
     * uphill considers the eight neighboring patches; uphill4 only considers the four neighbors.
     */
    p.uphill = function (patch_variable) {

    }; 
    p.uphill4 = function (patch_variable) {

    }; 