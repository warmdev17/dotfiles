function build
    # Flags:
    #   -c : compile C (name.c)
    #   -p : compile C++ (name.cpp)
    #   -l : one or more libs after -l (e.g. -l m pthread)
    argparse c p 'l=+' -- $argv
    or begin
        echo "Usage: build -c|-p filename [-l lib1 lib2 ...]"
        return 1
    end

    # Determine file type
    set -l filetype ""
    if set -q _flag_c
        set filetype c
    else if set -q _flag_p
        set filetype cpp
    end
    if test -z "$filetype"
        echo "Please select -c (C) or -p (C++)"
        return 1
    end

    if test (count $argv) -lt 1
        echo "Usage: build -c|-p filename [-l lib1 lib2 ...]"
        return 1
    end
    set -l name $argv[1]
    set -l exe "$name" # output không có phần mở rộng

    set -l libs
    if set -q _flag_l
        for lib in $_flag_l
            set -a libs "-l$lib"
        end
    end

    function __run_exe --argument-names x
        if string match -rq '^/' -- "$x"
            # absolute path
            "$x"
        else
            # relative path
            "./$x"
        end
    end

    if test "$filetype" = c
        set -l src "$name.c"
        if not test -f "$src"
            echo "Source not found: $src"
            return 1
        end
        gcc "$src" -o "$exe" $libs -O2 -Wall
        or return $status
        and __run_exe "$exe"
    else if test "$filetype" = cpp
        set -l src "$name.cpp"
        if not test -f "$src"
            echo "Source not found: $src"
            return 1
        end
        g++ "$src" -o "$exe" $libs -O2 -Wall
        or return $status
        echo "Compiled $src -> $exe"
        and __run_exe "$exe"
    end
end
