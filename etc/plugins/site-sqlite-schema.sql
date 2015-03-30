/**
    Below are the definitions of the tables used by
    Ado::Plugin::Site plugin.
**/
PRAGMA encoding = "UTF-8"; 

-- 'Sites managed by this system'
CREATE TABLE IF NOT EXISTS domains (
--  'Id referenced by pages that belong to this domain.'
  id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
--  'Domain name as in $ENV{HTTP_HOST}.'
  domain VARCHAR(63) UNIQUE NOT NULL, 
--  'The name of this site.'
  site_name VARCHAR(63) NOT NULL,
--  'Site description'
  description VARCHAR(255) NOT NULL DEFAULT '',
--   'User for which the permissions apply (owner).'
  owner_id INTEGER REFERENCES users(id),
--  'Group for which the permissions apply.'
  group_id INTEGER  REFERENCES groups(id),
--  'Domain permissions',
  permissions VARCHAR(10) NOT NULL DEFAULT '-rwxr-xr-x' ,
--  '0=not published, 1=for review, 2=published'
  published INT(1) NOT NULL DEFAULT 0
);
CREATE INDEX IF NOT EXISTS domains_published ON domains(published);


CREATE TABLE IF NOT EXISTS pages (
  id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  -- Parent page id
  pid int(11) NOT NULL DEFAULT '0',
  -- Refrerence to domain.id to which this page belongs.
  domain_id int(11) NOT NULL DEFAULT '0',
  -- Alias for the page which may be used instead of the id.
  alias varchar(32) NOT NULL DEFAULT '',
  -- 'regular','folder','root' etc.
  page_type varchar(32) NOT NULL,
  sorting int(11) NOT NULL DEFAULT '1',
  -- MT code to display this page. Default template is used if not specified.
  template text,
  -- 1=yes 0=no Note that only public pages are cacheable!
  cache tinyint(1) NOT NULL DEFAULT '0',
  -- expiry tstamp if cache==1
  expiry int(11) NOT NULL DEFAULT '86400',
  -- Page editing permissions.
  permissions varchar(10) NOT NULL DEFAULT '-rwxr-xr-xr',
  -- User for which the permissions apply (owner).
  user_id int(11),
  -- Group for which the permissions apply.
  group_id int(11) DEFAULT '1',
  tstamp int(11) NOT NULL DEFAULT '0',
  start int(11) NOT NULL DEFAULT '0',
  stop int(11) NOT NULL DEFAULT '0',
  -- 0=not published, 1=for review, 2=published
  published int(1) NOT NULL DEFAULT '0',
  -- Is this page hidden? 0=No, 1=Yes
  hidden tinyint(1) NOT NULL DEFAULT '1',
  -- Is this page deleted? 0=No, 1=Yes
  deleted tinyint(4) NOT NULL DEFAULT '0',
  -- Who modified this page the last time?
  changed_by int(11) NOT NULL,
  FOREIGN KEY (pid)       REFERENCES pages(id)   ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY (domain_id) REFERENCES domains(id) ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY (user_id)   REFERENCES users(id)   ON UPDATE CASCADE,
  FOREIGN KEY (group_id)  REFERENCES groups(id)  ON UPDATE CASCADE
);
CREATE UNIQUE INDEX IF NOT EXISTS pages_alias_in_domain_id ON pages(alias, domain_id);
CREATE INDEX IF NOT EXISTS pages_user_id_group_id ON pages(user_id, group_id);
CREATE INDEX IF NOT EXISTS pages_hidden ON pages(hidden);

/**
DROP TABLE IF EXISTS domains;
DROP TABLE IF EXISTS pages;

**/

