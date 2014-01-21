$(document).ready(function() 
	{
	    var canvas = document.getElementById("canvas");
	        if(!canvas)
	        {
	            alert("Impossible de récupérer le canvas");
	            return;
	        }
	 
	    var context = canvas.getContext('2d');
	        if(!context)
	        {
	            alert("Impossible de récupérer le context du canvas");
	            return;
	        }
	    
	        new Observer(context, canvas).display();
	    //C'est ici que l'on placera tout le code servant à nos dessins.
	});