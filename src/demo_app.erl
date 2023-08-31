%%%-------------------------------------------------------------------
%% @doc demo public API
%% @end
%%%-------------------------------------------------------------------

-module(demo_app).

-behaviour(application).

-export([start/2]).

start(_StartType, _StartArgs) ->
    pmml_parser:load_model("storable_to_pps_queue_model", "1.0.0"),
    X = #{"idc_time"=>"80","x_start"=>"50","x_goal"=>"50","y_start"=>"150","y_goal"=>"150"},
    Y = pmml_parser:evaluate(X),
    io:format("Input: ~p~n", [X]),
    io:format("Output: ~s~n", [Y]),
    demo_sup:start_link().
