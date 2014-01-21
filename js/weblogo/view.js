 "use strict";

    var View = function (canvas,context,observer) {
            this.initialize(canvas,context,observer);
        };

    var p = View.prototype;
    p.constructor = View;
    p.canvas = null;
    p.context = null;
    p.observer = null;
    
    var shapes = {
	    "default" : "./img/turtle.svg"
    }

    /**
     * This function initialize some of the properties
     * It is called from the constructor
     */
    p.initialize = function (canvas,context,observer) {

        this.setInitialValues(canvas,context,observer);

    };
    
   /**
    * Conversion between webLogo coord and canvas coord
    */
    p.adapt_x = function (x, size) {
	    return (x-this.observer.globals.min_pxcor+1)*this.observer.globals.patch_size-size/2-this.observer.globals.patch_size/2;
    };
    p.adapt_y = function (y, size) {
	    return (y-this.observer.globals.min_pycor+1)*this.observer.globals.patch_size-size/2-this.observer.globals.patch_size/2;
    };
    
    /**
     * Initialize a bunch of properties.
     */
    p.setInitialValues = function (canvas,context,observer) {
	    this.canvas = canvas;
	    this.context = context;
	    this.observer = observer;
    };  
    
    
    /**
     * Clear the canvas
     *
     */
    p.clear = function () {
	     this.context.clearRect(0, 0, canvas.width, canvas.height);
	     this.context.font=""+(this.observer.globals.patch_size-5)+"px Arial";
    };
     
    /**
     * Draw a patch
     */
    p.draw_patch = function (x,y,color,label,label_color) {
    	this.context.fillStyle = color.color;
    	var x_adapt = this.adapt_x(x, this.observer.globals.patch_size);
    	var y_adapt = this.adapt_y(y, this.observer.globals.patch_size);
    	//console.log("(" +x_adapt+", "+y_adapt+")");
    	//console.log("(" +color.color);
	    this.context.fillRect(x_adapt, y_adapt, this.observer.globals.patch_size, this.observer.globals.patch_size);
	    if(label && label!=="") {
		    this.context.font=""+(this.observer.globals.patch_size-5)+"px Arial";
		    this.context.fillStyle = label_color.color;
		    this.context.fillText(label, x_adapt+1, y_adapt+1)
	    }
    }; 
    
   /**
     * Draw a turtle     */
    p.draw_turtle = function (shape, size,x,y,color,label,label_color) {
	    this.context.fillStyle = color.color;
    	var x_adapt = this.adapt_x(x, size);
    	var y_adapt = this.adapt_y(y, size);
	    this.context.fillRect(x_adapt, y_adapt, size, size);
	    if(label && label!=="") {
		    this.context.font=""+(this.observer.globals.patch_size-5)+"px Arial";
		    this.context.fillStyle = label_color.color;
		    this.context.fillText(label, x_adapt+1, y_adapt+1)
	    }
    };