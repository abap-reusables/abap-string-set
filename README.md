# abap-string-set

String set primitive implementation in ABAP.

Originates from [sbcgua/abap-string-map#2](https://github.com/sbcgua/abap-string-map/issues/2).

## Overview

`zcl_abap_string_set` stores unique, case-sensitive string values. `add`, `delete` and `has` accept `clike` values; duplicate additions and deleting missing values are harmless. Empty strings are valid members. `add` supports method chaining and `size` counts distinct values.

```abap
data lo_set type ref to zcl_abap_string_set.
data lt_range type range of string.

lo_set = zcl_abap_string_set=>create( ).
lo_set->add( 'B' )->add( 'A' )->add( 'A' ).
lo_set->has( 'A' ). " => abap_true
lo_set->size( ).   " => 2

lo_set->to_range( changing ct_range = lt_range ).
" Appends I/EQ rows for A and B, with initial HIGH

lo_set->delete( 'A' ).
```

## Range Conversion

`to_range` accepts a standard range table with `SIGN` (type `DDSIGN`), `OPTION` (type `DDOPTION`) and elementary fields `LOW` and `HIGH`.

- Values are appended in string sort order with `SIGN = 'I'` and `OPTION = 'EQ'`.
- Uses standard ABAP assignment conversion to the target `LOW` type (e.g. `range of string`, `range of i`, etc.).
- Existing rows in the target table are preserved.
- Invalid range structures or failed conversions raise an exception (`cx_no_check`) without modifying the target table.

See the [string set unit tests](src/zcl_abap_string_set.clas.testclasses.abap) for typed ranges and error handling examples.

## License

MIT
