SELECT i.track_id, i.track_name, s.student_id, s.date_enrolled, s.date_completed
FROM 
	career_track_info i
INNER JOIN
	career_track_student_enrollments s on i.track_id = s.track_id
ORDER BY i.track_id;
	
select
	a.*,
    case 
		WHEN days_for_completion = 0 then "Same day"
		WHEN days_for_completion BETWEEN 1 AND 7 THEN '1 to 7 days'
        WHEN days_for_completion BETWEEN 8 AND 30 THEN '8 to 30 days'
        WHEN days_for_completion BETWEEN 31 AND 60 THEN '31 to 60 days'
        WHEN days_for_completion BETWEEN 61 AND 90 THEN '61 to 90 days'
        WHEN days_for_completion BETWEEN 91 AND 365 THEN '91 to 365 days'
        WHEN days_for_completion >= 366 THEN '366+ days'
    end as complete_bucket    
from 
	(SELECT 
		row_number () over (ORDER BY student_id, track_name DESC) as student_track_id,
		i.track_id, i.track_name, s.student_id, s.date_enrolled, s.date_completed,
        if(date_completed IS NULL, 0, 1) as track_completed, 
		DATEDIFF(s.date_completed, s.date_enrolled) as days_for_completion
	FROM 
		career_track_info i
	INNER JOIN
		career_track_student_enrollments s on i.track_id = s.track_id 
    ORDER BY i.track_id) as a;
    
select
    sum(track_completed) as total
from 
	(SELECT 
		row_number () over (ORDER BY student_id, track_name DESC) as student_track_id,
		i.track_id, i.track_name, s.student_id, s.date_enrolled, s.date_completed,
        if(date_completed IS NULL, 0, 1) as track_completed, 
		DATEDIFF(date_completed, date_enrolled) as days_for_completion
	FROM 
		career_track_info i
	INNER JOIN
		career_track_student_enrollments s on i.track_id = s.track_id 
    ORDER BY i.track_id) as a;