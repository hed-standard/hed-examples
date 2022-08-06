# HED JavaScript tools

The JavaScript code for HED validation is in the validation directory of the 
`hed-javascript` repository located at [https://github.com/hed-standard/hed-javascript](https://github.com/hed-standard/hed-javascript).

## Javascript tool installation

You can install the validator using `npm`:

    npm install hed-validator

## Javascript package organization

This package contains two sub-packages.  

`hedValidator.validator` validates HED strings and contains the functions:  

> `buildSchema` imports a HED schema and returns a JavaScript Promise object.  
> `validateHedString` validates a single HED string using the returned schema object.  

`hedValidator.converter` converts HED strings between short and long forms 
and contains the following functions:  

>`buildSchema` behaves similarly to the `buildSchema` function in `hedValidator.validator` 
except that it does not work with attributes.  

> `convertHedStringToShort` converts HED strings from long form to short form.  

> `convertHedStringToLong` converts HED strings from short form to long form.  

## Javascript programmatic interface

The programmatic interface to the HED JavaScript `buildSchema` must be modified to accommodate
a base HED schema and arbitrary library schemas.  The BIDS validator will require
additional changes to locate the relevant HED schemas from the specification given by
`"HEDVersion"` in `dataset_description.json`. 

The programmatic interface is similar to the JSON specification of the proposed 
BIDS implementation except that the `"fileName"` key has been replaced by a `"path"`
key to emphasize that callers must replace filenames with full paths before calling
`buildSchema`. 

````{admonition} **Example:** JSON passed to buildSchema.

```json
{
    "path": "/data/wonderful/code/mylocal.xml",
    "libraries": {
        "la": {
            "libraryName": "libraryA",
            "version": "1.0.2"
        },
        "lb": {
            "libraryName": "libraryB",
            "path": "/data/wonderful/code/HED_libraryB_0.5.3.xml"
        }
    }
}
```
````

**NOTE:** This interface is proposed and is awaiting resolution of BIDS PR #820 on file passing to BIDS.
