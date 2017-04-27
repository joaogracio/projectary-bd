CREATE PROCEDURE isAdmin(IN id INT, OUT isAdmin BOOL)
BEGIN
	SET isAdmin = (SELECT u.isadmin FROM user u WHERE u.id = id);
END$$
DELIMITER ;


-- isteacher --
DROP PROCEDURE IF EXISTS isTeacher;
DELIMITER $$
CREATE PROCEDURE isTeacher(IN id INT, OUT isTeacher BOOL)
BEGIN
	SET isTeacher = (SELECT EXISTS(SELECT * FROM user u, type t WHERE u.id = id AND u.typeid = t.id AND t.`desc` LIKE "teacher"));
END$$
DELIMITER ;


-- isStudent --
DROP PROCEDURE IF EXISTS isStudent;
DELIMITER $$
CREATE PROCEDURE isStudent(IN id INT, OUT isStudent BOOL)
BEGIN
	SET isStudent = (SELECT EXISTS(SELECT * FROM user u, type t WHERE u.id = id AND u.typeid = t.id AND t.`desc` LIKE "student"));
END$$
DELIMITER ;


-- isInGroup --
DROP PROCEDURE IF EXISTS isInGroup;
DELIMITER $$
CREATE PROCEDURE isInGroup(IN userid INT, IN groupid INT, OUT isInGroup BOOL)
BEGIN
	SET isInGroup = (SELECT EXISTS(SELECT * FROM groupuser gu WHERE gu.userid = userid AND gu.groupid = groupid));
END$$
DELIMITER ;


-- isInProject --
DROP PROCEDURE IF EXISTS isInProject;
DELIMITER $$
CREATE PROCEDURE isInProject(IN userid INT, OUT isInProject BOOL)
BEGIN
	SET isInProject = (SELECT EXISTS(SELECT * FROM groupuser gu, application a WHERE gu.userid = userid AND gu.groupid = a.groupid AND YEAR(a.approvedin) != 0000));
END$$
DELIMITER ;


-- addToGroup --
DROP PROCEDURE IF EXISTS addToGroup;
DELIMITER $$
CREATE PROCEDURE addToGroup(IN userid INT, IN groupid INT, IN password VARCHAR(255), OUT state BOOL)
BEGIN
	SET state = FALSE;
	CALL isInProject(userid, @project);
	IF (@project = FALSE) THEN
		CALL isInGroup(userid, groupid, @isInGroup);
        IF (@isInGroup = FALSE) THEN
			IF (SELECT EXISTS(SELECT * FROM `group` g WHERE g.id = groupid AND g.password = password)) THEN
				INSERT INTO groupuser(groupid, userid)
					VALUES (groupid, userid);
                    SET state = TRUE;
			END IF;
		END IF;
	END IF;
END$$
DELIMITER ;


-- insertNewGroup --
DROP PROCEDURE IF EXISTS insertNewGroup;
DELIMITER $$
CREATE PROCEDURE insertNewGroup(IN userid INT, IN description VARCHAR(255), IN password VARCHAR(255), OUT groupid INT)
BEGIN
	CALL isInProject(userid, @project);
	IF (@project=FALSE) THEN
		INSERT INTO `group`(`desc`, password)
			VALUES (description, password);
		SET groupid = (SELECT g.id FROM `group` g WHERE g.`desc` = description AND g.password = password);
		INSERT INTO groupuser (groupid, userid)
			VALUES (groupid, userid);
	END IF;
END$$
DELIMITER ;

-- insertNewApplication --
DROP PROCEDURE IF EXISTS insertNewApplication;
DELIMITER $$
CREATE PROCEDURE insertNewApplication(IN userid INT, IN groupid INT, IN projectid INT, OUT state BOOL)
BEGIN
	SET state = FALSE;
	CALL isStudent(userid, @student);
	IF (@student = TRUE) THEN
		CALL isInGroup(userid, groupid, @isInGroup);
        IF (@isInGroup = TRUE) THEN
			CALL isInProject(userid, @project);
			IF (@project = FALSE) THEN
				IF (SELECT EXISTS(SELECT * FROM project p WHERE p.id = projectid AND p.approvedin IS NOT NULL)) THEN
					INSERT INTO application(groupid, projectid, submitedin)
						VALUES (groupid, projectid, NOW());
						SET state = TRUE;
				END IF;
			END IF;
		END IF;
	END IF;
END$$
DELIMITER ;
