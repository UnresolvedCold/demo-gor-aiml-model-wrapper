%%%-------------------------------------------------------------------
%% @doc demo public API
%% @end
%%%-------------------------------------------------------------------

-module(demo_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    Model = aiml_model_wrapper:init("storable_to_pps_queue_model", "1.0.0", "python3"),
    Pid1 = spawn(fun() -> predict(Model) end),
    Pid2 = spawn(fun() -> predict(Model) end),

    receive
        {Result, Pid} when Pid == Pid1 -> io:format("Process 1 finished: ~p~n", [Result]);
        {Result, Pid} when Pid == Pid2 -> io:format("Process 2 finished: ~p~n", [Result])
    end,

    demo_sup:start_link().

predict(Model)->
    Features = sample:get_features_somehow(),
    io:format("idc_time: ~p~n", [maps:get(idc_time, Features)]),
    io:format("x_goal: ~p~n", [maps:get(x_goal, Features)]),
    io:format("x_start: ~p~n", [maps:get(x_start, Features)]),
    io:format("y_goal: ~p~n", [maps:get(y_goal, Features)]),
    io:format("y_start: ~p~n", [maps:get(y_start, Features)]),
    io:format("Starting Prediction~n"),
    Result = aiml_model_wrapper:evaluate(Model, Features),
    io:format("Result: ~p~n", [Result]),
    self() ! {Result, self()}.

stop(_State) ->
    ok.

%% internal functions