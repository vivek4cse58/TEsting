
IF NOT EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID('PartsOrderSubstitueMapping') 
         AND name = 'IsActive'
)
Begin
alter table PartsOrderSubstitueMapping add IsActive bit
END


Insert into PartsOrderSubstitueMapping 
select Isnull(REQUESTED_PART_NO,Part_NO),QTY_ORDERED,pod.Id,'Datamigration_Sprint_103',Getutcdate(),
Case when Isnull(pod.status,'')<>'D' then 1 else 0 end
from PartsOrderDetail pod
inner join PartsOrderheader poh on pod.PartsOrderHeaderId=poh.Id
where Pending='Y' and Isnull(Part_NO,'')<>'' and 
not exists(select 1 from PartsOrderSubstitueMapping pos where pos.PartsOrderDetailId=pod.id)

/*
Added the commentliner at end
*/


