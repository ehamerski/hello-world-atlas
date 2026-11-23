-- hello.e - Eiffel cli: Hello, World!
--
-- WHAT: prints one line, Hello, World!, and stops.
-- WHY:  it shows the Eiffel class structure (class, create, feature) and
--       Design by Contract: the routine `say' states what its caller must
--       give it (require), and the query `greeting' states what it
--       promises back (ensure). Both are checked at run time only when
--       assertion monitoring is on; this folder's build does not monitor them.
--
-- Source for the keywords and the contract roles: ECMA-367, Eiffel:
-- Analysis, Design and Programming Language, 2nd edition, June 2006,
-- section 8.9 ("require" for preconditions, "ensure" for postconditions,
-- "invariant" for class invariants). https://www.ecma-international.org/publications-and-standards/standards/ecma-367
-- Unlike Java or Python, Eiffel has no `main` function: the `create`
-- clause names the creation routine `make`, which runs first.

class
    HELLO

create
    make

feature -- Initialization

    make
            -- Print the greeting.
        do
            say (greeting)
        end

feature -- Access

    greeting: STRING
            -- The text the program prints.
        do
            -- Result is the value that this routine returns.
            Result := "Hello, World!"
        ensure
            -- The postcondition comes after the body: it must hold on return.
            not_empty: not Result.is_empty
        end

feature -- Output

    say (a_text: STRING)
            -- Print `a_text' and then a new line.
        require
            -- The caller must pass a real string, not Void (no object).
            text_attached: a_text /= Void
        do
            -- io is a standard object from the Base library (STD_FILES).
            -- put_string writes the text; put_new_line ends the line.
            io.put_string (a_text)
            io.put_new_line
        end

end
