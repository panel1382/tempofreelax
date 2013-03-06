function boxScore_HeadToHead(){
	$('.box_score tr').each(function(){
		if ($(this).children().length == 5){
			var home = $(this).children()[2]
			var away = $(this).children()[3]
			var direction 
			
			if($(this).hasClass('ascending')){ direction = 'asc' }
			else if ($(this).hasClass('descending')){ direction = 'desc' }
			else if ($(this).hasClass('skip')){ direction = 'skip' }
			
			console.log(direction)
			
			if(parseFloat($(home).text()) > parseFloat($(away).text())){
				if( direction == 'desc' ){
					$(home).addClass('winner')
					$(away).addClass('loser')
				}
				else if ( direction == 'asc' ){
					$(away).addClass('winner')
					$(home).addClass('loser')
				}
			}
			else{
				if( direction == 'desc' ){
					$(away).addClass('winner')
					$(home).addClass('loser')
				}
				else if ( direction == 'asc' ){
					$(home).addClass('winner')
					$(away).addClass('loser')
				}
			}
		}
	});
}