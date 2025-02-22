#   🔨 Case study from 365 Data Science 
###  🔨 Case description 

- Overview: 365 Data Science - A study platform - want to extract insightful information from students who enrolled for some certain course tracks. Based on analysis, the company would like to know the extent that student are engaged and motivated in a certain course track from the platform to complete the course they enrolled in. 
- Goal: Figuring out the number of students of each course, analyzing the period of time students spending to complete a course on the platform and comparing them to each other to discover which course motivate students the most.

### Database structure
`sql_and_tableau` database, consisting of the following tables:

- `career_track_info`
    - `track_id` – the unique identification of a track, which serves as the primary key to the table
    - `track_name` – the name of the track
- `career_track_student_enrollments`
    - `student_id` – the unique identification of a student
    - `track_id` – the unique identification of a track.
    - `date_enrolled` – the date the student enrolled in the track.
    - `date_completed` – the date the student completed the track.
 
### Detailed approach
Identify analyzed questions
- What is the number of enrolled students monthly? Which is the month with the most enrollments? Speculate about the reason for the increased numbers.
- Which career track do students enroll most in?
- What is the career track completion rate? Can you say if it’s increasing, decreasing, or staying constant with time?
- How long does it typically take students to complete a career track? What type of subscription is most suitable for students who aim to complete a career track: monthly, quarterly, or annual?
- What advice and suggestions for improvement would you give the 365 team to boost engagement, increase the track completion rate, and motivate students to learn more consistently?

### Data Preprocessing
Examining the structure of the database 
````sql
SELECT
    *
FROM
	 career_track_info;
-------------------------------
SELECT
    *
FROM
	 career_track_student_enrollments;
````

Create new table by joining two tables with the id_track column

````sql
SELECT i.track_id, i.track_name, s.student_id, s.date_enrolled, s.date_completed
FROM 
	career_track_info i
INNER JOIN
	career_track_student_enrollments s on i.track_id = s.track_id
ORDER BY i.track_id;
````
Create new column: days for completion (the different between enrolled day and finished day), complete bucket (number of days to complete a course track), student_track_id (assign an unique number for each student), track_completed (if student already finished the track, assign with 1l; if not, assign with 0) 

```sql
SELECT
	a.*,
    CASE 
        WHEN days_for_completion = 0 then "Same day"
        WHEN days_for_completion BETWEEN 1 AND 7 THEN '1 to 7 days'
        WHEN days_for_completion BETWEEN 8 AND 30 THEN '8 to 30 days'
        WHEN days_for_completion BETWEEN 31 AND 60 THEN '31 to 60 days'
        WHEN days_for_completion BETWEEN 61 AND 90 THEN '61 to 90 days'
        WHEN days_for_completion BETWEEN 91 AND 365 THEN '91 to 365 days'
        WHEN days_for_completion >= 366 THEN '366+ days'
    END AS complete_bucket    
FROM 
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
````
### Results

<img width="744" alt="Image" src="https://github.com/user-attachments/assets/da47e85a-897a-4afd-b83e-1b39a8306dd0" />


Export the table as csv. file for further analyzing in Tableau 

<img width="718" alt="Image" src="https://github.com/user-attachments/assets/6e90a1b4-2c54-4579-a592-eec79c35b7bc" />

## Analyzing process and outcome

<img width="1363" alt="Image" src="https://github.com/user-attachments/assets/c6ba43b9-a361-4136-8f0c-3b91ed9a1072" />

- Studying the height of the bars, we observe a fluctuating number of people enrolling monthly (roughly 800 and 1,200), with August registering a higher number. The reason is a campaign that 365 ran for three days which gave all its students free access to the platform. We can see that this has both boosted the number of enrollments and, as a result, the completion rate. Still, most people enrolled in this period seem to have started the track but have given up once the free days ended.
- When considering the number of enrolled students per track, the data analyst career track is the most sought after among 365 students, followed by the data science track and, finally, the business analyst one.
- Studying the line part of the combo chart, we see the numbers fluctuating. But the passing rate (around 2%) is relatively low, with numbers varying between tracks. Therefore, it’s difficult to state any dependency with time—i.e., we can’t conclude with certainty the completion rate increases, decreases, or stays constant.
- We can argue, that students need a lot of time to complete an entire career track. This claim is supported by the second bar chart created in the project, where we’ve seen that it takes students an annual subscription to complete a single career track.
- Such an analysis should therefore be conducted for long periods. The SQL database shows that the last completion date recorded is May 16, 2023. If we assume that it takes roughly a year for students to complete a track, then people registered towards the end of the period under analysis have yet to complete theirs.
- Given the relatively low success rate of 2% in completing a career track, we can appreciate how much effort, engagement, and persistence it requires to complete one. Students need to complete nine courses, pass nine course exams, and the career track itself—encompassing topics from all seven compulsory courses entering the track. We understand that this can make students feel overwhelmed and discouraged.
- The company put much effort into engaging their students and helping them reach their goals. We launched a gamified version of the platform, which allows for maintaining streaks and, as a reward, claiming great prizes. Students are also encouraged to participate in the News Feed option of the platform, share their thoughts and learning progress, and seek help from instructors and fellow students in the Q&A hub.

