# vbExtra:
It is a component for Visual Basic 6 with extra objects, controls and functions.

Program URL: vbforums.com/showthread.php?865299


# Working with the source code:

"vbExtra (subclassing inside).vbp" and "vbExtra (subclassing outside).vbp", why two project files?

The ocx in the "bin" folder is compiled from "vbExtra (subclassing inside).vbp".
That ocx has no other dependency (it doesn't need any other file to work, beside of course the normal files that are already on Windows and the VB6 runtime).
But when working with the source code or when compiling the ocx, it is necessary to reference the typelib vbExTyp.tlb that is in the lib folder. This is not necessary in the client program.

The project "vbExtra (subclassing outside).vbp" is provided for development purposes, because while working on the component it is difficult when having the subclassing code within the same project in which we are working or debugging.
It needs a DLL, that is in the \Bin\ folder, named vbExSc1.dll.
If you compile the ocx from this project file [vbExtra (subclassing outside).vbp], then you'll need to also include that dependency file in your package.
But anyone that want to do changes or further development on the component can use the "vbExtra (subclassing outside).vbp" project for doing all the work, and once it is finished then use the "vbExtra (subclassing inside).vbp" to compile the final ocx.
Do not forget, if you added or removed files from the project (or changed their names), to manually edit and update the other vbp file accordingly.


# First release: 08/13/2018
