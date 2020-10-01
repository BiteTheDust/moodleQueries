SELECT CourseName, 
		 DATE_FORMAT(CONVERT_TZ(FROM_UNIXTIME(enddate),'+00:00','-07:00'), '%a. %b %D %Y %r') AS End_Date_Time, ##Displays the enddate in our TZ
		 Visible, 
		 VisibleOld, 
		 EndDaysFromToday ##Days passed since enddate
FROM (
	SELECT c.id AS CourseID, 
			 c.fullname AS CourseName, 
			 c.category AS CategoryID, 
			 c.enddate AS EndDate, 
			 c.visible AS Visible, 
			 c.visibleold AS VisibleOld,
			 DATEDIFF(CONVERT_TZ(NOW(),'+00:00','-07:00'), CONVERT_TZ(FROM_UNIXTIME(c.enddate), '+00:00','-07:00')) AS EndDaysFromToday,
			 cc.name AS CourseCategoryName, 
			 cc.id AS CourseCategoryID
	FROM mdl_course AS c
	JOIN mdl_course_categories AS cc 
	ON c.category = cc.id AND (cc.id = 1 OR (cc.parent = 1 AND cc.id <> 11))) AS UniversityCourseList
WHERE Visible = 1 ##0 hidden, 1 shown
AND EndDaysFromToday = 90 ##Because if apart by 90 days, update
AND enddate != 0; ##Some courses just may have no enddate indicated in DB
