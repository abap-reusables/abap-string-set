class ltcl_string_set definition
  for testing
  risk level harmless
  duration short
  final.

  private section.
    methods add_delete_has_size for testing.
    methods clike_values for testing.
    methods string_range for testing.
    methods integer_range for testing.
    methods conversion_error for testing.
endclass.

class ltcl_string_set implementation.

  method add_delete_has_size.
    data lo_set type ref to zcl_abap_string_set.
    lo_set = zcl_abap_string_set=>create( ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_set->size( )
      exp = 0 ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_set->has( 'missing' )
      exp = abap_false ).
    lo_set->add( 'b' )->add( 'a' )->add( 'a' )->add( 'A' )->add( '' ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_set->size( )
      exp = 4 ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_set->has( 'a' )
      exp = abap_true ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_set->has( '' )
      exp = abap_true ).
    lo_set->delete( 'missing' ).
    lo_set->delete( 'a' ).
    lo_set->delete( 'a' ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_set->size( )
      exp = 3 ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_set->has( 'a' )
      exp = abap_false ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_set->has( 'A' )
      exp = abap_true ).
    lo_set->delete( '' ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_set->has( '' )
      exp = abap_false ).
  endmethod.

  method clike_values.
    data lo_set type ref to zcl_abap_string_set.
    data lv_char type c length 5 value 'abc'.
    data lv_numc type n length 3 value '012'.
    lo_set = zcl_abap_string_set=>create( ).
    lo_set->add( lv_char )->add( 'abc' )->add( lv_numc ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_set->size( )
      exp = 2 ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_set->has( lv_char )
      exp = abap_true ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_set->has( '012' )
      exp = abap_true ).
    lo_set->delete( lv_numc ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_set->size( )
      exp = 1 ).
  endmethod.

  method string_range.
    data lo_set type ref to zcl_abap_string_set.
    data lt_range type range of string.
    data lt_expected like lt_range.
    data ls_row like line of lt_range.
    lo_set = zcl_abap_string_set=>create( ).
    ls_row-sign = 'E'.
    ls_row-option = 'EQ'.
    ls_row-low = 'existing'.
    append ls_row to lt_range.
    append ls_row to lt_expected.
    lo_set->to_range( changing ct_range = lt_range ).
    cl_abap_unit_assert=>assert_equals(
      act = lt_range
      exp = lt_expected ).
    lo_set->add( 'b' )->add( 'a' )->add( 'a' )->add( '' ).
    clear ls_row.
    ls_row-sign = 'I'.
    ls_row-option = 'EQ'.
    append ls_row to lt_expected.
    ls_row-low = 'a'.
    append ls_row to lt_expected.
    ls_row-low = 'b'.
    append ls_row to lt_expected.
    lo_set->to_range( changing ct_range = lt_range ).
    cl_abap_unit_assert=>assert_equals(
      act = lt_range
      exp = lt_expected ).
  endmethod.

  method integer_range.
    data lo_set type ref to zcl_abap_string_set.
    data lt_range type range of i.
    data lt_expected like lt_range.
    data ls_row like line of lt_range.
    lo_set = zcl_abap_string_set=>create( ).
    lo_set->add( '20' )->add( '-1' ).
    ls_row-sign = 'I'.
    ls_row-option = 'EQ'.
    ls_row-low = -1.
    append ls_row to lt_expected.
    ls_row-low = 20.
    append ls_row to lt_expected.
    lo_set->to_range( changing ct_range = lt_range ).
    cl_abap_unit_assert=>assert_equals(
      act = lt_range
      exp = lt_expected ).
  endmethod.

  method conversion_error.
    data lo_set type ref to zcl_abap_string_set.
    data lt_range type range of i.
    data lt_expected like lt_range.
    data ls_row like line of lt_range.
    data lx_error type ref to cx_no_check.
    lo_set = zcl_abap_string_set=>create( ).
    lo_set->add( '1' )->add( 'bad' ).
    ls_row-sign = 'I'.
    ls_row-option = 'EQ'.
    ls_row-low = 7.
    append ls_row to lt_range.
    lt_expected = lt_range.
    try.
      lo_set->to_range( changing ct_range = lt_range ).
      cl_abap_unit_assert=>fail( ).
    catch cx_no_check into lx_error.
      cl_abap_unit_assert=>assert_char_cp(
        act = lx_error->get_text( )
        exp = '*Cannot convert set value*' ).
    endtry.
    cl_abap_unit_assert=>assert_equals(
      act = lt_range
      exp = lt_expected ).
  endmethod.

endclass.
