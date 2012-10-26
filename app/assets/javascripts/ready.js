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
   
   
   sortTable()
   $(window).scroll(UpdateTableHeaders).trigger("scroll");
});