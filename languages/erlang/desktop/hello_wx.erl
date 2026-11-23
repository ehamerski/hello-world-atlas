%% hello_wx.erl - Erlang desktop: open a window that shows "Hello, World!".
%%
%% Build it with ./build.sh, run it with ./run.sh (both explain each step).
%% By hand (from desktop/):
%%   erlc -o ebin hello_wx.erl
%%   erl -noshell -pa ebin -s hello_wx main -s init stop
%%
%% The window is drawn by wx, the Erlang binding to wxWidgets, a C++ GUI
%% toolkit that uses the native windows of each operating system (Cocoa on
%% macOS). wx ships with Erlang/OTP, so, unlike Flask in ../../python/web,
%% nothing is downloaded. Compare the Python tkinter version in
%% ../../python/desktop/hello.py: there, one call (mainloop) runs the event
%% loop. In Erlang the program IS the loop: a process that receives messages.

%% -module must be the file name without ".erl". The compiler checks it.
-module(hello_wx).
%% Only main/0 is exported: it is the function that run.sh calls.
-export([main/0]).
%% wx.hrl is a header file with the constants and records of wx (for
%% example ?wxID_ANY and the #wx{} record). -include_lib finds it inside the
%% installed "wx" application, like #include <...> in C.
-include_lib("wx/include/wx.hrl").

%% main/0 creates the window, then waits. "main() ->" means no arguments.
main() ->
    %% wx:new() starts the wx server (a process that talks to wxWidgets) and
    %% returns a reference to it. "Wx = ..." binds the variable Wx. Erlang has
    %% no assignment: a variable is bound once, and Wx = other would fail.
    Wx = wx:new(),
    %% wxFrame:new/3 creates a top-level window. ?wxID_ANY (a macro from
    %% wx.hrl) means "I do not care about the window's number". The third
    %% argument is the title in the title bar. A double-quoted "..." is a
    %% list of characters; Erlang has no separate string type.
    Frame = wxFrame:new(Wx, ?wxID_ANY, "Hello, World!"),
    %% A wxStaticText is a label: text that the user cannot edit.
    Text = wxStaticText:new(Frame, ?wxID_ANY, "Hello, World!"),
    %% A sizer is an object that lays out the widgets of a window. A
    %% vertical box sizer stacks them; here it holds only the label.
    %% A stretch spacer is an empty item that grows to take the free space.
    %% One above and one below the label put it in the middle; the flag
    %% ?wxALIGN_CENTER_HORIZONTAL centers it from side to side. The options
    %% are a list of {Key, Value} tuples. Tuples use curly braces {A, B};
    %% lists use square brackets.
    Sizer = wxBoxSizer:new(?wxVERTICAL),
    wxSizer:addStretchSpacer(Sizer),
    wxSizer:add(Sizer, Text, [{flag, ?wxALIGN_CENTER_HORIZONTAL}]),
    wxSizer:addStretchSpacer(Sizer),
    %% Give the sizer to the window, then set the size of the window's
    %% inner area in pixels (width, height).
    wxWindow:setSizer(Frame, Sizer),
    wxWindow:setClientSize(Frame, 320, 120),
    %% close_window is the event that the close button sends. By default
    %% wx sends it to THIS process as a message, which the loop below reads.
    %% connect/2 does not close anything by itself; the loop decides.
    wxFrame:connect(Frame, close_window),
    %% show/1 makes the window visible.
    wxFrame:show(Frame),
    %% Self-check used by ./run.sh --verify and scripts/verify-all.sh: with
    %% TF_VERIFY=1 the program prints the text and sends itself the message
    %% 'verify_done' after 2000 ms. os:getenv/1 returns false when the
    %% variable is not set, so a reader running ./run.sh never sees this.
    case os:getenv("TF_VERIFY") of
        "1" ->
            io:format("Hello, World!~n"),
            erlang:send_after(2000, self(), verify_done);
        _ ->
            ok
    end,
    loop(Frame),
    %% After the loop ends, wx:destroy/0 stops the wx server. The VM can
    %% then end: run.sh calls init:stop() next.
    wx:destroy().

%% loop/1 waits for a message. "receive" takes the first message in this
%% process's mailbox that matches one of the patterns below. Patterns are
%% how Erlang chooses what to do, instead of an if or a switch.
loop(Frame) ->
    receive
        %% A wx event arrives as the record #wx{...}. The pattern matches
        %% it when the event inside is #wxClose{}, that is, when the user
        %% pressed the close button.
        #wx{event = #wxClose{}} ->
            wxWindow:destroy(Frame);
        %% The atom sent by send_after in verify mode.
        verify_done ->
            wxWindow:destroy(Frame);
        %% Any other message (for example a mouse move that wx forwards)
        %% is ignored: "_" matches anything. The function then calls itself,
        %% which is how Erlang repeats; there is no while loop, and the last
        %% call does not grow the stack ("tail call").
        _Other ->
            loop(Frame)
    end.
