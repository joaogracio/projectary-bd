-- isAdmin --
DROP PROCEDURE IF EXISTS isAdmin;
DELIMITER $$
CREATE PROCEDURE isAdmin(IN id INT)
BEGIN
	SELECT u.isadmin FROM user u WHERE u.id = id;
END$$
DELIMITER ;

-- isteacher --
DROP PROCEDURE IF EXISTS isTeacher;
DELIMITER $$
CREATE PROCEDURE isTeacher(IN id INT)
BEGIN
	SELECT EXISTS(SELECT * FROM user u, type t WHERE u.id = id AND u.typeid = t.id AND t.`desc` LIKE "teacher");
END$$
DELIMITER ;

-- isStudent --
DROP PROCEDURE IF EXISTS isStudent;
DELIMITER $$
CREATE PROCEDURE isStudent(IN id INT)
BEGIN
	SELECT EXISTS(SELECT * FROM user u, type t WHERE u.id = id AND u.typeid = t.id AND t.`desc` LIKE "student");
END$$
DELIMITER ;

-- isInGroup --
DROP PROCEDURE IF EXISTS isInGroup;
DELIMITER $$
CREATE PROCEDURE isInGroup(IN userid INT, IN groupid INT)
BEGIN
	SELECT EXISTS(SELECT * FROM groupuser gu WHERE gu.userid = userid AND gu.groupid = groupid);
END$$
DELIMITER ;
