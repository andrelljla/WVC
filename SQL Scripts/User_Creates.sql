select * from all_users;

drop user wvc;
create user wvc identified by wvc default tablespace users;
grant connect, create session, resource to wvc;

drop user jla;
create user jla identified by jla default tablespace users;
grant connect, create session, resource, dba to jla;


