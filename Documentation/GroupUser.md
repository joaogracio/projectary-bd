GroupUser
============
This table is used to make the relationship between table group and user. A user can bee signed in many groups and a group can have many users, so this is the table used for this relationship.

Attributes used in this table are:
>-**Group id INT(11)** - This is variable is a foreign key to reference the table **Group**. 
>-**User id INT(11)** - This is variable is a userid to reference the table **User**.
>-**Grade Decimal(10,0)** - Variable used to store the grade of witch of the group, it is basically a classification of witch user.
>-**approvedin TIMESTAMP**- Determines when this user was approved in the group.