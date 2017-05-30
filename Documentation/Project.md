Project
=============
The reason why all this projectary's project exists. The project is what is all about. 

Attributes of this table are:
>-**id INT(11)** - This is the key of table project it identifies each entry in table.
>-**approvedin TIMESTAMP**- Temporal variable to determine either the project was accepted or not, and if accepted when it was accepted.
>-**year YEAR**- Temporal variable to associate a year to a project . A project must have an unique year.
>-**courseid INT(11)**- This is a foreign key to table course this is used to represent the relationship many to one, a project have a course and a course can have many projects. 
>-**name VARCHAR(255)**- The name of the project variable used to associate a name to a given project.
>-**description VARCHAR(255)**- This field is used to add some description to a project. For example: scientific areas involved in the project, a general summary of the project, etc.
>-**userid INT(11)**- 
>-**created TIMESTAMP**- Temporal variable is used as a stamp to determine when the project was created.