Course
===========
Table course is used to characterize to witch course the project is related with. Witch course have a course year that it is related with in order to characterize the year the course was being taught.
Attributes used in this table:
>-**id INT(11)**- This is the key to this table.
>**desc VARCHAR(255)**- This varchar variable is used to insert the name of the course.
>-**schoolid INT(11)**- This is the foreign key used to reference table School about a relationship: course (many-to-one) school.