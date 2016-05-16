FUNCTION get_motivo(motivo IN varchar2) 
   RETURN char 
   IS ativo char);
   BEGIN 
     SELECT ATIVO
       INTO ativo 
       FROM grc_motivos_de_para gr 
      WHERE gr.motivo_grc = motivo
     RETURN(ativo); 
    END;
/

select ATIVO from grc_motivos_de_para where motivo_grc = '361'