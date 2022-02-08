# llvm-cookbook

## Pain and suffering :)

Getting all of this setup to work was very painful. It required building LLVM from scratch multiple time. The first time 
failed because I built and installed 9.0.1, not 9.0.0, the second time failed due to missing includes in 
several files, the third time failed due to some ocamldocs missing, and the fourth time worked but still wasn't a 
success as it didn't actually build `libLLVM-9.0.so`, which is what I needed.

Here are the instructions for getting LLVM-9.0.0 set up so that you can use `llvm-hs` successfully:

## Instructions

1. go to the llvm downloads page [here](https://releases.llvm.org/download.html), download the source code archive for 9.0.0 __EXACTLY__.
2. Extract it somewhere and `cd` into the root directory. Create a directory (I called mine `builddir`).
3. `cd` into the directory you created. Once inside of this directory, execute `cmake -DLLVM_BUILD_LLVM_DYLIB=ON -DLLVM_LINK_LLVM_DYLIB=ON ../`.
4. Once this command is done, execute `cmake --build . --config Release`
5. This is the part where you need to fix some files. These are `../utils/benchmark/src/benchmark_register.cc` and `../utils/benchmark/src/benchmark_register.h`. All you need to do is add `#include <limits>` to their list of imports.
6. Make sure you have both enough storage (around 20-30gb) and enough memory (about 8-10gb). You can probably get away with less memory by using swap space.
7. Once it has built, issue this command to install the tools and libraries: `cmake --build . --config Release --target install`
8. You will get an error near the end of this process, it will mention `ocamldocs`. To fix this, go to `docs/cmake_install.cmake`, comment out the lines after 44, all of them.
9. Run the install command again. It _should_ work this time. But, if you try and build and run one of the examples, for instance, in llvm-hs-examples, you'll get linker errors. This is because the libraries were installed to `/usr/local/lib/...`. You need to make sure these can be found. Export a variable like so: `export LD_LIBRARY_PATH=/usr/local/lib/`.
10. At this point, everything _should_ work. You can build and run the examples in llvm-hs-examples. 
