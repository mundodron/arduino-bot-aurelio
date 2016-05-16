
        EXEC SQL BEGIN DECLARE SECTION;
      struct sqlca     sqlca;
      GVT_SUMMARY_ZERO_ALLOWED record;
    EXEC SQL END DECLARE SECTION;
    GVT_SUMMARY_ZERO_ALLOWED *record_node;
    
    INIT_RB( &GvtSummaryZero );

    EXEC SQL CONTEXT USE :CONNECTION->ctx;

    EXEC SQL AT :CONNECTION->db_name DECLARE load_gvt_summary_zero_allowed CURSOR for
            SELECT type_id, element_id, component_id
                FROM GVT_SUMMARY_ZERO_ALLOWED
                WHERE inactive_dt is null;

    EXEC SQL AT :CONNECTION->db_name OPEN load_gvt_summary_zero_allowed;
    if ( sql_error( "opening cursor load_gvt_summary_zero_allowed...", sqlca, CONNECTION->ctx ) != SUCCESS )
      {
        EXEC SQL AT :CONNECTION->db_name CLOSE load_gvt_summary_zero_allowed;
        return( FAILURE );
      }

    EXEC SQL AT :CONNECTION->db_name FETCH load_gvt_summary_zero_allowed
      INTO :record.type_id, :record.element_id, :record.component_id;
    if ( sql_error( "fetching cursor load_gvt_summary_zero_allowed...", sqlca, CONNECTION->ctx ) != SUCCESS )
      {
        EXEC SQL AT :CONNECTION->db_name CLOSE load_gvt_summary_zero_allowed;
        return( FAILURE );
      }

    while ( sqlca.sqlcode == 0 )
      {
        ADD_TO_RB_TREE( GVT_SUMMARY_ZERO_ALLOWED, &GvtSummaryZero, &record, record_node, fcmp_gvt_summary_zero );

        EXEC SQL AT :CONNECTION->db_name FETCH load_gvt_summary_zero_allowed
          INTO :record.type_id, :record.element_id, :record.component_id;
        if ( sql_error( "fetching cursor load_gvt_summary_zero_allowed...", sqlca, CONNECTION->ctx ) != SUCCESS )
          {
            EXEC SQL AT :CONNECTION->db_name CLOSE load_gvt_summary_zero_allowed;
            return( FAILURE );
          }
      }

    EXEC SQL AT :CONNECTION->db_name CLOSE load_gvt_summary_zero_allowed;
    if ( sql_error( "closing cursor load_gvt_summary_zero_allowed...", sqlca, CONNECTION->ctx ) != SUCCESS )
      return( FAILURE );

    return( SUCCESS );
}