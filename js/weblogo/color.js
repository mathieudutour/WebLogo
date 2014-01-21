 "use strict";

    var Color = function (init,g,b) {
            this.initialize(init,g,b);
        };

    var p = Color.prototype;
    p.constructor = Color;
    p.color = null;
    
    var primary_colors = {
    	gray : "#8D8D8D",
    	red : "#CA4630",
    	orange : "#E57226",
    	brown : "#996F4B",
    	yellow : "#F2E635",
    	green : "#71A843",
    	lime : "#68C644",
    	turquoise : "#499979",
    	cyan : "#6DC1C3",
    	sky : "#3D8EBC",
    	blue : "#3163A7",
    	violet : "#735CA2",
    	magenta : "#9B376A",
    	pink : "#D58796",
    	black : "#000000",
    	white : "#FFFFFF"
    };
    var primary_colors_array = [
    	"#8D8D8D",
    	"#CA4630",
    	"#E57226",
    	"#996F4B",
    	"#F2E635",
    	"#71A843",
    	"#68C644",
    	"#499979",
    	"#6DC1C3",
    	"#3D8EBC",
    	"#3163A7",
    	"#735CA2",
    	"#9B376A",
    	"#D58796"
    ];

    /**
     * This function initialize some of the properties
     * It is called from the constructor
     */
    p.initialize = function (init,g,b) {

        this.setInitialValues(init,g,b);

    };
    
    /**
     * Initialize a bunch of properties.
     */
    p.setInitialValues = function (init,g,b) {
	    this.color = (init && g && b)?approximate_rgb(init, g, b):(primary_colors[init]?init:random_primary_color());
    };  
    
    p.r = function () {
    	return parseInt(this.color.slice(1,3), 16);
    }; 
    p.g = function () {
    	return parseInt(this.color.slice(3,5), 16);
    }; 
    p.b = function () {
    	return parseInt(this.color.slice(5,7), 16);
    };
    
    /**
     * Reports a random color from 14 primary colors.
     *
     */
    var random_primary_color = function () {
	     return primary_colors_array[Math.floor(Math.random()*14)];
    };
     
    /**
     * Reports a number in the range 0 to 140, not including 140 itself, that represents the given color, specified in the HSB spectrum, in NetLogo's color space.
     *
     * All three values should be in the range 0 to 255.     
     */
    var approximate_hsb = function (h, s, v){
	    var r, g, b;
	    h = h/255;
	    s = s/255;
	    v= v/255;
	    var i = Math.floor(h * 6);
	    var f = h * 6 - i;
	    var p = v * (1 - s);
	    var q = v * (1 - f * s);
	    var t = v * (1 - (1 - f) * s);
	
	    switch(i % 6){
	        case 0: r = v, g = t, b = p; break;
	        case 1: r = q, g = v, b = p; break;
	        case 2: r = p, g = v, b = t; break;
	        case 3: r = p, g = q, b = v; break;
	        case 4: r = t, g = p, b = v; break;
	        case 5: r = v, g = p, b = q; break;
	    }
	
	    return new Color("#"+(r * 255).toString(16)+(g * 255).toString(16)+(b * 255).toString(16));
	}
	
	/**
     * Reports a number in the range 0 to 140, not including 140 itself, that represents the given color, specified in the HSB spectrum, in NetLogo's color space.
     *
     * All three values should be in the range 0 to 255.     
     */
    var approximate_rgb = function (r, g, b){
	    return new Color("#"+r.toString(16)+g.toString(16)+b.toString(16));
	}
    
    /**
     * Reports a list of the 14 basic NetLogo hues.
	 */
     var base_colors = function () {
	    return primary_colors_array;
    };
    
    /**
     * Reports a list of three values in the range 0 to 255 representing the hue, saturation and brightness, respectively, of the given NetLogo color in the range 0 to 140, not including 140 itself.     
     */
    var extract_hsb = function (color){
	    r = color.r()/255, g = color.g()/255, b = color.b()/255;
	    var max = Math.max(r, g, b), min = Math.min(r, g, b);
	    var h, s, v = max;
	
	    var d = max - min;
	    s = max == 0 ? 0 : d / max;
	
	    if(max == min){
	        h = 0; // achromatic
	    }else{
	        switch(max){
	            case r: h = (g - b) / d + (g < b ? 6 : 0); break;
	            case g: h = (b - r) / d + 2; break;
	            case b: h = (r - g) / d + 4; break;
	        }
	        h /= 6;
	    }
	
	    return [h*255, s*255, v*255];
	}
	
	/**
     * Reports a list of three values in the range 0 to 255 representing the levels of red, green, and blue, respectively, of the given NetLogo color in the range 0 to 140, not including 140 itself.     
     */
    var extract_hsb = function (color){
	    return [color.r(), color.g(), color.b()];
	}
    
    /**
     * Reports a RGB list when given three numbers describing an HSB color. Hue, saturation, and brightness are integers in the range 0-255. The RGB list contains three integers in the same range.     
     */
    var hsb = function (h, s, v){
	    var r, g, b;
	    h = h/255;
	    s = s/255;
	    v= v/255;
	    var i = Math.floor(h * 6);
	    var f = h * 6 - i;
	    var p = v * (1 - s);
	    var q = v * (1 - f * s);
	    var t = v * (1 - (1 - f) * s);
	
	    switch(i % 6){
	        case 0: r = v, g = t, b = p; break;
	        case 1: r = q, g = v, b = p; break;
	        case 2: r = p, g = v, b = t; break;
	        case 3: r = p, g = q, b = v; break;
	        case 4: r = t, g = p, b = v; break;
	        case 5: r = v, g = p, b = q; break;
	    }
	
	    return [r*255, g*255, b*255];
	}
	
	/**
     * Reports a shade of color proportional to the value of number.
     *
     * Typically number is an agent variable, but may be any numeric reporter.  
     *
     * If range1 is less than range2, then the larger the number, the lighter the shade of color. But if range2 is less than range1, the color scaling is inverted.
     *
     * If number is less than range1, then the darkest shade of color is chosen.
     * 
     * If number is greater than range2, then the lightest shade of color is chosen.   
     */
    var scale_color = function (color, number, range1, range2){

	}
	
   /**
	* Reports true if both colors are shades of one another, false otherwise.
	*/
	var shade_of = function (color1, color2){

	}
	
   /**
	* wrap-color checks whether number is in the NetLogo color range of 0 to 140 (not including 140 itself). If it is not, wrap-color "wraps" the numeric input to the 0 to 140 range.
	*
	* The wrapping is done by repeatedly adding or subtracting 140 from the given number until it is in the 0 to 140 range. (This is the same wrapping that is done automatically if you assign an out-of-range number to the color turtle variable or pcolor patch variable.)
	*/
	var wrap_color = function (number){

	}