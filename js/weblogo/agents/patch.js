 "use strict";

    var Patch = function (observer, x, y) {
            this.initialize(observer, x, y);
        };

    var p = Patch.prototype;
    p.constructor = Patch;
    p.agent = null;
    p.color = null;
    p.label = null;
    p.label_color = null;
    p.xcor = null;
    p.ycor = null;
    p.observer = null;

    /**
     * This function initialize some of the properties
     * It is called from the constructor
     */
    p.initialize = function (observer, x, y) {

        this.setInitialValues(observer, x, y);

    };
    
    /**
     * Initialize a bunch of properties.
     */
    p.setInitialValues = function (observer, x, y) {
    	this.observer = observer;
    	this.agent = "patch";
	    this.color = new Color(observer.defaults.patch.color);
	    this.label = observer.defaults.patch.label;
	    this.label_color = observer.defaults.patch.label_color;
	    this.xcor = x;
	    this.ycor = y;
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
     * Reports true if value is of the given type, false otherwise.
	 */
    p.is = function (patch) {
	    return this.agent === patch;
    };
    
    /**
     * Reports an agentset containing the 8 surrounding patches (neighbors) or 4 surrounding patches (neighbors4).
	 */
    p.neighbors = function () {
    	var temp = [];
    	if(patch(this.xcor,this.ycor+1)) temp.push(patch(this.xcor,this.ycor+1));
    	if(patch(this.xcor+1,this.ycor+1)) temp.push(patch(this.xcor+1,this.ycor+1));
    	if(patch(this.xcor+1,this.ycor)) temp.push(patch(this.xcor,this.ycor));
    	if(patch(this.xcor+1,this.ycor-1)) temp.push(patch(this.xcor+1,this.ycor-1));
    	if(patch(this.xcor,this.ycor-1)) temp.push(patch(this.xcor,this.ycor-1));
    	if(patch(this.xcor-1,this.ycor-1)) temp.push(patch(this.xcor-1,this.ycor-1));
    	if(patch(this.xcor-1,this.ycor)) temp.push(patch(this.xcor-1,this.ycor));
    	if(patch(this.xcor-1,this.ycor+1)) temp.push(patch(this.xcor-1,this.ycor+1));
    	return temp;
    };
    p.neighbors4 = function () {
    	var temp = [];
    	if(patch(this.xcor,this.ycor+1)) temp.push(patch(this.xcor,this.ycor+1));
    	if(patch(this.xcor+1,this.ycor)) temp.push(patch(this.xcor,this.ycor));
    	if(patch(this.xcor,this.ycor-1)) temp.push(patch(this.xcor,this.ycor-1));
    	if(patch(this.xcor-1,this.ycor)) temp.push(patch(this.xcor-1,this.ycor));
    	return temp;
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
     * Reports this patch.
	 */
    p.self = function () {
	    return this;
    };