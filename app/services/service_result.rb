# Standard result envelope for service objects.
#
# Every service's #call should return either:
#   ServiceResult.success(data) → { ok: true,  data: ... }
#   ServiceResult.error(error)  → { ok: false, error: ... }
#
# Services can also `include ServiceResult` and use the bare `success(...)` /
# `error(...)` helpers internally. Callers always pattern-match on `:ok`.
#
# Example:
#   class PublishPostService
#     include ServiceResult
#
#     def call(post)
#       return error("Post not found") if post.nil?
#       post.update!(published: true)
#       success(post: post)
#     rescue ActiveRecord::RecordInvalid => e
#       error(e.record)
#     end
#   end
module ServiceResult
  module_function

  def success(data = nil)
    { ok: true, data: data }
  end

  def error(error)
    { ok: false, error: error }
  end
end
