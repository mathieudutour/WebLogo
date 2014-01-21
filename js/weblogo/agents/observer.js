"use strict";

    var Observer = function (context, canvas) {
            this.initialize(context,canvas);
        };

    var p = Observer.prototype;
    p.constructor = Observer;
    p.turtles = null;
    p.patches = null;
    p.links = null;
    p.view = null;
    p.globals = null;
    p.defaults = null;

    /**
     * This function initialize some of the properties
     * It is called from the constructor
     */
    p.initialize = function (context, canvas) {

        this.setInitialValues(context, canvas);

    };
    
    /**
     * Initialize a bunch of properties.
     */
    p.setInitialValues = function (context, canvas) {
    	this.globals = {
	    	min_pxcor : min_pxcor,
			min_pycor : min_pycor,
			max_pxcor : max_pxcor,
			max_pycor : max_pycor,			
			wrap_x : wrap_x,
			wrap_y : wrap_y,	
			patch_size : patch_size
    	};
    	this.defaults = {
	    	patch : {
	    		label_color : "white",
		    	label : "",
		    	color : "black"
	    	},
	    	turtle : {
		    	shape : "default",
		    	hidden : false,
		    	label_color : "black",
		    	label : "",
		    	pen_mode : "up",
		    	pen_size : 2,
		    	size : 10,
		    	xcor : (this.globals.max_pxcor-this.globals.min_pxcor+1)/2+this.globals.min_pxcor,
		    	ycor : (this.globals.max_pycor-this.globals.min_pycor+1)/2+this.globals.min_pycor,
		    	variable : {}
	    	},
	    	link : {
		    	
	    	}
    	};
	    this.turtles = [];
	    this.patches = [];
	    for (var i = 0; i<this.globals.max_pxcor-this.globals.min_pxcor+1;i++)
	    	for (var j = 0; j<this.globals.max_pycor-this.globals.min_pycor+1;j++)
	    		this.patches.push(new Patch(this, i + this.globals.min_pxcor, j + this.globals.min_pycor));
	    this.links = [];
	    canvas.width = (this.globals.max_pxcor-this.globals.min_pxcor+1)*this.globals.patch_size;
	    canvas.height = (this.globals.max_pycor-this.globals.min_pycor+1)*this.globals.patch_size;
	    canvas.style.width = (this.globals.max_pxcor-this.globals.min_pxcor+1)*this.globals.patch_size;
	    canvas.style.height = (this.globals.max_pycor-this.globals.min_pycor+1)*this.globals.patch_size;
	    this.view = new View(canvas, context, this);	    
    };
    
   /**
    * Causes the view to be updated immediately. (Exception: if the user is using the speed slider to fast-forward the model, then the update may be skipped.)
    */
    p.display = function () {
    	var view = this.view;
	    view.clear();
	    this.patches.forEach(function (patch) {
		    view.draw_patch(patch.xcor,patch.ycor,patch.color,patch.label,patch.label_color);
	    });
	    this.turtles.forEach(function (turtle) {
		    view.draw_turtle(turlte.shape, turtle.size,turtle.xcor,turtle.ycor,turtle.color,turtle.label,turtle.label_color);
	    });
    };
    
   /**
    * Kills all turtles.
    */
    p.clear_turtles = function () {
    	this.turtles = [];
    };
    
   /**
    * Creates number new turtles at the origin. New turtles have random integer headings and the color is randomly selected from the 14 primary colors.
    */
    p.create_turtles = function (number, breed) {
    	if(number && number>0)
    		for(var i = 0; i<number; i++) {
	    		this.turtles.push(new Turtle(this, breed));
    		}
    };
    
    /**
    * Creates number new turtles. New turtles start at position (0, 0), are created with the 14 primary colors, and have headings from 0 to 360, evenly spaced.
    */
    p.create_ordered_turtles = function (number, breed) {
    	if(number && number>0)
    		for(var i = 0; i<number; i++) {
    			var turtle = new Turtle(this, breed);
    			turtle.heading = i*360/number;
	    		this.turtles.push(turtle);
    		}
    };