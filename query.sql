SELECT
I.Name,
I.Alias,
G.Name,
ISNULL(I.D2,0),
ISNULL(I.D3,0),
ISNULL(I.D4,0),
ISNULL(I.D9,0),
ISNULL(SQ.StockQty,0)+ISNULL(OV.OpenQty,0)
FROM BusyComp0002_db12026.dbo.Master1 I
LEFT JOIN BusyComp0002_db12026.dbo.Master1 G ON I.ParentGrp=G.Code AND G.MasterType=5

LEFT JOIN (
SELECT T4.MasterCode1,SUM(T4.D1) AS OpenQty
FROM BusyComp0002_db12026.dbo.Tran4 T4
GROUP BY T4.MasterCode1
) OV ON OV.MasterCode1=I.Code

LEFT JOIN (
SELECT T2.MasterCode1,
SUM(CASE WHEN T2.TranType IN (0,1,3,4,5) THEN T2.D1 ELSE -T2.D1 END) AS StockQty
FROM BusyComp0002_db12026.dbo.Tran2 T2
GROUP BY T2.MasterCode1
) SQ ON SQ.MasterCode1=I.Code

WHERE I.MasterType=6

UNION

SELECT
I.Name,
I.Alias,
G.Name,
ISNULL(I.D2,0),
ISNULL(I.D3,0),
ISNULL(I.D4,0),
ISNULL(I.D9,0),
0
FROM BusyComp0002_db12025.dbo.Master1 I
LEFT JOIN BusyComp0002_db12025.dbo.Master1 G ON I.ParentGrp=G.Code AND G.MasterType=5
WHERE I.MasterType=6
AND I.Code NOT IN (
SELECT Code FROM BusyComp0002_db12026.dbo.Master1 WHERE MasterType=6
)

ORDER BY I.Name;
