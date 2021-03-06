# Generated by the protocol buffer compiler.  DO NOT EDIT!
# Source: google/logging/v2/logging_metrics.proto for package 'google.logging.v2'
# Original file comments:
# Copyright 2016 Google Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'grpc'
require 'google/logging/v2/logging_metrics_pb'

module Google
  module Logging
    module V2
      module MetricsServiceV2
        # Service for configuring logs-based metrics.
        class Service

          include GRPC::GenericService

          self.marshal_class_method = :encode
          self.unmarshal_class_method = :decode
          self.service_name = 'google.logging.v2.MetricsServiceV2'

          # Lists logs-based metrics.
          rpc :ListLogMetrics, ListLogMetricsRequest, ListLogMetricsResponse
          # Gets a logs-based metric.
          rpc :GetLogMetric, GetLogMetricRequest, LogMetric
          # Creates a logs-based metric.
          rpc :CreateLogMetric, CreateLogMetricRequest, LogMetric
          # Creates or updates a logs-based metric.
          rpc :UpdateLogMetric, UpdateLogMetricRequest, LogMetric
          # Deletes a logs-based metric.
          rpc :DeleteLogMetric, DeleteLogMetricRequest, Google::Protobuf::Empty
        end

        Stub = Service.rpc_stub_class
      end
    end
  end
end
