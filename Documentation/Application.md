Application
================
This table is used to represent an application to a possible project. This table represents a candidature to a project a project that it is not approved yet. This table is the table used in the relationship many-to-many group to project, is the table needed when there is a relationship many-to-many. A group can have many applications to a project but a an application can only be made by a group.

Attributes in this table are:
>-**groupid INT(11)** - Foreign key of table group this foreign key represents the group that made the application.
>-**projectid INT(11)** - Foreign key of table project this foreign key represents the project that is associated with the application.
>-**submittedin TIMESTAMP** - Represents a temporal a mark that determines when the application was submitted.
>-**approvedin TIMESTAMP**- Represents a temporal mark that determines if the project was approved by the regent teacher and when.