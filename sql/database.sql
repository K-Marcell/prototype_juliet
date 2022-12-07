/*
 TABLE NAME:
 user_data:
 column names:
 userid : long
 username : text
 userpassword : long
 useremail : text
 userverified : bool
 PK: userprofile - userid+useremail
 userpassword encryption: ARGON2
 */
--REQUIRED
CREATE DATABASE prototype_a DEFAULT CHARACTER SET 'utf8';

USE prototype_a;

/*user data*/
CREATE TABLE user_data(
  userid BIGINT NOT NULL,
  username VARCHAR(32) NOT NULL,
  userpassword VARCHAR(32) NOT NULL,
  useremail VARCHAR(64) NOT NULL,
  userverified BOOLEAN NOT NULL,
  userprofimg VARCHAR(255) NOT NULL,
  CONSTRAINT userprofile PRIMARY KEY (userid, useremail)
);

/*server data*/
CREATE TABLE server_data(
  serverid BIGINT NOT NULL,
  servername VARCHAR(32) NOT NULL,
  serverimage VARCHAR(255) NOT NULL,
  ownerid BIGINT NOT NULL,
  CONSTRAINT serverdifferentiator PRIMARY KEY(serverid)
);

/*channel data*/
CREATE TABLE server_channel_data(
  serverid BIGINT NOT NULL,
  channelid BIGINT NOT NULL,
  channelname VARCHAR(32) NOT NULL,
  CONSTRAINT channeldifferentiator PRIMARY KEY(channelid)
);

/*message data*/
CREATE TABLE channel_message_data(
  channelid BIGINT NOT NULL,
  messageid BIGINT NOT NULL,
  messageidauthor BIGINT NOT NULL,
  messagecontent TEXT NOT NULL,
  messageattachment TEXT,
  CONSTRAINT messagedifferentiator PRIMARY KEY(messageid)
);

/*user creation template*/
INSERT INTO
  user_data(
    userid,
    username,
    userpassword,
    useremail,
    userverified,
    userprofimg
  )
VALUES
  (
    (
      SELECT
        MAX(userid)
      FROM
        user_data
    ) + 1,
    $ username,
    $ userpassword,
    $ useremail,
    false,
    $ userprofimg
  );

/*server creation template*/
INSERT INTO
  server_data(
    serverid,
    servername,
    serverimage,
    ownerid
  )
VALUES
  (
    (
      SELECT
        MAX(serverid)
      FROM
        server_data
    ) + 1,
    $ servername,
    $ serverimage,
    $ ownerid
  );

/*channel creation template*/
INSERT INTO
  server_channel_data(
    serverid,
    channelid,
    channelname
  )
VALUES
  (
    $ serverid,
    (
      SELECT
        MAX(channelid)
      FROM
        server_channel_data
    ) + 1,
    $ channelname
  );

/*message creation template*/
INSERT INTO
  channel_message_data(
    channelid,
    messageid,
    messageidauthor,
    messagecontent,
    messageattachment
  )
VALUES
  (
    $ channelid,
    (
      SELECT
        MAX(messageid)
      FROM
        channel_message_data
    ) + 1,
    $ messageauthor,
    $ messagecontent,
    $ messageattachment
  );