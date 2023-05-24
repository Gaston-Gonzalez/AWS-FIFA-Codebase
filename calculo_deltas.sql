-- FORMATIVAS - TOP 100 JUGADORES ---
with _players as (
	select fifa_year, id, name, overall, row_number() over ( partition by fifa_year order by overall desc) as rn
	from players_normalized pn
	where age <= 24
	order by 1,4 desc
), top_players as (
	select distinct id
	from _players 
	where rn <= 100
), player as (
	select *
	from players_normalized pn 
	where id in (select distinct id from top_players)
),	club_formativa as (
	select id, fifa_year, club as club_formativa, row_number() over( partition by id order by fifa_year ) as rn
	from players_normalized pn
	order by 1, 2
), clubs_top_players as (
select distinct club_formativa, p.id
from player p
join club_formativa cf on p.id = cf.id and cf.rn = 1
)
select club_formativa, count(*) as cant
from clubs_top_players
group by 1
order by 2 desc
--- FIN ---


--- CLUBES FORMATIVAS QUE SACARON MEJORES JUGADORES ---
with players as (
	select id, max(overall) max_overall
	from players_normalized pn
	group by 1
), player_delta as (
	select id, sum(coalesce(delta, 0)) as delta
	from players_normalized pn 
	group by 1
), club_formativa as (
	select id, fifa_year, club as club_formativa, row_number() over( partition by id order by fifa_year ) as rn, min(age) as min_age
	from players_normalized pn
	group by 1, 2, 3
	order by 1, 2
)
select cf.club_formativa, cast(sum(delta) as decimal) as delta
from player_delta pd
join club_formativa cf on pd.id = cf.id and cf.rn = 1 and min_age <= 24
join players p on pd.id = p.id and p.max_overall >= 80
where pd.delta > 0 
group by 1
order by 2 desc
--- FIN ---


--- CLUBES DONDE LOS JUGADORES MEJORARON MÁS ---
with players as (
	select id, max(overall) max_overall
	from players_normalized pn
	group by 1
), player_delta as (
	select id, sum(coalesce(delta, 0)) as delta
	from players_normalized pn 
	group by 1
), club_player_delta as (
select club, pd.id, pd.delta as delta
from player_delta pd
join players_normalized pn on pd.id = pn.id
order by 1,2,3 desc
)
select club, sum(cpd.delta) as delta
from club_player_delta cpd
join players p on cpd.id = p.id and p.max_overall >= 80 
join player_delta pd on pd.id = cpd.id and pd.delta > 0
group by 1
order by 2 desc
--- FIN ---
