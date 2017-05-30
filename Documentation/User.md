User
========================
Table user identifies a single user, this table is used to store every details needed for a user description. 

Attributes used in table user:
>-**id INT(11)** - Id is the key used to identify a single user. It is an integer between commonly know as a number between 0 and 2147483647.
>- **name VARCHAR(255)** - Name of user the real user name. It can't be null name of user is needed.
>- **photo VARCHAR(255)** - This varchar(255) is used to store an Url to a photo of the user owner.
>- **external_id VARCHAR(255)** - This variable is a key to an external_id used in the institution. It can internal institution key for a student or a teacher.
>- **typeid INT(11)** - Foreign key used as main key in table Type.
>- **email VARCHAR(255)** - Variable used to store user email fepx: santos@ipt.pt
>- **phonenumber VARCHAR(14)**- Variable used to store phone number like: (+351249881992)
>-**isadmin TINYINT(1)**- This variable is basically a TinyInt used as boolean used to store if current user is admin ou not.
>-**password VARCHAR(255)** - This Varchar of 255 characteres is used to store a password made by an hash function.
>-**locked TINYINT(1)** - This is variable tinyint used as a boolean is used to determine if a user is blocked or not. For example a user can be blocked for excess of incorrect password insert.
>-**active TINYINT(1)**- This variable is used in real time to determine if a user is active or not.