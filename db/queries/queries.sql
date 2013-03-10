# team names based on annual stats
select distinct t.name from annual_stats a left join teams t on t.id = a.team_id where a.year = '2013-01-01';

select distinct t.name from games a left join teams t on t.id = a.home_team left join teams b on b.id = a.home_team where a.date > '2013-01-01';

select id, ncaa_id from games where ( home_team in (15,31,10,27,46,66) or away_team in (15,31,10,27,46,66) ) and date > '2013-01-01';  

select distinct t.id from games g left join teams t on g.home_team = t.id or g.away_team = t.id where g.date between '2013-01-01' and '2013-12-31';