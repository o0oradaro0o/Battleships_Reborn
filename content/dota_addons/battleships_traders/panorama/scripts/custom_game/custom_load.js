"use strict";
var hidden = true;

var currentlearn=1;
var maxpages=11;

function prev() {
	$("#learn"+currentlearn).style.width = "0%";
if(currentlearn==1)
{
	currentlearn=maxpages
}
else
{
	currentlearn--;
}

		$("#learn"+currentlearn).style.width = "100%";

	$("#pageCountLabel").text = currentlearn+"/"+maxpages

}
function next() {
	$("#learn"+currentlearn).style.width = "0%";
	if(currentlearn==maxpages)
	{
		currentlearn=1
	}
	else
	{
		currentlearn++;
	}

	$("#learn"+currentlearn).style.width = "100%";
	$("#pageCountLabel").text = currentlearn+"/"+maxpages
}



