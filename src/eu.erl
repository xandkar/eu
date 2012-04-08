-module(eu).

-export(
    [
        os_cmd/1
    ]
).


%%%============================================================================
%%% API
%%%============================================================================

-spec os_cmd(string()) -> {integer(), iolist()}.

os_cmd(Command) ->
    PortOptions = [stream, exit_status, use_stdio, stderr_to_stdout, in, eof],
    PortID = open_port({spawn, Command}, PortOptions),
    get_port_exitcode_and_output(PortID, []).


%%%============================================================================
%%% Internal
%%%============================================================================

-spec get_port_exitcode_and_output(pid(), []) -> {integer(), iolist()}.

get_port_exitcode_and_output(PortID, DataAcc) ->
    receive
        {PortID, {data, Data}} ->
            get_port_exitcode_and_output(PortID, [Data|DataAcc]);

        {PortID, eof} ->
            port_close(PortID),
            receive
                {PortID, {exit_status, ExitCode}} ->
                    Output = lists:flatten(lists:reverse(DataAcc)),
                    {ExitCode, Output}
            end
    end.
