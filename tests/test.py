from streaming_feature_simulator.sql_generator import sql_generator

test_input = '/Users/haoliu/github/Streaming_Feature_Simulator/streaming_feature_simulator/config/example_sliding_window_order_attempt.json'
sql = sql_generator(test_input)
print(sql)

