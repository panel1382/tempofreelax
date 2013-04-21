function voteListeners(){
	
	console.log('oh hai')
	$('.vote').live('blur',function(){
		console.log( $(this).children('select').attr('value') )
		if ($(this).children('select').attr('value') > 0){
			$(this).parents('form').submit()
		}
	})
}