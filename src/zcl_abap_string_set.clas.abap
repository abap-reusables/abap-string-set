class zcl_abap_string_set definition
  public
  final
  create public.

  public section.

    constants version type string value 'v1.0.0'.
    constants origin type string value 'https://github.com/abap-reusables/abap-string-set'.
    constants license type string value 'MIT'.

    class-methods create
      returning
        value(ro_instance) type ref to zcl_abap_string_set.
    methods add
      importing
        iv_value type clike
      returning
        value(ro_instance) type ref to zcl_abap_string_set.
    methods delete
      importing
        iv_value type clike.
    methods has
      importing
        iv_value type clike
      returning
        value(rv_has) type abap_bool.
    methods size
      returning
        value(rv_size) type i.
    methods to_range
      changing
        ct_range type range.

  private section.
    data mt_values type sorted table of string with unique key table_line.
ENDCLASS.


CLASS ZCL_ABAP_STRING_SET IMPLEMENTATION.


  method create.
    create object ro_instance.
  endmethod.


  method add.
    data lv_value type string.
    lv_value = iv_value.
    insert lv_value into table mt_values.
    ro_instance = me.
  endmethod.


  method delete.
    data lv_value type string.
    lv_value = iv_value.
    delete table mt_values from lv_value.
  endmethod.


  method has.
    data lv_value type string.
    lv_value = iv_value.
    read table mt_values with table key table_line = lv_value transporting no fields.
    rv_has = boolc( sy-subrc = 0 ).
  endmethod.


  method size.
    rv_size = lines( mt_values ).
  endmethod.


  method to_range.

    data lr_result type ref to data.
    data lv_value type string.
    data lx_conversion type ref to cx_sy_conversion_error.
    field-symbols <result> type range.
    field-symbols <row> type any.
    field-symbols <sign> type ddsign.
    field-symbols <option> type ddoption.
    field-symbols <low> type any.

    " Build a copy so a failed conversion never leaves the caller's range half-filled.
    create data lr_result like ct_range.
    assign lr_result->* to <result>.
    <result> = ct_range.

    loop at mt_values into lv_value.
      append initial line to <result> assigning <row>.
      assign component 'SIGN' of structure <row> to <sign>.
      assign component 'OPTION' of structure <row> to <option>.
      assign component 'LOW' of structure <row> to <low>.
      <sign> = 'I'.
      <option> = 'EQ'.
      try.
        <low> = lv_value.
      catch cx_sy_conversion_error into lx_conversion.
        lcx_error=>raise( |Cannot convert set value to range LOW: { lx_conversion->get_text( ) }| ).
      endtry.
    endloop.

    ct_range = <result>.

  endmethod.
ENDCLASS.
