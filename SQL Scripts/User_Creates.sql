select * from all_users;

drop user wvc cascade;
create user wvc identified by wvc default tablespace users;
grant connect, create session, resource, create table, create view, create procedure, create trigger to wvc;

drop user jla cascade;
create user jla identified by jla default tablespace users;
grant connect, create session, resource, dba to jla;