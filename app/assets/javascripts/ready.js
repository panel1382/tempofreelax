$(document).ready(function(){
  
  var clonedHeaderRow;
  
  $('th').each(function() {
    $(this).css("width", $(this).width());
  });
   
   $(".persist-area").each(function() {
       clonedHeaderRow = $(".persist-header", this);
       clonedHeaderRow
         .before(clonedHeaderRow.clone())
         .css("width", clonedHeaderRow.width())
         .addClass("floatingHeader");
         
   });

   formatText();
   boxScore_HeadToHead();
   sortTable();
   $(window).scroll(UpdateTableHeaders).trigger("scroll");

   // Defined in teams.js
   voteListeners();
	$("form[data-remote]")
		.bind('ajax:before', function(){console.log('before')})
	    .bind('ajax:complete', function(){console.log('done')})
		.bind('ajax:success', function(){$(this).parents('td').addClass('success')})
		
});

function formatText(){
	// Round numbers
   $('td:contains(.)').each(function(){
		a = $(this).text()
		b = Math.round(a*1000)/1000

		if(b > 0){
			$(this).text(b)
		}
	});
	
	$('tr td:nth-child(1):contains(%)').each(function(){
		$(this).siblings().each(function(){
			
			var text = $(this).text()
			if (text.indexOf){
				if ( text.indexOf('%') === -1){
					$(this).text( $(this).text() + ' %' )
				}
			}
		})
	});
}