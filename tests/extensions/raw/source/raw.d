import python.c;

import scalars: theAnswer;

extern(C):

export PyObject* PyInit_raw() {

    import core.runtime: rt_init;

    rt_init;

    static PyMethodDef[] methods;
    methods = [
        PyMethodDef("the_answer", &theAnswer, METH_VARARGS, "The answer to the ultimate question"),
        PyMethodDef(null, null, 0, null), // sentinel
    ];

    static PyModuleDef moduleDef;
    moduleDef = PyModuleDef(
        PyModuleDef_Base(),
        "raw",
        null, // doc
        -1, // global state
        &methods[0],
    );


    return PyModule_Create(&moduleDef);
}
