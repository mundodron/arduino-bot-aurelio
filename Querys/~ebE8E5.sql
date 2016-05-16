DECLARE 

  cnt NUMBER;

BEGIN

  SELECT COUNT(*)

   INTO cnt

    FROM mytable

  WHERE id = 12345;



  IF( cnt = 0 )

  THEN

    ...

  ELSE

    ...

  END IF;

END;