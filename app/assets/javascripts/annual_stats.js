/* Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
*/

function sortTable(){
  $('.sortable').tablesorter({
    textExtraction: pullNumber,
    sortList: [[2,1]]
    });
}

function pullNumber(node){
	var data;
	var pos;
	var text = $(node).text();
	
	if(text.indexOf('-') > 0){
	 pos = text.indexOf('-');
	 data = text.substring(0, pos);
	}
	else if(text.indexOf(' ') > 0){
		if(text.indexOf('%') > 0) 
			pos =  text.indexOf('%');
		else
			pos =  text.indexOf(' ');
		data = text.substring(0, pos)	;
	}
	else {
		data = text;
	}
	
	return data;
}

function UpdateTableHeaders() {
  console.log('scroll')
   $(".persist-area").each(function() {
       var el             = $(this),
           offset         = el.offset(),
           scrollTop      = $(window).scrollTop(),
           floatingHeader = $(".floatingHeader", this)
       
       if ((scrollTop > offset.top) && (scrollTop < offset.top + el.height())) {
           floatingHeader.css({
            "visibility": "visible"
           });
       } else {
           floatingHeader.css({
            "visibility": "hidden"
           });   
       };
   });
}