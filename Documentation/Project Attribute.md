Project Attribute
==============
The table project attribute is used to reference attributes used in the project things like files about the project, like scientific files, summary and project related files.
The attributes of this table are:
>-**projectid INT(11)**- This is a foreign key used to reference table project that a group of attributes are associated with.
>-**attributeid INT(11)**- This is foreign key to reference table Attribute.
>-**value VARCHAR(255)**- This table is used to store the value of the url that forms a link to the file that is the attribute.