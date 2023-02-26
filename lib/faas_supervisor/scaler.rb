# frozen_string_literal: true

class FaasSupervisor::Scaler
  include FaasSupervisor::Helpers

  option :function, type: T.Instance(Openfaas::Function)
  option :parent, type: T.Interface(:async)

  inject :openfaas

  def run
    timer.start
    info { "Started, update interval: #{config.update_interval}" }
  end

  private

  memoize def timer = Async::Timer.new(config.update_interval, start: false, run_on_start: true, parent:) { cycle }
  memoize def policy = ScalingPolicies::Simple.new(function:, parent:)

  def logger_info = "Function = #{function.name.inspect}"
  def config = function.supervisor_config.autoscaling

  # TODO: add timeout
  def cycle
    debug { "Checking..." }

    old_scale, new_scale = policy.calculate

    return debug { "No changes in scaling" } if old_scale == new_scale

    info { "Scaling from #{old_scale} to #{new_scale}..." }
    # openfaas.scale(function.name, new_scale)
  rescue StandardError => e
    warn(e)
  end
end
