# frozen_string_literal: true

def retry_operation(retry_times: 3, sleep_interval: 3.seconds, expected_value: nil)
  result = nil

  retry_times.times.each do
    result = yield
    break if result == expected_value

    sleep(sleep_interval)
  end

  result
end
