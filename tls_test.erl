-module(tls_test).

-export([start/0]).

start() ->
    ssl:start(),
    Opts = [
            %% {versions, ['tlsv1.3','tlsv1.2']},
            {cacertfile, "./certs/ca_certificate.pem"},
            {certfile,   "./certs/client_localhost_certificate.pem"},
            {keyfile,    "./certs/client_localhost_key.pem"},
            {reuseaddr, true},
            {verify, verify_peer},
            {fail_if_no_peer_cert, true},
            {log_level, debug}
           ],
    ok = ssl:start(),
    {ok, Socket} = ssl:connect("localhost", 5681, Opts),
    io:format("~n~n~n[INFO] connected to port 5681!~n~n~n"),
    timer:sleep(1000),
    ok = ssl:close(Socket).
