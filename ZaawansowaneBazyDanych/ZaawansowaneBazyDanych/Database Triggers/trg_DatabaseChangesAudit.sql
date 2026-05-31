
create trigger trg_DatabaseChangesAudit
on database
for create_table, alter_table, drop_table
as
begin
    set nocount on;
    insert into dbo.DatabaseAuditLog (EventXML)
    values (EVENTDATA());
end;