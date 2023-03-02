# frozen_string_literal: true

class App::Metrics::RubyRuntimeMonitor
  include App::Helpers
  include Bus::Publisher

  INTERVAL = 2

  def run
    Async::Timer.new(INTERVAL, run_on_start: true, call: self, on_error: ->(e) { warn(e) })
    info { "Started" }
  end

  def call
    fibers = ObjectSpace.each_object(Fiber)
    threads = ObjectSpace.each_object(Thread)
    ractors = ObjectSpace.each_object(Ractor)

    publish_event("metrics.updated", ruby_fibers: { value: fibers.count },
                                     ruby_fibers_active: { value: fibers.count(&:alive?) },
                                     ruby_threads: { value: threads.count },
                                     ruby_threads_active: { value: threads.count(&:alive?) },
                                     ruby_ractors: { value: ractors.count },
                                     ruby_memory: { value: GetProcessMem.new.bytes.to_s("F"), suffix: "bytes" })
  end
end
