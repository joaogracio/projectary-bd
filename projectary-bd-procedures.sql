-- ----------------- --
-- STORED PROCEDURES --
-- ----------------- --

-- isAdmin --
DROP PROCEDURE IF EXISTS isAdmin;
DELIMITER $$
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

-- listCouses --
DROP PROCEDURE IF EXISTS listCouses;
DELIMITER $$
CREATE PROCEDURE listCouses (IN schoolid INT)
BEGIN
	SELECT c.`desc` as 'course' FROM course c WHERE c.schoolid = schoolid;
END$$
DELIMITER ;

-- listSchools --
DROP PROCEDURE IF EXISTS listSchools;
DELIMITER $$
CREATE PROCEDURE listSchools ()
BEGIN
	SELECT s.`desc` as 'school' FROM school s;
END$$
DELIMITER ;

-- listApplications --
DROP PROCEDURE IF EXISTS listApplications;
DELIMITER $$
CREATE PROCEDURE listApplications (IN userid INT, IN projectid INT, IN approved INT)
BEGIN
	CALL isAdmin(userid, @isAdmin);
    IF (@isAdmin = TRUE) THEN
		CASE
			WHEN approved = 0 THEN
				IF (projectid > 0) THEN
					SELECT a.groupid, a.submitedin, a.approvedin FROM application a WHERE a.projectid = projectid AND YEAR(a.approvedin) = 0000;
				ELSE
					SELECT a.groupid, a.projectid, a.submitedin, a.approvedin FROM application a WHERE YEAR(a.approvedin) = 0000;
				END IF;
			WHEN approved = 1 THEN
				IF (projectid > 0) THEN
					SELECT a.groupid, a.submitedin, a.approvedin FROM application a WHERE a.projectid = projectid AND YEAR(a.approvedin) != 0000;
				ELSE
					SELECT a.groupid, a.projectid, a.submitedin, a.approvedin FROM application a WHERE YEAR(a.approvedin) != 0000;
				END IF;			
		END CASE;
	END IF;
END$$
DELIMITER ;

-- insertNewCourse --
DROP PROCEDURE IF EXISTS insertNewCourse;
DELIMITER $$
CREATE PROCEDURE insertNewCourse (IN schoolid INT, IN description VARCHAR(255))
BEGIN
	INSERT INTO course (schoolid, `desc`)
		VALUES (schoolid, description);
END$$
DELIMITER ;

-- insertNewType --
DROP PROCEDURE IF EXISTS insertNewType;
DELIMITER $$
CREATE PROCEDURE insertNewType (IN description VARCHAR(255))
BEGIN
	INSERT INTO type (`desc`)
		VALUES (description);
END$$
DELIMITER ;

-- insertNewProject --
DROP PROCEDURE IF EXISTS insertNewProject;
DELIMITER $$
CREATE PROCEDURE insertNewProject (IN schoolyear YEAR, IN courseid INT, IN name VARCHAR(255), IN description VARCHAR(255), IN userid INT)
BEGIN
	CALL isTeacher (userid, @teacher);
    IF (@teacher = 1) THEN
		INSERT INTO project (approvedin, year, courseid, name, description, userid, created)
			VALUES (NOW(), schoolyear, courseid, name, description, userid, NOW());
	ELSE
		INSERT INTO project (year, courseid, name, description, userid, created)
			VALUES (schoolyear, courseid, name, description, userid, NOW());
	END IF;
END$$
DELIMITER ;

-- listProjects --
DROP PROCEDURE IF EXISTS listProjects;
DELIMITER $$
CREATE PROCEDURE listProjects (IN courseid INT, IN schoolyear YEAR, IN approved INT)
BEGIN
	CASE
		WHEN approved = 0 THEN
				SELECT * FROM project p WHERE p.courseid = courseid AND p.year = schoolyear AND YEAR(p.approvedin) IS NULL;
		WHEN approved = 1 THEN
				SELECT * FROM project p WHERE p.courseid = courseid AND p.year = schoolyear AND YEAR(p.approvedin) IS NOT NULL;
	END CASE;
END$$
DELIMITER ;

-- descExists --
DROP PROCEDURE IF EXISTS descExists;
DELIMITER $$
CREATE PROCEDURE descExists(IN description VARCHAR(255), OUT state BOOL)
BEGIN
	SET state = FALSE;
    IF (SELECT EXISTS(SELECT * FROM `group` g WHERE g.`desc` like description)) THEN
			SET state = TRUE;
	END IF;
END$$
DELIMITER ;

-- editGroup --
DROP PROCEDURE IF EXISTS editGroup;
DELIMITER $$
CREATE PROCEDURE editGroup(IN userid INT, IN groupid INT, IN description VARCHAR(255), pass VARCHAR(255), OUT state BOOL)
BEGIN
	SET state = FALSE;
    CALL isAdmin(userid, @isAdmin);
    IF (@isAdmin = TRUE) THEN
		CALL descExists(description, @descExists);
        IF (@descExists = FALSE) THEN
			IF (SELECT EXISTS(SELECT * FROM `group` g WHERE g.id = groupid)) THEN
				UPDATE `group` SET `desc` = description, `password` = pass
					WHERE `group`.id = groupid;
				SET state = TRUE;
			END IF;
		END IF;
	END IF;
END$$
DELIMITER ;

-- deleteGroup --
DROP PROCEDURE IF EXISTS deleteGroup;
DELIMITER $$
CREATE PROCEDURE deleteGroup(IN userid INT, IN groupid INT, OUT state BOOL)
BEGIN
	SET state = FALSE;
    CALL isAdmin(userid, @isAdmin);
    IF (@isAdmin = TRUE) THEN
        IF (SELECT EXISTS(SELECT * FROM `group` g WHERE g.id = groupid)) THEN
			DELETE FROM `group` WHERE `group`.id = groupid;
			SET state = TRUE;
		END IF;
	END IF;
END$$
DELIMITER ;

-- listGroups --
DROP PROCEDURE IF EXISTS listGroups;
DELIMITER $$
CREATE PROCEDURE listGroups(IN userid INT)
BEGIN
    CALL isAdmin(userid, @isAdmin);
    IF (@isAdmin = TRUE) THEN
		SELECT g.id, g.`desc`, g.`password` FROM `group` g;
	END IF;
END$$
DELIMITER ;

-- listGroupDetails --
DROP PROCEDURE IF EXISTS listGroupDetails;
DELIMITER $$
CREATE PROCEDURE listGroupDetails (IN userid INT, IN groupid INT)
BEGIN
    CALL isAdmin(userid, @isAdmin);
    IF (@isAdmin = TRUE) THEN
		IF (SELECT EXISTS(SELECT * FROM `group` g WHERE g.id = groupid)) THEN
			SELECT g.`desc`, u.id, u.`name` FROM `group` g, groupuser gu, `user` u WHERE g.id = groupid AND g.id = gu.groupid AND u.id = gu.userid;
		END IF;
	END IF;
END$$
DELIMITER ;
