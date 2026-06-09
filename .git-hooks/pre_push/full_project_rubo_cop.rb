module Overcommit::Hook::PrePush
  class FullProjectRuboCop < Base
    def run
      result = execute([ "bundle", "exec", "rubocop" ])
      return :pass if result.success?

      [
        :fail,
        result.stdout.to_s.empty? ? result.stderr : result.stdout
      ]
    end
  end
end
